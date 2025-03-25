provider "proxmox" {
  #endpoint = var.pve_endpoint
  #username = var.pve_username
  #password = var.pve_password

  endpoint = lookup(var.pve_config[terraform.workspace], "endpoint", "")
  username = lookup(var.pve_config[terraform.workspace], "username", "")
  password = lookup(var.pve_config[terraform.workspace], "password", "")

  insecure = true

  ssh {
    agent = true
  }
}

