{ pkgs ? import <nixpkgs> {} }:

with pkgs;
pkgs.mkShell {
  buildInputs = [
    terraform
    nodePackages.cdktf-cli
  ];
}
