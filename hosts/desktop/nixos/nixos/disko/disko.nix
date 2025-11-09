{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" "nofail" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptssd";
                extraOpenArgs = [ ];
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
	  mountpoint = "none";
          compression = "zstd-19";
          acltype = "posixacl";
          xattr = "sa";
          atime = "off";
	  dnodesize="auto";
	  normalization="formD";
	  dedup="on";
        };
	options = {
	  ashift = "12";
	  autotrim = "on";
        };
	datasets = {
	  "root" = {
	    type = "zfs_fs";
	    mountpoint = "/";
	  };
	  "root/home" = {
	    type = "zfs_fs";
	    options.mountpoint = "/home";
	    mountpoint = "/home";
	  };
	  "root/nixos" = {
	    type = "zfs_fs";
	    options.mountpoint = "/etc/nixos";
	    mountpoint = "/etc/nixos";
	  };
	  "root/nix" = {
	    type = "zfs_fs";
	    options.mountpoint = "/nix";
	    mountpoint = "/nix";
	  };
    	};
      };
    };
  };
}
