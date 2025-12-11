{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2048M";
              type = "EF00";
              label = "drive-desktop-esp-2";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" "nofail" ];
              };
            };
            luks = {
              size = "100%";
              label = "drive-desktop-luks-main-2";
              content = {
                type = "luks";
                name = "drive-desktop-luks-main-2";
                extraOpenArgs = [ ];
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                    };
                    "@home" = {
                      mountpoint = "/home";
                    };
                    "@nixos" = {
                      mountpoint = "/etc/nixos";
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                    };
                  };
                  mountOptions = [
                    "defaults"
                    "noatime"
                    "compress=zstd:19"
                    "ssd"
                    "discard=async"
                    "space_cache=v2"
                    "autodefrag"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}

