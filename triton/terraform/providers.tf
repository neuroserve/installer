terraform {
  required_version = ">= 1.0.0"

  required_providers {
    triton = {
      source = "joyent/triton"
      version = "0.8.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
  }
}
provider "triton" {
  account = "hbloed"
  key_id  = "c7:6d:b4:e9:f9:33:44:7d:cb:6e:58:41:b6:b6:7f:c7"
  url     = "https://cloudapi.de-gt-2.cns.tgos.xyz/"
  insecure_skip_tls_verify = false
}
