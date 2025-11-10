{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  boot = {
    consoleLogLevel = 4;
    supportedFilesystems = {
      vfat = true;
      zfs = true;
      ext4 = true;
      btrfs = true;
    };
    zfs = {
      extraPools = [ "zservroot" ];
      forceImportRoot = true;
    };
    kernelPackages = pkgs.linuxPackages_6_1;
    loader = {
      timeout = 5;
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
      verbose = true;
      systemd.enable = true;
      luks = {
        devices = {
          "cryptservroot" = {
            device = "/dev/disk/by-uuid/fa869168-f013-4537-ab26-19a80857234e";
            preLVM = true;
          };
        };
      };
      availableKernelModules = [
      	"xhci_pci"
      	"ehci_pci"
      	"usb_storage"
      	"usbhid"
      	"ahci"
      ];
      kernelModules = [
      ];
    };
    kernelModules = [
      "kvm-intel"
    ];

    blacklistedKernelModules = [
    ];
    
    kernelParams = [
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
        "vm.min_free_kbytes" = 1048576;
        "vm.watermark_scale_factor" = 500;
        "vm.zone_reclaim_mode" = 0;
        "vm.page_lock_unfairness" = 1;       
       
        # Increase limits.
        "fs.inotify.max_user_watches" = 524288;
        "fs.file-max" = 2097152;

        # Network optimizations.
        # Algos.
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
        # Buffers.
        "net.core.rmem_default" = 1048576;
        "net.core.rmem_max" = 134217728;
        "net.core.wmem_default" = 1048576;
        "net.core.wmem_max" = 134217728;
        "net.core.optmem_max" = 65536;
        "net.ipv4.tcp_rmem" = "4096 65536 134217728";
        "net.ipv4.tcp_wmem" = "4096 65536 132417728";
        "net.ipv4.udp_rmem_min" = 8192;
        "net.ipv4.udp_wmem_min" = 8192;
        # Other.
        "net.core.netdev_budget" = 600;
        "net.core.netdev_budget_usecs" = 6000;
        "net.ipv4.tcp_low_latency" = 1;
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        "net.ipv4.tcp_sack" = 0;
        "net.core.netdev_max_backlog" = 16384;
        "net.ipv4.ip_local_port_range" = "30000 65535";
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_rfc1337" = 1;
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
	      "net.ipv4.conf.all.log_martians" = 0;
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.secure_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 0;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.send_redirects" = 0;
        "net.ipv4.icmp_echo_ignore_all" = 0;
        "net.ipv6.icmp.echo_ignore_all" = 0;
        "net.ipv4.ping_group_range" = "0 65535";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_mtu_probing" = 1;
        "net.ipv4.tcp_timestamps" = 0;
        "net.ipv4.tcp_keepalive_time" = "60";
        "net.ipv4.tcp_keepalive_intvl" = 10;
        "net.ipv4.tcp_keepalive_probes" = 6;
        "net.ipv4.tcp_max_syn_backlog" = 8192;
        "net.ipv4.tcp_max_tw_buckets" = 2000000;
        "net.ipv4.tcp_fin_timeout" = 10;
        "net.ipv4.tcp_tw_reuse" = 1;
        "net.ipv4.tcp_ecn" = 0;
        "net.ipv4.conf.default.log_martians" = 0;
        "net.core.somaxconn" = 8192;
      };
    };
  };
}
