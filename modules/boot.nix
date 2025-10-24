{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  boot = {
    loader = {
      timeout = 0;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };
    };
    initrd = {
      systemd.enable = true;
      luks = {
        devices = {
          "cryptdisk" = {
            device = "/dev/disk/by-uuid/e4b76db2-39af-443e-9cc8-a564437b5804";
            preLVM = true;
          };
          "crypthdd" = {
            device = "/dev/disk/by-uuid/38355555-1901-4d09-a0a1-505af525deab";
            preLVM = true;
          };
          "cryptssd" = {
            device = "/dev/disk/by-uuid/07d112c7-4ab6-471d-9239-b2c45a800797";
            preLVM = true;
          };
        };
      };
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "ehci_pci"
        "ohci_pci"
        "evdev"
      ];
      kernelModules = [
        "amdgpu"
      ];
    };

    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [
      "kvm-amd"
      "xt_multiport"
      "tcp_bbr"      
    ];

    blacklistedKernelModules = [
      "radeon"
      "iTCO_wdt"
      "sp5100-tco"
      "serial8250"
    ];

    kernelParams = [
      # GPU.
      "radeon.cik_support=0"
      "amdgpu.cik_support=1"
      "radeon.si_support=0"
      "amdgpu.si_support=1"
      "amdgpu.dc=1"
      "amdgpu.dpm=1"
      "amdgpu.runpm=1"
      "amdgpu.audio=0"
      "modprobe.blacklist=radeon"
      "video=HDMI-A-1:1920x1080@74"

      # Logging.
      "loglevel=0"
      "rd.udev.log_level=0"
      "systemd.show_status=false"

      # BIOS.
      "pcie_aspm=off"

      # PCI.
      "pci=pcie_bus_perf"

      # ACPI.
      "libahci.ignore_sss=1"
      "acpi_osi=Linux"
      "acpi=ht"
      
      # CPU.
      "mitigations=off"
      "processor.ignore_ppc=1"
      "idle=poll"
      "modprobe.blacklist=iTCO_wdt"
      "modprobe.blacklist=sp5100-tco"

      # Disable CPU powersaving features.
      # Global.
      "cpufreq.performance=1"
      "processor.max_cstate=0"
      "cpuidle.off=1"
      # Intel.
      "intel_idle.max_cstate=0"
      "intel_pstate=disable"
      # AMD.
      "amd_pstate=disable"
      
      # Network.
      "net.ifnames=0"

      # Optimizations.
      "tsc=reliable"
      "clocksource=tsc"
      "clock=tsc"
      "nolapic_timer"
      "usbcore.autosuspend=-1"
      "libata.force=noncq"
      "libata.noacpi=1"
      "nosoftlockup"
      "preempt=full"
      "tsx_async_abort=off"
      "nowatchdog"
      "nmi_watchdog=0"
      "split_lock_detect=off"
      "msr.allow_writes=on"
      "module.sig_unenforce"
      "no_timer_check"
      "page_alloc.shuffle=1"
      "rcupdate.rcu_expedited=1"
    ];
    kernel = {
      sysctl = {
        # Memory optimizations.
        "vm.swappiness" = 150;
        "vm.vfs_cache_pressure" = 50;
        "vm.page-cluster" = 0;
        "vm.dirty_ratio" = 10;
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_background_bytes" = 67108864;
        "vm.dirty_bytes" = 268435456;
        "vm.dirty_expire_centisecs" = 1500;
        "vm.dirty_writeback_centisecs" = 100;
        "vm.max_map_count" = 1048576;
        
        # Watchdog disable.
        "kernel.watchdog" = 0;
        "kernel.nmi_watchdog" = 0;
        
        # Kernel tuning.
        "kernel.unprivileged_userns_clone" = 1;
        "kernel.printk" = "3 3 3 3";
        "kernel.kptr_restrict" = 2;
        "kernel.kexec_load_disabled" = 1;

        # Scheduler tuning.
        "kernel.sched_burst_cache_lifetime" = 75000000;
        "kernel.sched_burst_penalty_offset" = 22;
        "kernel.sched_burst_penalty_scale" = 1280;
        
        # Increase limits.
        "fs.inotify.max_user_watches" = 524288;
        "fs.file-max" = 2097152;

        # Network optimizations.
        # Algos.
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
        # Buffers.
        "net.core.rmem_default" = 1048576;
        "net.core.rmem_max" = 67108864;
        "net.core.wmem_default" = 1048576;
        "net.core.wmem_max" = 67108864;
        "net.core.optmem_max" = 65536;
        "net.ipv4.tcp_rmem" = "4096 1048576 67108864";
        "net.ipv4.tcp_wmem" = "4096 1048576 67108864";
        "net.ipv4.udp_rmem_min" = 8192;
        "net.ipv4.udp_wmem_min" = 8192;
        # Other.
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        "net.ipv4.tcp_sack" = 1;
        "net.core.netdev_max_backlog" = 16384;
        "net.ipv4.ip_local_port_range" = "30000 65535";
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_rfc1337" = 1;
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.default.log_martians" = 1;
        "net.ipv4.conf.all.log_martians" = 1;
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
        "net.core.somaxconn" = 65535;
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_mtu_probing" = 1;
        "net.ipv4.tcp_ecn" = 1;
        "net.ipv4.tcp_timestamps" = 1;
        "net.ipv4.tcp_keepalive_time" = "60";
        "net.ipv4.tcp_keepalive_intvl" = 10;
        "net.ipv4.tcp_keepalive_probes" = 6;
        "net.ipv4.tcp_max_syn_backlog" = 8192;
        "net.ipv4.tcp_max_tw_buckets" = 2000000;
        "net.ipv4.tcp_tw_reuse" = 1;
        "net.ipv4.tcp_fin_timeout" = 10;
      };
    };
    plymouth = {
      enable = false;
    };
  };

  # Power.
  powerManagement = {
    cpuFreqGovernor = "performance";
    enable = true;
  };
}
