host_project_id = "my-host-project-id"
default_region  = "europe-west2"
network_name    = "prod-shared-vpc"
routing_mode    = "GLOBAL"

auto_create_subnetworks         = false
delete_default_routes_on_create = false

service_project_ids = [
  "my-service-project-1",
  "my-service-project-2"
]

subnets = [
  {
    name           = "prod-subnet-lon"
    region         = "europe-west2"
    cidr           = "10.10.0.0/24"
    purpose        = "Production workloads - London"
    private_access = true
    flow_logs      = true
  },
  {
    name           = "prod-subnet-bel"
    region         = "europe-west1"
    cidr           = "10.10.1.0/24"
    purpose        = "Production workloads - Belgium"
    private_access = true
    flow_logs      = false
  }
]

firewall_rules = [
  {
    name          = "allow-internal"
    priority      = 1000
    direction     = "INGRESS"
    action        = "ALLOW"
    source_ranges = ["10.10.0.0/16"]
    rules = [
      { protocol = "tcp", ports = ["0-65535"] },
      { protocol = "udp", ports = ["0-65535"] },
      { protocol = "icmp" }
    ]
  },
  {
    name          = "allow-iap-ssh"
    priority      = 1000
    direction     = "INGRESS"
    action        = "ALLOW"
    source_ranges = ["35.235.240.0/20"]
    rules = [
      { protocol = "tcp", ports = ["22", "3389"] }
    ]
  },
  {
    name          = "deny-telnet"
    priority      = 900
    direction     = "INGRESS"
    action        = "DENY"
    source_ranges = ["0.0.0.0/0"]
    rules = [
      { protocol = "tcp", ports = ["23"] }
    ]
  }
]

dns_zones = [
  {
    name        = "internal-zone"
    dns_name    = "internal.example.com."
    description = "Private internal zone"
    visibility  = "private"
  }
]