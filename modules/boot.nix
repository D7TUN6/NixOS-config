{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  boot = {
    loader = {
      timeout = 1;
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
      verbose = false;
      luks = {
        devices = {
          "cryptroot" = {
            device = "/dev/disk/by-uuid/afd2a1a7-335f-4939-9f11-79aae10124fa";
            preLVM = true;
          };
        };
      };
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "ehci_pci"
        "ohci_pci"
        "evdev"
      ];
      kernelModules = [
        "usb_storage"
        "vfat"
        "nls_cp437"
        "nls_iso8859_1"
        "amdgpu"
      ];
    };
    #kernelPackages = pkgs.linuxPackages_cachyos-rc;
    # My own kernel based on RT kernel with some patches from Linux-TKG project.
    kernelPackages = let
      linux_tkg_rt = pkgs.callPackage ({
          fetchurl,
          buildLinux,
          ...
        } @ args:
          buildLinux (args
            // rec {
              version = "6.17-rc4-rt3";
              modDirVersion = "6.17.0-rc4-rt3";
              src = pkgs.fetchurl {
                url = "https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/snapshot/linux-rt-devel-v6.17-rc4-rt3.tar.gz";
                hash = "sha256-bfx0XiIvH2l+xECnpGg1nhkLaqQKhuZNpOXaPIF3org=";
              };

              kernelPatches = [
                {
                  name = "0003-glitched-base";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.17/0003-glitched-base.patch";
                    hash = "sha256-TsIYTcIEknI4IK5uCZ32f+oZp8JsAb4THLrlobFkRDg=";
                  };
                }
                {
                  name = "clear-patches";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.17/0002-clear-patches.patch";
                    hash = "sha256-J90p4D9hMM/ZGNTQeITWXEn+0O6tIyN/6mRPmRjIRTA=";
                  };
                }
                {
                  name = "optimize_harder_O3";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.17/0013-optimize_harder_O3.patch";
                    hash = "sha256-lIKY3/JVKn+m8Ftpi9erBaULCvdRbSuaxmTRrTj9qV8=";
                  };
                }
                {
                  name = "misc-additions";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.17/0012-misc-additions.patch";
                    hash = "sha256-C7B8DV3Dc/IEPcWRXkrH/6Kby8WSX31z0bi+pnluqxY=";
                  };
                }
                {
                  name = "sure-additions";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.17/0013-suse-additions.patch";
                    hash = "sha256-FmJmtZjpnet9T4Mj9xRZ4JSSTma5owI1EW8yarI+6f0=";
                  };
                }
                {
                  name = "add-sysctl-to-disallow-unprivileged";
                  patch = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/6.17/0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by.patch";
                    hash = "sha256-tlY1UF7BpCbF7J3X6+l4VT5hRKINpzRMzPpWwUY8B1I=";
                  };
                }
              ];
              structuredExtraConfig = with lib.kernel; {
                PREEMPT = lib.mkForce yes;
                PREEMPT_RT = lib.mkForce yes;
                PREEMPTION = lib.mkForce yes;
                HZ_1000 = lib.mkForce yes;
                SCHED_AUTOGROUP = lib.mkForce no;
                HIGH_RES_TIMERS = lib.mkForce yes;
                NO_HZ_FULL = lib.mkForce yes;
                IRQ_FORCED_THREADING = lib.mkForce yes;
                RCU_NOCB_CPU = lib.mkForce yes;
                BSD_PROCESS_ACCT = lib.mkForce no;
                CC_OPTIMIZE_FOR_PERFORMANCE = lib.mkForce yes;
                CC_OPTIMIZE_FOR_PERFORMANCE_O3 = lib.mkForce yes;
                X86_AMD_PSTATE = lib.mkForce yes;
                AMD_PSTATE = lib.mkForce yes;
                LTO = lib.mkForce yes;
                LTO_NONE = lib.mkForce no;
                LTO_CLANG = lib.mkForce no;
                LTO_GCC = lib.mkForce yes;
                ARCH_SUPPORTS_LTO = lib.mkForce yes;
                ARCH_SUPPORTS_LTO_CLANG = lib.mkForce no;
                ARCH_SUPPORTS_LTO_GCC = lib.mkForce yes;
                HAS_LTO = lib.mkForce yes;
                DEBUG_INFO = lib.mkForce no;
                DEBUG_KERNEL = lib.mkForce no;
              };
              ignoreConfigErrors = true;
              extraMeta.branch = "6.17";
            })) {};
    in
      pkgs.linuxPackagesFor linux_tkg_rt;

    kernelModules = [
      "kvm-amd"
      "snd_seq"
      "snd_rawmidi"
    ];
    resumeDevice = "/dev/disk/by-uuid/33ae5d30-b4df-44f2-a815-92e28facb4ad";
    kernelParams = [
      # GPU.
      "radeon.cik_support=0"
      "amdgpu.cik_support=1"
      "amdgpu.dc=1"
      "amdgpu.dpm=1"
      "modprobe.blacklist=radeon"

      # Logging.
      "loglevel=8"

      # BIOS.
      "pcie_aspm=force"

      # CPU.
      "migrations=off"
      "processor.ignore_ppc=1"
      "processor.max_cstate=0"
      "cpuidle.off=1"
      "idle=nomwait"
      #"iommu=soft"

      # Network.
      "net.ifnames=0"

      # Optimizations.
      "nohalt"
      "nosoftlockup"
      "preempt=full"
      "nowatchdog"
      "nohibernate"
      "split_lock_detect=off"
      "msr.allow_writes=on"
      "module.sig_unenforce"
      "cryptomgr.notests"
      "initcall_debug"
      "no_timer_check"
      "noreplace-smp"
      "page_alloc.shuffle=1"
      "rcupdate.rcu_expedited=1"
      "tsc=reliable"
      "noibrs"
      "tsx_async_abort=off"
      "elevator=none"
      "audit=0"
    ];
    kernel = {
      sysctl = {
        # Swap.
        "vm.swappiness" = 10;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_ratio" = 10;
        "vm.dirty_background_ratio" = 5;

        # FS.
        "fs.inotify.max_user_watches" = 524288;

        # Network.
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_mtu_probing" = 1;
        "net.ipv4.tcp_ecn" = 1;
        "net.ipv4.tcp_timestamps" = 1;
        "net.ipv4.tcp_keepalive_time" = "60";
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
  # Console.
  console.earlySetup = true;
}
