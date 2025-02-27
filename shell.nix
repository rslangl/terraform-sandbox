{ pkgs ? import ./nixpkgs.nix }:

  let tools = with pkgs; [
    terraform
    vagrant
    virtualbox
  ];

  in pkgs.mkShell {
    packages = tools;
    inputsFrom = with pkgs; tools;
  }
