variable "region" {
  description = "Triton datacenter (Default: de-gt-2)"
  type        = string
  default     = "de-gt-2"
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
  description = "Version of the image used (Default: 2023030101)"
  type        = string
  default     = "2023030101"
}

variable "machine_networks" {
  description = "The networks, the instance should be connected to (Default: My-Fabric-Network and Public Network)"
  type        = list
  default     = ["aa3f924b-05b8-41ce-b638-cdd7246f3d7a", "2fa4d4ed-fd46-4469-9b95-f7a61d4f9089"]
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
