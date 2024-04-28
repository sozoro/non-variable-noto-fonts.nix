{
  description = "non variable noto fonts";

  inputs = {
    nixpkgs.url     = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, ... }@inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems   = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    perSystem = { pkgs, system, ... }: {
      packages = with pkgs;
        (import ./default.nix {
          inherit stdenv stdenvNoCC lib fetchFromGitHub fetchurl;
          inherit cairo nixosTests pkg-config;
          inherit pngquant which imagemagick zopfli buildPackages;
          inherit fontforge writeScript;
        }) // { default = self.packages."${system}".noto-fonts; };
    };
  };
}
