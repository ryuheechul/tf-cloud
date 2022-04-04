{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  tf-helper = import nix/tf-helper.nix { pkgs=pkgs; };
in
pkgs.mkShell {
  buildInputs = [
    terraform
    nodePackages.cdktf-cli
    nodePackages.npm
    tf-helper
  ];
}
