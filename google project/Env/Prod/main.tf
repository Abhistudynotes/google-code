
provider "google" {
  project = var.host_project_id
  region  = var.default_region
}

module "shared_vpc" {
  source = "../../module/shared_vpc"

  host_project_id                 = var.host_project_id
  network_name                    = var.network_name
  routing_mode                    = var.routing_mode
  auto_create_subnetworks         = var.auto_create_subnetworks
  delete_default_routes_on_create = var.delete_default_routes_on_create

  service_project_ids = var.service_project_ids
  subnets             = var.subnets
  firewall_rules      = var.firewall_rules
  dns_zones           = var.dns_zones
}