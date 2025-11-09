{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  fileSystems = {
    "/" = {
      device = "zroot/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/nix" = {
      device = "zroot/root/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/etc/nixos" = {
      device = "zroot/root/nixos";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/home" = {
      device = "zroot/root/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/EF37-2B27";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 100;
  };
}
