{ pkgs ? import ./nixpkgs.nix }:

  let tools = with pkgs; [
    terraform
    vagrant
    qemu
    libvirt
    gcc
  ];

  in pkgs.mkShell {
    packages = tools;
    inputsFrom = with pkgs; tools;

    shellHook = ''
      vagrant plugin install vagrant-qemu
    '';
  }
