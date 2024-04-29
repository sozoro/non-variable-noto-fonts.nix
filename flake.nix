{
  description = "non variable noto fonts";

  inputs = {
    nixpkgs.url     = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, ... }@inputs: (inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems   = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    perSystem = { pkgs, system, ... }: {
      packages = (pkgs.callPackage ./default.nix {}) // {
        default = self.packages."${system}".noto-fonts;
      };
    };
  }) // {
    name         = "non-variable-noto-fonts";
    nixosModules = rec {
      addpkg = { pkgs, ... }: {
        nixpkgs.config = {
          packageOverrides = oldpkgs: let newpkgs = oldpkgs.pkgs; in {
            "${self.name}" = self.packages."${pkgs.system}";
          };
        };
      };

      installFonts = notoFonts: { pkgs, ... }: (addpkg { inherit pkgs; }) // {
        fonts.packages = map (fontName: pkgs."${self.name}"."${fontName}") notoFonts;
      };
    };
  };
}
