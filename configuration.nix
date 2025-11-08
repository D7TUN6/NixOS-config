{
  config,
  pkgs,
  lib,
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./modules/boot.nix
    ./modules/filesystems.nix
    ./modules/networking.nix
    ./modules/locale.nix
    ./modules/services.nix
    ./modules/security.nix
    ./modules/system.nix
    ./modules/users.nix
    ./modules/systemd.nix
    ./modules/programs.nix
    ./modules/hardware.nix
    ./modules/console.nix
    ./modules/nix.nix
    ./modules/nixpkgs.nix
    ./modules/environment.nix
    ./modules/virtualisation.nix
    ./modules/powermanagement.nix
  ];
}
