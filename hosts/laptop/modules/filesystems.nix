{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  fileSystems = {
    "/" = {
      device = "zpool-laptop-main";
      fsType = "zfs";
      options = [
        "zfsutil"
      ];
    };
    "/nix" = {
      device = "zpool-laptop-main/root/nix";
      fsType = "zfs";
      options = [
        "zfsutil"
      ];
    };
    "/etc/nixos" = {
      device = "zpool-laptop-main/root/nixos";
      fsType = "zfs";
      options = [
        "zfsutil"
      ];
    };
    "/home" = {
      device = "zpool-laptop-main/root/home";
      fsType = "zfs";
      options = [
        "zfsutil"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/disk-laptop-boot";
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
