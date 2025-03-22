resource "proxmox_virtual_environment_vm" "vm" {
  name = "dev"
  node_name = "wintermute"
  tags = ["terraform"]
  
  agent {
    enabled = true
  }

  cpu {
    cores = var.vm_cores
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    datastore_id = "local-zfs"
    file_id = "local:iso/alpine.img"
    interface = "virtio0"
    size = var.vm_disk
  }

  initialization {
    datastore_id = "local-zfs"
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys = [trimspace(tls_private_key.vm_key.public_key_openssh)]
      password = random_password.vm_password.result
      username = "herder"
    }
  }

  startup {
    order = "3"
    up_delay = "60"
    down_delay = "60"
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "random_password" "vm_password" {
  length = 16
  override_special = "_%@"
  special = true
}

resource "tls_private_key" "vm_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

output "vm_ip" {
  value = proxmox_virtual_environment_vm.vm.ipv4_addresses
}

output "vm_password" {
  value = random_password.vm_password.result
  sensitive = true
}

output "vm_private_key" {
  value = tls_private_key.vm_key.private_key_pem
  sensitive = true
}

output "vm_public_key" {
  value = tls_private_key.vm_key.public_key_openssh
}
