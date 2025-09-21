{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/33ae5d30-b4df-44f2-a815-92e28facb4ad";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress-force=zstd:3"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/33ae5d30-b4df-44f2-a815-92e28facb4ad";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress-force=zstd:3"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1061-8B01";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["defaults" "size=16G" "mode=1777"];
    };
  };

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 100;
  };
}
