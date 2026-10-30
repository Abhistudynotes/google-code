variable "host_project_id" {
  description = "Shared VPC host project ID."
  type        = string
}

variable "default_region" {
  description = "Default provider region."
  type        = string
  default     = "europe-west2"
}

variable "network_name" {
  description = "Shared VPC network name."
  type        = string
}

variable "routing_mode" {
  description = "VPC routing mode."
  type        = string
  default     = "GLOBAL"
}

variable "auto_create_subnetworks" {
  description = "Whether auto subnet creation is enabled."
  type        = bool
  default     = false
}

variable "delete_default_routes_on_create" {
  description = "Whether default routes are deleted when VPC is created."
  type        = bool
  default     = false
}

variable "service_project_ids" {
  description = "Service project IDs attached to the Shared VPC host."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Subnet definitions."

  type = list(object({
    name           = string
    region         = string
    cidr           = string
    purpose        = string
    private_access = bool
    flow_logs      = bool
  }))

  default = []
}

variable "firewall_rules" {
  description = "Firewall rule definitions."

  type = list(object({
    name          = string
    priority      = number
    direction     = string
    action        = string
    source_ranges = list(string)

    rules = list(object({
      protocol = string
      ports    = optional(list(string), [])
    }))
  }))

  default = []
}

variable "dns_zones" {
  description = "Cloud DNS managed zone definitions."

  type = list(object({
    name        = string
    dns_name    = string
    description = string
    visibility  = string
  }))

  default = []
}