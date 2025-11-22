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
    # kernelPackages = pkgs.linuxPackages-rt_latest;
    kernelPackages = let
      linux_tkg = pkgs.callPackage ({
          fetchurl,
          buildLinux,
          ...
        } @ args:
          buildLinux (args
            // rec {
              version = "6.17.5-rt7";
              modDirVersion = "6.17.5-rt7";
              src = pkgs.fetchurl {
                url = "https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/snapshot/linux-rt-devel-v6.17.5-rt7.tar.gz";
                hash = "sha256-nU5MMfV4vOzMZLIE9SF3Nanm9hiONZ2cx37zLPKIaoo=";
              };

              kernelPatches = [
                {
                  name = "0003-glitched-base";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.18/0003-glitched-base.patch";
                    hash = "sha256-TsIYTcIEknI4IK5uCZ32f+oZp8JsAb4THLrlobFkRDg=";
                  };
                }
                {
                  name = "clear-patches";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.18/0002-clear-patches.patch";
                    hash = "sha256-LJhDpR6N1LQfdiDcxL82d8eGfZIgcyAsCVMk+xRDz6U=";
                  };
                }
                {
                  name = "optimize_harder_O3";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.18/0013-optimize_harder_O3.patch";
                    hash = "sha256-lIKY3/JVKn+m8Ftpi9erBaULCvdRbSuaxmTRrTj9qV8=";
                  };
                }
                {
                  name = "misc-additions";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.18/0012-misc-additions.patch";
                    hash = "sha256-C7B8DV3Dc/IEPcWRXkrH/6Kby8WSX31z0bi+pnluqxY=";
                  };
                }
                {
                    name = "suse-additions";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.18/0013-suse-additions.patch";
                    hash = "sha256-FmJmtZjpnet9T4Mj9xRZ4JSSTma5owI1EW8yarI+6f0=";
                  };
                }
                {
                  name = "add-sysctl-to-disallow-unprivileged";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.18/0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by.patch";
                    hash = "sha256-tlY1UF7BpCbF7J3X6+l4VT5hRKINpzRMzPpWwUY8B1I=";
                  };
                }
                 {
                   name = "bore";
                   patch = pkgs.fetchurl {
                     url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/6.18/0001-bore.patch";
                     hash = "sha256-2ili3gZxia9A4w1s5hO8PBQ2nJ2g/BuylSP3q8C9Fe0=";
                   };
                 }
                 {
                   name = "acs_override";
                   patch = pkgs.fetchurl {
                     url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/6.18/0006-add-acs-overrides_iommu.patch";
                     hash = "sha256-EiE5vvw9olsAtRGemi/FmyZu0N5T82kS6eYPMofEedY=";
                   };
                 }
                 {
                  name = "config";
                  patch = null;
                  extraConfig = ''
                    ZENIFY y
                    PREEMPT y
                    PREEMPT_RT y
                    PREEMPTION y
                    HZ_1000 y
                    HIGH_RES_TIMERS y
                    NO_HZ_FULL y
                    IRQ_FORCED_THREADING y
                    RCU_NOCB_CPU y
                    CC_OPTIMIZE_FOR_PERFORMANCE y
                    CC_OPTIMIZE_FOR_PERFORMANCE_O3 y
                    CC_HAS_MARCH_NATIVE y
                    LTO_NONE n
                    ARCH_SUPPORTS_LTO_CLANG y
                    CONFIG_LTO_CLANG_THIN n
                    DEBUG_INFO n
                    DEBUG_KERNEL n
                    GENERIC_CPU n
                    UNWINDER_ORC y
                    STACKPROTECTOR n
                    X86_KERNEL_IBT n
                    PAGE_POISONING n
                    SCHED_STACK_END_CHECK n
                    DEBUG_VM n
                    DEBUG_INFO_BTF n
                    DEBUG_VIRTUAL n
                    DEBUG_LIST n
                    DEBUG_PLIST n
                    DEBUG_SG n
                    DEBUG_NOTIFIERS n
                    DEBUG_MAPLE_TREE n
                    DEBUG_CREDENTIALS n
                    SLUB_DEBUG n
                    SCHED_DEBUG n
                    SCHEDSTATS n
                  '';
                }
              ];
              extraStructuredConfig = with lib.kernel; {
                ZENIFY = lib.mkForce yes;
                PREEMPT = lib.mkForce  yes;
                PREEMPT_RT = lib.mkForce yes;
                PREEMPTION = lib.mkForce yes;
                HZ_1000 = lib.mkForce yes;
                HIGH_RES_TIMERS = lib.mkForce yes;
                NO_HZ_FULL = lib.mkForce yes;
                IRQ_FORCED_THREADING = lib.mkForce yes;
                RCU_NOCB_CPU = lib.mkForce yes;
                CC_OPTIMIZE_FOR_PERFORMANCE = lib.mkForce yes;
                CC_OPTIMIZE_FOR_PERFORMANCE_O3 = lib.mkForce yes;
                CC_HAS_MARCH_NATIVE = lib.mkForce yes;
                LTO_NONE = lib.mkForce no;
                ARCH_SUPPORTS_LTO_CLANG = lib.mkForce yes;
                CONFIG_LTO_CLANG_THIN = lib.mkForce no;
                DEBUG_INFO = lib.mkForce no;
                DEBUG_KERNEL = lib.mkForce no;
                GENERIC_CPU = lib.mkForce no;
                UNWINDER_ORC = lib.mkForce yes;
                STACKPROTECTOR = lib.mkForce no;
                X86_KERNEL_IBT = lib.mkForce no;
                PAGE_POISONING = lib.mkForce no;
                SCHED_STACK_END_CHECK = lib.mkForce no;
                DEBUG_VM = lib.mkForce no;
                DEBUG_INFO_BTF = lib.mkForce no;
                DEBUG_VIRTUAL = lib.mkForce no;
                DEBUG_LIST = lib.mkForce no;
                DEBUG_PLIST = lib.mkForce no;
                DEBUG_SG = lib.mkForce no;
                DEBUG_NOTIFIERS = lib.mkForce no;
                DEBUG_MAPLE_TREE = lib.mkForce no;
                DEBUG_CREDENTIALS = lib.mkForce no;
                SLUB_DEBUG = lib.mkForce no;
                SCHED_DEBUG = lib.mkForce no;
                SCHEDSTATS = lib.mkForce no; 
              };
              makeFlags = [ "KCFLAGS=-O3 -march=native -mtune=native -flto -pipe -ftree-vectorize -fomit-frame-pointer -fno-semantic-interposition" ];
              ignoreConfigErrors = true;
              extraMeta.branch = "6.17";
            })) {};
    in
      pkgs.linuxPackagesFor linux_tkg;
    
    loader = {
      systemd-boot.editor = lib.mkDefault false;
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
        # "usb_storage"
        # "vfat"
        # "nls_cp437"
        # "nls_iso8859_1"
      ];
    };
    kernelModules = [
      "kvm-amd"
      "atk-kbd"
      "usb-hid"
      "tcp-bbr"
      "tun"
    ];

    blacklistedKernelModules = [
      "radeon"
      "sp5100-tco"
      "iTCO_wdt"
    ];
    
    kernelParams = [
      # Silent boot.
      "quiet"
      "udev.log_level=3"
      "audit=0"

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
      "preempt=rt"

      # Security.
      "mitigations=off"
      "slab_nomerge"
      "init_on_alloc=1"
      "page_alloc.shuffle=1"
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
        "kernel.watchdog" = 0;
      };
    };
  };
}
