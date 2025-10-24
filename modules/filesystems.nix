{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };

    "/home" = {
      device = "/dev/mapper/cryptdisk";
      fsType = "btrfs";
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

    "/home/d7tun6/secondSSD" = {
      device = "/dev/mapper/cryptssd";
      fsType = "btrfs";
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

    #  "/run/libvirt" = {
    #   device = "/dev/mapper/cryptssd";
    #   fsType = "btrfs";
    #   options = [
    #     "subvol=vm"
    #     "compress-force=zstd:15"
    #     "noatime"
    #     "ssd"
    #     "discard=async"
    #     "ssd_spread"
    #     "max_inline=256"
    #     "commit=300"
    #     "space_cache=v2"
    #   ];
    # };


    "/home/d7tun6/tripleHDD" = {
      device = "/dev/mapper/crypthdd";
      fsType = "btrfs";
      options = [
        "compress-force=zstd:15"
        "noatime"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/cryptdisk";
      fsType = "btrfs";
      options = [
        "subvol=nix"
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

    "/etc/nixos" = {
      device = "/dev/mapper/cryptdisk";
      fsType = "btrfs";
      options = [
        "subvol=nixos"
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

    "/var/log" = {
      device = "/dev/mapper/cryptdisk";
      fsType = "btrfs";
      options = [
        "subvol=log"
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

    "/boot" = {
      device = "/dev/disk/by-uuid/F7D4-86A0";
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
