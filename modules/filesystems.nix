{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "ext4";
      options = [
        "noatime"
        "relatime"
        "commit=300"
        "data=ordered"
      ];
    };

    #"/home" = {
    #  device = "/dev/mapper/cryptroot";
    #  fsType = "btrfs";
    #  options = [
    #    "subvol=home"
    #    "compress-force=zstd:15"
    #    "noatime"
    #    "ssd"
    #    "discard=async"
    #    "ssd_spread"
    #    "max_inline=256"
    #    "commit=300"
    #    "space_cache=v2"
    #  ];
    #};

    "/home/d7tun6/secondSSD" = {
      device = "/dev/mapper/cryptssd";
      fsType = "btrfs";
      neededForBoot = false;
      options = [
        "subvol=home"
        "compress-force=zstd:15"
        "noatime"
        "ssd"
        "discard=async"
        "ssd_spread"
        "max_inline=256"
        "commit=300"
        "space_cache=v2"
      ];
    };

    "/home/d7tun6/tripleHDD" = {
      device = "/dev/mapper/crypthdd";
      fsType = "btrfs";
      neededForBoot = false;
      options = [
        "compress-force=zstd:15"
        "noatime"
      ];
    };

    #"/nix" = {
    #  device = "/dev/mapper/cryptroot";
    #  fsType = "btrfs";
    #  options = [
    #    "subvol=nix"
    #    "compress-force=zstd:15"
    #    "noatime"
    #    "ssd"
    #    "discard=async"
    #    "ssd_spread"
    #    "max_inline=256"
    #    "commit=300"
    #    "space_cache=v2"
    #  ];
    #};

    #"/etc/nixos" = {
    #  device = "/dev/mapper/cryptroot";
    #  fsType = "btrfs";
    #  options = [
    #    "subvol=nixos"
    #    "compress-force=zstd:15"
    #    "noatime"
    #    "ssd"
    #    "discard=async"
    #    "ssd_spread"
    #    "max_inline=256"
    #    "commit=300"
    #    "space_cache=v2"
    #  ];
    #};

    "/boot" = {
      device = "/dev/disk/by-uuid/00FE-F2D7";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
        "umask=0077"
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
