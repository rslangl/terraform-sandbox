{ pkgs ? import ./nixpkgs.nix }:

  let tools = with pkgs; [
    terraform
    vagrant
  ];

  in pkgs.mkShell {
    packages = tools;
    inputsFrom = with pkgs; all;
  }
