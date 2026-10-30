output "network_name" {
  value = module.shared_vpc.network_name
}

output "network_self_link" {
  value = module.shared_vpc.network_self_link
}

output "subnet_self_links" {
  value = module.shared_vpc.subnet_self_links
}

output "firewall_rule_names" {
  value = module.shared_vpc.firewall_rule_names
}

output "service_project_ids" {
  value = module.shared_vpc.service_project_ids
}

output "dns_zone_names" {
  value = module.shared_vpc.dns_zone_names
}