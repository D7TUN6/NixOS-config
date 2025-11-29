{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  fileSystems = {
    "/" = {
      device = "/dev/mapper/drive-desktop-luks-main";
      fsType = "btrfs";
      options = [
        "subvol=@root"
        "defaults"
        "noatime"
        "compress=zstd:19"
        "ssd"
        "discard=async"
        "space_cache=v2"
        "autodefrag"
      ];
    };
    "/nix" = {
      device = "/dev/mapper/drive-desktop-luks-main";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "defaults"
        "noatime"
        "compress=zstd:19"
        "ssd"
        "discard=async"
        "space_cache=v2"
        "autodefrag"
      ];
    };
    "/etc/nixos" = {
      device = "/dev/mapper/drive-desktop-luks-main";
      fsType = "btrfs";
      options = [
        "subvol=@nixos"
        "defaults"
        "noatime"
        "compress=zstd:19"
        "ssd"
        "discard=async"
        "space_cache=v2"
        "autodefrag"
      ];
    };
    "/home" = {
      device = "/dev/mapper/drive-desktop-luks-main";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "defaults"
        "noatime"
        "compress=zstd:19"
        "ssd"
        "discard=async"
        "space_cache=v2"
        "autodefrag"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/drive-desktop-esp";
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
    algorithm = "zstd";
    memoryPercent = 100;
  };
}
