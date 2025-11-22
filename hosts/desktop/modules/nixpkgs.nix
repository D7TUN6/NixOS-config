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
      allowInsecure = true;
      allowUnfree = true;
      allowBroken = true;
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.05"
        "ventoy-gtk3-1.1.07"
      ];
    };
  };
}
