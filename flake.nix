{
  description = "Nixpkgs with my local modifications";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    {
      packages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          emacs = pkgs.emacs.pkgs.withPackages (ep: [ ep.vterm ]);
        }
      );

      checks = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
        with builtins;
        with nixpkgs.lib;
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          allOurSoftwareBuilds = pkgs.runCommand "get-my-software" {} ''
            ${concatMapStringsSep "\n"
              (pkg: "echo ${pkg} is at ${self.packages.${system}.${pkg}}"
              ) (builtins.attrNames self.packages.${system})}
            touch $out
          '';
        }
      );
    };
}
