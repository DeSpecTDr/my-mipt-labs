{
  description = "A basic flake with a shell";
  inputs = {
    # nixpkgs.url = "nixpkgs";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";

    unstable.url = "nixpkgs/nixpkgs-unstable";
    unstable-small.url = "nixpkgs/nixos-unstable-small";
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig.extra-substituters = ["https://numtide.cachix.org"];
  nixConfig.extra-trusted-public-keys = ["numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="];

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unfree,
    flake-utils,
    unstable,
    unstable-small,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      unfree = nixpkgs-unfree.legacyPackages.${system};
      small = unstable-small.legacyPackages.${system};
      # pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
      # unst = unstable.legacyPackages.${system};
      # packageOverrides = pkgs.callPackage ./python-packages.nix {};
      # python = pkgs.python3.override {inherit packageOverrides;};
    in rec {
      devShells.default = pkgs.mkShell rec {
        nativeBuildInputs = with pkgs; [
          # sccache
          evcxr
          # rust-analyzer
          # mold
          sageWithDoc

          # pkg-config
          gcc
          ninja
          cmake
          clang-tools
          llvmPackages_latest.clang

          conda

          # small.typst-lsp
        ];
        buildInputs = [
          (
            pkgs.python311.withPackages
            (ps:
              with ps; [
                jupyter
                black
                # selenium
                # jupyterhub
                ipykernel
                ipympl
                matplotlib
                numpy
                scipy
                astropy
                pandas
                odfpy
                ephem # Compute positions of the planets and stars
                # astroquery
                sympy
                opencv4
                autopep8 # format cell
                psutil
                # pip
                # virtualenv
                # jupynium
                # stingray
                pyfftw
                # numba
                # unfree.python310Packages.torch-bin
                toml

                # прога
                pytelegrambotapi
                xmltodict
                defusedxml
                translatepy
              ])
          )
        ];
        LD_LIBRARY_PATH = nixpkgs.lib.makeLibraryPath buildInputs;
      };
    });
}
