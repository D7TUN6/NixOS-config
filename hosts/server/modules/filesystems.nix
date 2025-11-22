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
      options = [
        "zfsutil"
      ];
    };
    "/nix" = {
      device = "zroot/root/nix";
      fsType = "zfs";
      options = [
        "zfsutil"
      ];
    };
    "/etc/nixos" = {
      device = "zroot/root/nixos";
      fsType = "zfs";
      options = [
        "zfsutil"
      ];
    };
    "/home" = {
      device = "zroot/root/home";
      fsType = "zfs";
      options = [
        "zfsutil"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/EF37-2B27";
      fsType = "vfat";
      options = [
        "defaults"
        "uid=0"
        "gid=0"          
        "umask=0077"
        "nofail"
      ];
    };
  };

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 100;
  };
}
