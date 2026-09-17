{
  pkgs,
  # lib,
  # config,
  ...
}: {
  boot = {
    consoleLogLevel = 3;
    kernelPackages = pkgs.linuxPackages_latest;

    blacklistedKernelModules = [
      "itco_wdt"
      "itco_vendor_support"
      "sp5100_tco"
      "radeon"
      "watchdog"
    ];

    loader = {
      timeout = 2;
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

    postBootCommands = ''
      echo 2048 > /sys/class/rtc/rtc0/max_user_freq
      echo 2048 > /proc/sys/dev/hpet/max-user-freq
      setpci -v -d '*:*' latency_timer=b0
      setpci -v -s 0b:00.3 latency_timer=ff
    '';

    initrd = {
      luks.devices = {
        "drive-wdc-desktop-luks-main" = {
          device = "/dev/disk/by-partlabel/drive-wdc-desktop-luks-main";
          preLVM = true;
          bypassWorkqueues = true;
          allowDiscards = true;
        };
        "drive-desktop-wd-purple" = {
          device = "/dev/disk/by-partlabel/drive-desktop-wd-purple";
          preLVM = true;
          bypassWorkqueues = true;
          allowDiscards = true;
        };
        "drive-desktop-ts480ssd" = {
          device = "/dev/disk/by-partlabel/drive-desktop-ts480ssd";
          preLVM = true;
          bypassWorkqueues = true;
          allowDiscards = true;
        };
      };
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "ehci_pci"
        "ohci_pci"
        "usb_storage"
      ];
      kernelModules = [
        "nct6775"
        "cpuid"
        "k10temp"
        "i2c-dev"
        "msr"
      ];
    };

    kernelParams = [
      #badram
      "memmap=64K$0x0000158d0000"

      "net.ifnames=0"
      "preempt=full"
      "threadirqs"
      "skew_tick=1"
      "tsc=reliable"
      "nowatchdog"
      "nmi_watchdog=0"
      "page_alloc.shuffle=1"

      "nohz_full=1-11"
      "rcu_nocbs=1-11"
      # "amd_pstate=active"
      "mem_sleep_default=deep"

      #fix
      "processor.max_cstate=0"
      "intel_idle.max_cstate=0"
      "idle=poll"
      "pcie_aspm=off"
      "nvme_core.default_ps_max_latency_us=0"
      "amd_pstate=disable"
    ];
  };
}
