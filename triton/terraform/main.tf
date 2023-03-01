# -----------------------------------------------------------------------------
# Hashistack + Fermyon Platform versions
# -----------------------------------------------------------------------------

locals {
  dependencies = yamldecode(file("../../share/terraform/dependencies.yaml"))
}

# -----------------------------------------------------------------------------
# Instance config
# -----------------------------------------------------------------------------
data "triton_account" "main" {}

data "triton_image" "os" {
    name = "ubuntu-focal"
    version = var.image_version
}

resource "triton_machine" "spin" {
    name = var.instance_name
    package = var.package_name

    image = data.triton_image.os.id

    cns {
        services = ["spin"]
    }

    networks = var.machine_networks

    tags = {
        role = "spin"
    }
    
    affinity = ["role!=~spin"]

    connection {
        host = self.primaryip
        type = "ssh"
        user = "ubuntu"
    }

 # Add config files, scripts, Nomad jobs to host
provisioner "file" {
    source      = "../../share/terraform/vm_assets/"
    destination = "/var/tmp"
}
  
user_script = templatefile("../../share/terraform/scripts/startup.sh",
    {
      home_path          = "/var/tmp"
#       dns_zone           = var.dns_host == "sslip.io" ? "${triton_machine.spin.primaryip}.${var.dns_host}" : var.dns_host,
      dns_zone           = var.dns_host == "fermyon.inst.${data.triton_account.main.id}.${var.cns_suffix}"      
enable_letsencrypt = var.enable_letsencrypt,

      nomad_version  = local.dependencies.nomad.version,
      nomad_checksum = local.dependencies.nomad.checksum,

      consul_version  = local.dependencies.consul.version,
      consul_checksum = local.dependencies.consul.checksum,

      vault_version  = local.dependencies.vault.version,
      vault_checksum = local.dependencies.vault.checksum,

      traefik_version  = local.dependencies.traefik.version,
      traefik_checksum = local.dependencies.traefik.checksum,

      bindle_version  = local.dependencies.bindle.version,
      bindle_checksum = local.dependencies.bindle.checksum,

      spin_version  = local.dependencies.spin.version,
      spin_checksum = local.dependencies.spin.checksum,

      hippo_version           = local.dependencies.hippo.version,
      hippo_checksum          = local.dependencies.hippo.checksum,
      hippo_registration_mode = var.hippo_registration_mode
      hippo_admin_username    = var.hippo_admin_username
      # TODO: ideally, Hippo will support ingestion of the admin password via
      # its hash (eg bcrypt, which Traefik and Bindle both support) - then we can remove
      # the need to pass the raw value downstream to the scripts, Nomad job, ecc.
      hippo_admin_password = random_password.hippo_admin_password.result,
    }
  )
}

# -----------------------------------------------------------------------------
# Hippo admin password
# -----------------------------------------------------------------------------

resource "random_password" "hippo_admin_password" {
  length           = 22
  special          = true
  override_special = "!#%&*-_=+<>:?"
}
