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
      zfs = true;
      btrfs = true;
      ext4 = true;
    };
    zfs = {
      extraPools = [ "zroot" ];
      forceImportRoot = true;
    };
    kernelPackages = pkgs.linuxPackages;
    loader = {
      systemd-boot.editor = lib.mkDefault false;
      timeout = 0;
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        memtest86.enable = true;
      };
    };
    initrd = {
      verbose = false;
      systemd.enable = true;
      luks = {
        devices = {
          "cryptroot" = {
            device = "/dev/disk/by-uuid/fa869168-f013-4537-ab26-19a80857234e";
            preLVM = true;
          };
        };
      };
      availableKernelModules = [
      	"xhci_pci"
      	"ahci"
      ];
      kernelModules = [
      ];
    };
    kernelModules = [
      "kvm-amd"
      "tun"
    ];

    blacklistedKernelModules = [
      "radeon"
    ];
    
    kernelParams = [
      # Silent boot.
      "quiet"
      "udev.log_level=3"

      # GPU.
      "video=HDMI-A-1:1920x1080@74"
       
      # CPU.
      "idle=poll"

      # Disable CPU powersaving features.
      # Global.
      "processor.max_cstate=0"
      "cpuidle.off=1"
      # Intel.
      "intel_idle.max_cstate=0"
      "intel_pstate=disable"
      # AMD.
      "amd_pstate=disable"
      
      # # Network.
      "net.ifnames=0"

      # Optimizations.
      "tsc=reliable" 
      "clocksource=tsc"
      "clock=tsc"
      "nosoftlockup"
      "preempt=full"
      "tsx_async_abort=off"
      "split_lock_detect=off"

      # Security.
      "page_alloc.shuffle=1"
      "mitigations=auto"
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
        "vm.compaction_proactiveness" = 0;
        "vm.watermark_boost_factor" = 1;
        "vm.watermark_scale_factor" = 500;
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
        "net.core.optmem_max" = 40960;
        "net.ipv4.tcp_synack_retries" = 5;
        "net.ipv4.tcp_rmem" = "8192 262144 536870912";
        "net.ipv4.tcp_wmem" = "4096 16384 536870912";
        "net.ipv4.udp_rmem_min" = 8192;
        "net.ipv4.udp_wmem_min" = 4096;
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
        "net.ipv4.tcp_keepalive_time" = "60";
        "net.ipv4.tcp_keepalive_intvl" = 10;
        "net.ipv4.tcp_keepalive_probes" = 6;
        "net.ipv4.tcp_max_syn_backlog" = 8192;
        "net.ipv4.tcp_max_tw_buckets" = 2000000;
        "net.ipv4.tcp_fin_timeout" = 10;
        "net.ipv4.tcp_tw_reuse" = 1;
        "net.ipv4.tcp_ecn" = 0;
        "net.core.somaxconn" = 8192;
        "net.ipv4.tcp_adv_win_scale" = -2;
        "net.ipv4.tcp_notsent_lowat" = 131072;
        # other things.
        "kernel.core_uses_pid" = 1;
        "kernel.pid_max" = 4194304;
        "kernel.panic" = 10;
      };
    };
  };
}
