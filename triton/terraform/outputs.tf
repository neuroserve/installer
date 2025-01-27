output "public_ip_address" {
  description = "The public IP address associated with the Triton instance"
  value       = triton_machine.spin.primaryip
}

output "dns_host" {
  description = "The DNS host to use for construction of the root domain for Fermyon Platform services and apps"
  value       = "svc.${data.triton_account.main.id}.${var.cns_suffix}"
}

output "bindle_url" {
  description = "The URL for the Bindle server"
  value       = "${var.enable_letsencrypt ? "https" : "http"}://bindle.${var.dns_host == "sslip.io" ? "svc.${data.triton_account.main.id}.${var.cns_suffix}" : var.dns_host}/v1"
}

output "hippo_url" {
  description = "The URL for the Hippo server"
  value       = "${var.enable_letsencrypt ? "https" : "http"}://hippo.${var.dns_host == "sslip.io" ? "svc.${data.triton_account.main.id}.${var.cns_suffix}" : var.dns_host}"
}

output "hippo_admin_username" {
  description = "Admin username for Hippo when running in AdministratorOnly mode"
  value       = var.hippo_admin_username
}

output "hippo_admin_password" {
  description = "Admin password for Hippo when running in AdministratorOnly mode"
  value       = random_password.hippo_admin_password.result
  sensitive   = true
}

output "environment" {
  description = "Get environment config by running: $(terraform output -raw environment)"
  sensitive   = true
  value       = <<EOM
export DNS_DOMAIN=${var.dns_host == "sslip.io" ? "svc.${data.triton_account.main.id}.${var.cns_suffix}" : var.dns_host}
export HIPPO_URL=${var.enable_letsencrypt ? "https" : "http"}://hippo.${var.dns_host == "sslip.io" ? "svc.${data.triton_account.main.id}.${var.cns_suffix}" : var.dns_host}
export HIPPO_USERNAME=${var.hippo_admin_username}
export HIPPO_PASSWORD=${random_password.hippo_admin_password.result}
export BINDLE_URL=${var.enable_letsencrypt ? "https" : "http"}://bindle.${var.dns_host == "sslip.io" ? "svc.${data.triton_account.main.id}.${var.cns_suffix}" : var.dns_host}/v1

EOM
}
