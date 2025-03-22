terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

module "dev" {
  source = "./modules/dev"
}
