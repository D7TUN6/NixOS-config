{...}: {
  fileSystems = {
    "/" = {
      device = "/dev/mapper/drive-desktop-luks-main";
      fsType = "btrfs";
      options = [
        "subvol=@root"
        "noatime"
        "compress=zstd:1"
        "ssd"
        "discard=async"
        "commit=5"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/drive-desktop-luks-main";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "noatime"
        "compress=zstd:1"
        "ssd"
        "discard=async"
        "flushoncommit"
      ];
    };

    "/etc/nixos" = {
      device = "/dev/mapper/drive-desktop-luks-main";
      fsType = "btrfs";
      options = [
        "subvol=@nixos"
        "noatime"
        "compress=zstd:1"
        "ssd"
        "discard=async"
        "commit=5"
      ];
    };

    "/home" = {
      device = "/dev/mapper/drive-desktop-luks-main";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "compress=zstd:1"
        "ssd"
        "discard=async"
        "commit=5"
      ];
    };

    "/home/d7tun6/files/mounts/TS480SSD" = {
      device = "/dev/mapper/drive-desktop-ts480ssd";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "compress=zstd:1"
        "ssd"
        "discard=async"
        "commit=5"
      ];
    };

    "/home/d7tun6/files/mounts/wd-purple" = {
      device = "/dev/mapper/drive-desktop-wd-purple";
      fsType = "btrfs";
      options = [
        "subvol=@files"
        "noatime"
        "compress=zstd:1"
        "commit=5"
        "nofail"
        "x-systemd.automount"
        "x-systemd.device-timeout=1ms"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/drive-desktop-esp";
      fsType = "vfat";
      options = [
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
  swapDevices = [
    {
      device = "/home/d7tun6/files/mounts/TS480SSD/swap/swapvol/swapfile";
      priority = 0;
    }
  ];
}
