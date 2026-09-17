{
  lib,
  inputs,
  ...
}: let
  nixpkgs-stable = inputs.nixpkgs-stable;
in {
  nixpkgs.config.rewriteURL = lib.mkForce (url: url);
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.12"
        "electron-40.10.5"
        "dcraw-9.28.0"
      ];
    };
    overlays = [
      (final: prev: {
        inherit
          (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;

        stable = import nixpkgs-stable {
          system = final.stdenv.hostPlatform.system;
          config = final.config;
        };
      })
    ];
  };
}
