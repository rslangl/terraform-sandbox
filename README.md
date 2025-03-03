# terraform-sandbox

Testing various TF schtuff on a VBox target.

## Requirements

Use nix-shell like a based heretic, tldr:
```shell
# Install nix
curl -L https://nixos.org/nix/install | sh

# (Optional) Enable experimental features to search packages from CLI
nix --extra-experimental-features "nix-command flakes" search nixpkgs terraform
```

## Usage

```shell
# Launch nix-shell
nix-shell

# launch Vagrant:
vagrant up --provider=qemu
```

## References

* [Proxmox VE inside VirtualBox](https://pve.proxmox.com/wiki/Proxmox_VE_inside_VirtualBox)
* [VirtualBox configuration](https://developer.hashicorp.com/vagrant/docs/providers/virtualbox/configuration)
