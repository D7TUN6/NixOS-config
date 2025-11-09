{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.05"
      ];
    };
  };
}
