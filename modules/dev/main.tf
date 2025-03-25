resource "proxmox_virtual_environment_file" "vm_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name = "wintermute"

  source_raw {
    data = <<-EOF
    # cloud-config
    users:
    - name: herder
      groups:
        - sudo
      shell: /bin/bash
      ssh_authorized_keys:
      sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "alpine-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name = "dev"
  node_name = "wintermute"
  #node_name = var.pve_config[terraform.workspace].node_name
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
    #vendor_data_file_id = proxmox_virtual_environment_file.vm_cloud_config.id

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

resource "null_resource" "configure_vm" {

  depends_on = [proxmox_virtual_environment_vm.vm]

  connection {
    type = "ssh"
    user = "herder"
    #private_key = file("./ssh/id_rsa")
    private_key = tls_private_key.vm_key.private_key_pem
    host = proxmox_virtual_environment_vm.vm.ipv4_addresses
    timeout = "1m"
  }

  provisioner "remote-exec" {
    inline = [
      "apk update",
      "apk upgrade --no-cache",
      "apk add --no-cache qemu-guest-agent net-tools openssh",
      "rc-status",
      "touch /run/openrc/softlevel",
      "rc-update add sshd default",
      "rc-service sshd start"
    ]
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

#output "vm_ip" {
#  value = proxmox_virtual_environment_vm.vm.ipv4_addresses[0][0]
#}

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
