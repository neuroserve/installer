# Triton README

This guide illustrates how to install Fermyon on Triton using Terraform.

As such, this is intended solely for evaluation and/or demo scenarios, i.e.
*not* for production.

All Hashistack (Nomad, Consul, Vault), Traefik and Fermyon platform processes run
without any redundancy on a single Triton instance. There is no data backup for any
service.

That being said, it should give users a quick look and feel for deploying apps
using Fermyon. By default, all apps will be accessible to the broader internet
(see the configuration details mentioned below). Additionally, when Let's Encrypt
is enabled, apps should be provided with https URLs and TLS certs.

# Prerequisites

- An account for a Triton cloud.
  - Triton should use CNS
  - bhyve should be available
  - Triton should provide a bhyve image for ubuntu-focal
  - if you want Let's encrypt enabled, at least one of the networks should be publicly accessable 

- The [terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform)

# Resources deployed

This example creates the following resources in the provided Triton account:
  - Triton instance type
    - Name: `${var.instance_name}` (default: `ubuntu-focal`) - a bhyve image with Ubuntu 20.04
    - Type: `${var.instance_size}` (default: `sample-bhyve-flex-2G`) - a bhyve package with 

# Security disclaimer

By default, the allowed inbound and SSH CIDR block is `0.0.0.0/0` aka The Entire Internet.

This example takes a stock Ubuntu 20.04 LTS and then proceeds to download Fermyon and Hashistack binaries,

# How to Deploy

First navigate to the `terraform` directory and initialize Terraform:

```console
cd terraform
terraform init
```
Then you probably want to change `image_version`, `package_name`, `machine_networks` and `cns_suffix` variables in variables.tf to match your Triton environment. In main.tf you would probably change the `triton_image` name.

The setup of the hashistack and the applications running on top of it need a valid DNS zone. This configuration tries to leverage Tritons CNS service for it. If that doesn't work, the setup tries to use sslip.io as a fall back. If DNS is valid, you could enable Let's encrypt in the traefik job file.

Deploy with all defaults (http-based URLs):

```console
terraform apply
```

Deploy with all defaults and use Let's Encrypt to provision certs for TLS/https:

```console
terraform apply -var='enable_letsencrypt=true'
```

Quick disclaimer when Let's Encrypt is enabled: if the DNS record does not propagate in time,
Let's Encrypt may incur a rate limit on your domain. Create the A record for *.example.com as soon as you can,
making sure it points to the provisioned public IP address.
See https://letsencrypt.org/docs/staging-environment/#rate-limits for more details.
