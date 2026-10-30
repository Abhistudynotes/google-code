variable "host_project_id" {
  description = "Shared VPC host project ID."
  type        = string
}

variable "network_name" {
  description = "Shared VPC network name."
  type        = string
}

variable "routing_mode" {
  description = "VPC routing mode."
  type        = string
  default     = "GLOBAL"

  validation {
    condition = contains(
      ["GLOBAL", "REGIONAL"],
      upper(var.routing_mode)
    )

    error_message = "routing_mode must be GLOBAL or REGIONAL."
  }
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

  validation {
    condition = alltrue([
      for rule in var.firewall_rules :
      contains(["ALLOW", "DENY"], upper(rule.action))
    ])

    error_message = "Firewall action must be ALLOW or DENY."
  }
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

  validation {
    condition = alltrue([
      for zone in var.dns_zones :
      contains(["public", "private"], lower(zone.visibility))
    ])

    error_message = "DNS visibility must be public or private."
  }
}