{ pkgs ? import <nixpkgs> {}, ... }:
with pkgs;
let
  non-variable-noto-fonts = import ./default.nix {
    inherit stdenv stdenvNoCC lib fetchFromGitHub fetchurl cairo nixosTests pkg-config;
    inherit pngquant which imagemagick zopfli buildPackages;
    inherit fontforge writeScript;
  };
in
  non-variable-noto-fonts.noto-fonts
