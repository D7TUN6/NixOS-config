{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
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
    ./modules/nix.nix
    ./modules/environment.nix
    ./modules/virtualisation.nix
  ];
}
