{
  description = "Nixpkgs with my local modifications";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, emacs-overlay, utils }:
    {
      packages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
        let pkgs = nixpkgs.legacyPackages.${system};
            emacsGit = emacs-overlay.packages.${system}.emacsGit;
            # emacsPkgs = pkgs.emacsPackagesNgFor emacsGit;
            emacsPkgs = pkgs.emacsPackagesNg;
        in {
          emacs = emacsPkgs.withPackages (ep: [ ep.vterm ]);
        }
      );

      checks = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
        with builtins;
        with nixpkgs.lib;
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          allOurSoftwareBuilds = pkgs.runCommand "get-my-software" {} ''
            ${concatMapStringsSep "\n"
              (pkg: "echo \"${pkg} is at ${self.packages.${system}.${pkg}}\" >&2"
              ) (builtins.attrNames self.packages.${system})}
            touch $out
          '';
        }
      );
    };
}
