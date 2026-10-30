

resource "google_compute_network" "shared_vpc" {
  project = var.host_project_id

  name                            = var.network_name
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = upper(var.routing_mode)
  delete_default_routes_on_create = var.delete_default_routes_on_create
}

# ---------------------------------------------------------------------
# Enable Shared VPC Host Project
# ---------------------------------------------------------------------

resource "google_compute_shared_vpc_host_project" "host" {
  project = var.host_project_id

  depends_on = [
    google_compute_network.shared_vpc
  ]
}

# ---------------------------------------------------------------------
# Subnets
# ---------------------------------------------------------------------

resource "google_compute_subnetwork" "subnets" {

  for_each = {
    for subnet in var.subnets :
    subnet.name => subnet
  }

  project = var.host_project_id

  name          = each.value.name
  region        = each.value.region
  ip_cidr_range = each.value.cidr

  network = google_compute_network.shared_vpc.self_link

  private_ip_google_access = each.value.private_access

  description = each.value.purpose

  dynamic "log_config" {
    for_each = each.value.flow_logs ? [1] : []

    content {
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }

  depends_on = [
    google_compute_network.shared_vpc
  ]
}

# ---------------------------------------------------------------------
# Firewall Rules
# ---------------------------------------------------------------------

resource "google_compute_firewall" "rules" {

  for_each = {
    for rule in var.firewall_rules :
    rule.name => rule
  }

  project = var.host_project_id

  name      = each.value.name
  network   = google_compute_network.shared_vpc.name
  priority  = each.value.priority
  direction = upper(each.value.direction)

  source_ranges = each.value.source_ranges

  dynamic "allow" {

    for_each = upper(each.value.action) == "ALLOW" ? each.value.rules : []

    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {

    for_each = upper(each.value.action) == "DENY" ? each.value.rules : []

    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  depends_on = [
    google_compute_network.shared_vpc
  ]
}

# ---------------------------------------------------------------------
# Shared VPC Service Project Attachments
# ---------------------------------------------------------------------

resource "google_compute_shared_vpc_service_project" "service_projects" {

  for_each = toset(var.service_project_ids)

  host_project    = var.host_project_id
  service_project = each.value

  depends_on = [
    google_compute_shared_vpc_host_project.host
  ]
}

# ---------------------------------------------------------------------
# Cloud DNS Managed Zones
# ---------------------------------------------------------------------

resource "google_dns_managed_zone" "zones" {

  for_each = {
    for zone in var.dns_zones :
    zone.name => zone
  }

  project = var.host_project_id

  name        = each.value.name
  dns_name    = each.value.dns_name
  description = each.value.description
  visibility  = lower(each.value.visibility)

  dynamic "private_visibility_config" {

    for_each = lower(each.value.visibility) == "private" ? [1] : []

    content {
      networks {
        network_url = google_compute_network.shared_vpc.self_link
      }
    }
  }

  depends_on = [
    google_compute_network.shared_vpc
  ]
}