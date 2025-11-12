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
      package = pkgs.zfs_unstable;
    };
    kernelPackages = pkgs.linuxPackages_6_1_hardened;
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
    ];

    blacklistedKernelModules = [
      "radeon"
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
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
      "slab_nomerge"
      "page_poison=1"
      "page_alloc.shuffle=1"
      "debugfs=off"
      "module.sig_enforce=1"
      "lockdown=confidentiality"
      # "efi=disable_early_pci_dma"
      "iommu.passthrough=0"
      "mitigations=auto,nosmt"
      "pti=on"
      "extra_latent_entropy"
      "init_on_alloc=1"
      "init_on_free=1"
      "randomize_kstack_offset=on"
      "vsyscall=none"
      "oops=panic"
      "random.trust_cpu=off"
      "random.trust_bootloader=off"
      "intel_iommu=on"
      "iommu=force"
      "iommu.strict=1"
    ];
    kernel = {
      sysctl = {

        # Security.
        "net.core.bpf_jit_enable" = lib.mkDefault false;
        "kernel.ftrace_enabled" = lib.mkDefault false;
        "net.ipv4.conf.all.log_martians" = lib.mkDefault true;
        "net.ipv4.conf.all.rp_filter" = lib.mkDefault "1";
        "net.ipv4.conf.default.log_martians" = lib.mkDefault true;
        "net.ipv4.icmp_echo_ignore_broadcasts" = lib.mkDefault true;
        "net.ipv4.conf.all.accept_redirects" = lib.mkDefault false;
        "net.ipv4.conf.all.secure_redirects" = lib.mkDefault false;
        "net.ipv4.conf.default.accept_redirects" = lib.mkDefault false;
        "net.ipv4.conf.default.secure_redirects" = lib.mkDefault false;
        "net.ipv6.conf.all.accept_redirects" = lib.mkDefault false;
        "net.ipv6.conf.default.accept_redirects" = lib.mkDefault false;
        "net.ipv4.conf.all.send_redirects" = lib.mkDefault false;
        "net.ipv4.conf.default.send_redirects" = lib.mkDefault false;
        "kernel.yama.ptrace_scope" = lib.mkDefault "1";
        "kernel.sysrq" = lib.mkDefault "0";
        "fs.binfmt_misc.status" = lib.mkDefault "0";
        "kernel.io_uring_disabled" = lib.mkDefault "2";
        "dev.tty.ldisc_autoload" = lib.mkDefault "0";
        "fs.protected_fifos" = lib.mkDefault "2";
        "fs.protected_hardlinks" = lib.mkDefault "1";
        "fs.protected_regular" = lib.mkDefault "2";
        "fs.protected_symlinks" = lib.mkDefault "1";
        "fs.suid_dumpable" = lib.mkDefault "0";
        "kernel.dmesg_restrict" = lib.mkDefault "1";
        "kernel.kexec_load_disabled" = lib.mkOverride 900 "1";
        "kernel.kptr_restrict" = lib.mkOverride 900 "2";
        "kernel.perf_event_paranoid" = lib.mkDefault "3";
        "kernel.printk" = lib.mkOverride 900 "3 3 3 3";
        "kernel.unprivileged_bpf_disabled" = lib.mkDefault "1";
        "net.core.bpf_jit_harden" = lib.mkDefault "2";
        "net.ipv4.conf.all.accept_source_route" = lib.mkDefault "0";
        "net.ipv4.conf.default.accept_source_route" = lib.mkDefault "0";
        "net.ipv4.conf.default.rp_filter" = lib.mkOverride 900 "1";
        "net.ipv4.icmp_echo_ignore_all" = lib.mkDefault "1";
        "net.ipv4.tcp_dsack" = lib.mkDefault "0";
        "net.ipv4.tcp_fack" = lib.mkDefault "0";
        "net.ipv6.conf.all.accept_ra" = lib.mkDefault "0";
        "net.ipv6.conf.all.accept_source_route" = lib.mkDefault "0";
        "net.ipv6.conf.default.accept_source_route" = lib.mkDefault "0";
        "net.ipv6.default.accept_ra" = lib.mkDefault "0";
        "kernel.core_pattern" = lib.mkDefault "|/bin/false";
        "vm.mmap_rnd_bits" = lib.mkDefault "32";
        "vm.mmap_rnd_compat_bits" = lib.mkDefault "16";
        "vm.unprivileged_userfaultfd" = lib.mkDefault "0";
        "net.ipv4.icmp_ignore_bogus_error_responses" = lib.mkDefault "1";
        "kernel.randomize_va_space" = lib.mkDefault "2";
        "kernel.perf_cpu_time_max_percent" = lib.mkDefault "1";
        "kernel.perf_event_max_sample_rate" = lib.mkDefault "1";
        "vm.mmap_min_addr" = lib.mkDefault "65536";
        "net.ipv4.conf.default.shared_media" = lib.mkDefault "0";
        "net.ipv4.conf.all.shared_media" = lib.mkDefault "0";
        "net.ipv4.conf.default.arp_announce" = lib.mkDefault "2";
        "net.ipv4.conf.all.arp_announce" = lib.mkDefault "2";
        "net.ipv4.conf.default.arp_ignore" = lib.mkDefault "1";
        "net.ipv4.conf.all.arp_ignore" = lib.mkDefault "1";
        "net.ipv4.conf.default.drop_gratuitous_arp" = lib.mkDefault "1";
        "net.ipv4.conf.all.drop_gratuitous_arp" = lib.mkDefault "1";
        "net.ipv6.conf.default.router_solicitations" = lib.mkDefault "0";
        "net.ipv6.conf.all.router_solicitations" = lib.mkDefault "0";
        "net.ipv6.conf.default.accept_ra_rtr_pref" = lib.mkDefault "0";
        "net.ipv6.conf.all.accept_ra_rtr_pref" = lib.mkDefault "0";
        "net.ipv6.conf.default.accept_ra_pinfo" = lib.mkDefault "0";
        "net.ipv6.conf.all.accept_ra_pinfo" = lib.mkDefault "0";
        "net.ipv6.conf.default.accept_ra_defrtr" = lib.mkDefault "0";
        "net.ipv6.conf.all.accept_ra_defrtr" = lib.mkDefault "0";
        "net.ipv6.conf.default.autoconf" = lib.mkDefault "0";
        "net.ipv6.conf.all.autoconf" = lib.mkDefault "0";
        "net.ipv6.conf.all.dad_transmits" = lib.mkDefault "0";
        "net.ipv6.conf.default.max_addresses" = lib.mkDefault "1";
        "net.ipv6.conf.all.max_addresses" = lib.mkDefault "1";
        "net.ipv6.icmp.echo_ignore_anycast" = lib.mkDefault "1";
        "net.ipv6.icmp.echo_ignore_multicast" = lib.mkDefault "1";
        
        
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
        "net.ipv4.tcp_sack" = 0;
        "net.core.netdev_max_backlog" = 250000;
        "net.ipv4.ip_local_port_range" = "1024 65535";
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_rfc1337" = 1;
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
