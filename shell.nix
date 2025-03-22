{ pkgs ? import ./nixpkgs.nix }:

  let tools = with pkgs; [
    terraform
    vagrant
    qemu
    libvirt
    gcc
    sttr
  ];

  in pkgs.mkShell {
    packages = tools;
    inputsFrom = with pkgs; tools;

    shellHook = ''
      function set_pve_password() {
        read -sp "Enter PVE password: " pve_pw
        pve_pw=$(echo $pve_pw | head -c -1)
        export PROXMOX_PVE_PASSWORD="$pve_pw"
      }

      vagrant plugin install vagrant-qemu
    '';
  }
