{
  description = "A basic flake with a shell";
  inputs = {
    # nixpkgs.url = "nixpkgs";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";

    unstable.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig.extra-substituters = ["https://numtide.cachix.org"];
  nixConfig.extra-trusted-public-keys = ["numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="];

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unfree,
    flake-utils,
    unstable,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      unfree = nixpkgs-unfree.legacyPackages.${system};
      # pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
      # unst = unstable.legacyPackages.${system};
      # packageOverrides = pkgs.callPackage ./python-packages.nix {};
      # python = pkgs.python3.override {inherit packageOverrides;};
    in {
      devShells.default = pkgs.mkShell rec {
        nativeBuildInputs = with pkgs; [
          # sccache
          # evcxr
          # rust-analyzer
          # mold
          sageWithDoc
        ];
        buildInputs = [
          (
            pkgs.python310.withPackages
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
                ephem # Compute positions of the planets and stars
                # astroquery
                sympy
                opencv4
                autopep8 # format cell
                psutil
                # pip
                virtualenv
                # jupynium
                # stingray
                pyfftw
                numba
                unfree.python310Packages.torch-bin
              ])
          )
        ];
        LD_LIBRARY_PATH = nixpkgs.lib.makeLibraryPath buildInputs;
      };
    });
}
