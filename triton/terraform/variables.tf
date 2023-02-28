variable "region" {
  description = "Civo region (Default: nyc1)"
  type        = string
  default     = "NYC1"
}

variable "network_name" {
  description = "The name of the network; should be unique if multiple are launched in the same project (Default: fermyon)"
  type        = string
  default     = "fermyon"
}

variable "instance_name" {
  description = "The name of the Triton instance; should be unique if multiple are launched in the same region"
  type        = string
  default     = "fermyon"
}

variable "package_name" {
  description = "The name of the Triton package to use for the instance (Default: sample-bhyve-flex-2G)"
  type        = string
  default     = "sample-bhyve-flex-2G"
}

variable "image_version" {
  description = "Version of the image used (Default: 20230127)"
  type        = string
  default     = "2023032701"
}

variable "machine_networks" {
  description = "The networks, the instance should be connected to (Default: My-Fabric-Network and Public Network)"
  type        = list
  default     = ["4ac1c947-4786-4958-b0e5-c4e0b0ca3133", "2fa4d4ed-fd46-4469-9b95-f7a61d4f9089"]
} 

variable "enable_letsencrypt" {
  description = "Enable cert provisioning via Let's Encrypt"
  type        = bool
  default     = false
}

variable "dns_host" {
  description = "The DNS host to use for construction of the root domain for Fermyon Platform services and apps"
  type        = string
  default     = "sslip.io"
}

variable "hippo_admin_username" {
  description = "Admin username for Hippo when running in AdministratorOnly mode"
  type        = string
  default     = "admin"
}

variable "hippo_registration_mode" {
  description = "The registration mode for Hippo. Options are 'Open', 'Closed' and 'AdministratorOnly'. (Default: AdministratorOnly)"
  type        = string
  default     = "AdministratorOnly"

validation {
    condition     = var.hippo_registration_mode == "Open" || var.hippo_registration_mode == "Closed" || var.hippo_registration_mode == "AdministratorOnly"
    error_message = "The Hippo registration mode must be 'Open', 'Closed' or 'AdministratorOnly'."
  }
}
