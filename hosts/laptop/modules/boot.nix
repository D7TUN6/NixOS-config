{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  boot = {
    consoleLogLevel = 0;
    plymouth.enable = true;
    supportedFilesystems = {
      vfat = true;
      btrfs = true;
      ext4 = true;
    };
    kernelPackages = pkgs.linuxPackages;
    loader = {
      timeout = 0;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        memtest86.enable = true;
      };
    };
    initrd = {
      compressor = "zstd";
      compressorArgs = ["-19"];
      verbose = true;
      systemd = {
        enable = true;
        # tpm2.enable = true;
      };
      luks = {
        devices = {
          "drive-laptop-luks-main" = {
            device = "/dev/disk/by-partlabel/drive-laptop-luks-main";
            preLVM = true;
          };
        };
      };
      availableKernelModules = [
        "ahci"
      	"xhci_pci"
        "ehci_pci"
        "ohci_pci"
        "tpm_tis"
        "thunderbolt"          
        "vmd"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [
      ];
    };
    kernelModules = [
      "kvm-amd"
      "atk-kbd"
      "usb-hid"
      "tcp-bbr"
      "tun"
      "snd_pcsp"
    ];

    blacklistedKernelModules = [
      # "radeon"
      "sp5100-tco"
      "iTCO_wdt"
    ];
    
    kernelParams = [     
      # Silent boot.
      "quiet"
      "udev.log_level=3"
      "audit=0"
           
      # # Network.
      "net.ifnames=0"

      # RT.
      "preempt=full"
     
      # Power.
      "acpi_osi=Linux"
      
      # Optimizations.
      "clocksource=tsc"
      "nosoftlockup=1"
      "page_alloc.shuffle=1"
      "nowatchdog"
      "nmi_watchdog=0"
    ];
    kernel = {
      sysctl = {      
        # Memory optimizations.
        "vm.swappiness" = 10;
        "vm.vfs_cache_pressure" = 50;
        "vm.page-cluster" = 0;
        "vm.dirty_ratio" = 10;
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_background_bytes" = 4194304;
        "vm.dirty_bytes" = 4194304;
        "vm.dirty_expire_centisecs" = 1500;
        "vm.dirty_writeback_centisecs" = 100;
        "vm.stat_interval" = 120;
        "vm.max_map_count" = 2147483642;
        "vm.compaction_proactiveness" = 20;
        "vm.watermark_boost_factor" = 1;
        "vm.watermark_scale_factor" = 100;
        "vm.zone_reclaim_mode" = 0;
        "vm.page_lock_unfairness" = 1;
       
        # Increase limits.
        "fs.inotify.max_user_watches" = 524288;
        "fs.file-max" = 9223372036854775807;

        # Network optimizations.
        # Algos.
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
        # Buffers.
        "net.core.rmem_default" = 8388608;
        "net.core.rmem_max" = 536870912;
        "net.core.wmem_default" = 8388608;
        "net.core.wmem_max" = 536870912;
        "net.core.optmem_max" = 65536;
        "net.ipv4.tcp_synack_retries" = 5;
        "net.ipv4.tcp_rmem" = "8192 524288 536870912";
        "net.ipv4.tcp_wmem" = "4096 262144 536870912";
        "net.ipv4.udp_rmem_min" = 16384;
        "net.ipv4.udp_wmem_min" = 16384;
        # Other.
        "net.ipv4.tcp_base_mss" = 1024;
        "net.core.netdev_budget" = 600;
        "net.core.netdev_budget_usecs" = 6000;
        "net.ipv4.tcp_low_latency" = 1;
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        "net.ipv4.tcp_sack" = 1;
        "net.core.netdev_max_backlog" = 250000;
        "net.ipv4.ip_local_port_range" = "1024 65535";
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_rfc1337" = 1;
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_mtu_probing" = 1;
        "net.ipv4.tcp_timestamps" = 1;
        "net.ipv4.tcp_keepalive_time" = "600";
        "net.ipv4.tcp_keepalive_intvl" = 60;
        "net.ipv4.tcp_keepalive_probes" = 4;
        "net.ipv4.tcp_max_syn_backlog" = 8192;
        "net.ipv4.tcp_max_tw_buckets" = 100000;
        "net.ipv4.tcp_fin_timeout" = 30;
        "net.ipv4.tcp_tw_reuse" = 1;
        "net.ipv4.tcp_ecn" = 0;
        "net.core.somaxconn" = 32768;
        "net.ipv4.tcp_adv_win_scale" = -2;
        "net.ipv4.tcp_notsent_lowat" = 131072;
        # other things.
        "kernel.watchdog" = 0;
        "kernel.nmi_watchdog" = 0;
      };
    };
  };
}
