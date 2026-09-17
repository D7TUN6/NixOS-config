{
  pkgs,
  # lib,
  # config,
  ...
}: {
  boot = {
    consoleLogLevel = 3;
    kernelPackages = pkgs.linuxPackages_cachyos-rt-bore;

    blacklistedKernelModules = [
      "itco_wdt"
      "itco_vendor_support"
      "sp5100_tco"
      "radeon"
      "watchdog"
    ];

    extraModprobeConfig = ''
      # keep the ALC1220 DAC awake: codec power-save causes dropouts on first
      # playback after idle and is irrelevant on an idle=poll machine anyway
      options snd_hda_intel power_save=0 power_save_controller=0
    '';

    loader = {
      timeout = 2;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "max";
        memtest86.enable = true;
      };
    };

    postBootCommands = ''
      echo 2048 > /sys/class/rtc/rtc0/max_user_freq
      echo 2048 > /proc/sys/dev/hpet/max-user-freq
      setpci -v -d '*:*' latency_timer=b0
      setpci -v -s 0b:00.3 latency_timer=ff
      echo "manual" > /sys/class/drm/card1/device/power_dpm_force_performance_level
      echo "0" > /sys/class/drm/card1/device/pp_dpm_mclk
      echo "0" > /sys/class/drm/card1/device/pp_dpm_sclk
    '';

    initrd = {
      luks.devices = {
        "drive-desktop-luks-main" = {
          device = "/dev/disk/by-partlabel/drive-desktop-luks-main";
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
      # badram
      "memmap=64M$0x0000158d0000" # 64K
      "memmap=64M$0x000323c20000"

      "drm_kms_helper.dp_aux_i2c_transfer_size=1"
      "amdgpu.ppfeaturemask=0xffffffff"

      "net.ifnames=0"
      "preempt=full"
      "threadirqs"
      "skew_tick=1"
      "tsc=reliable"
      "nowatchdog"
      "nmi_watchdog=0"

      # security
      "page_poison=1"
      "slub_debug=P"
      "iommu=force"
      "intel_iommu=on"
      "amd_iommu=on"
      "slab_nomerge"
      "init_on_free=1"
      "init_on_alloc=1"
      "page_alloc.shuffle=1"
      "hash_pointers=always"

      # "intel_idle.max_cstate=0"
      # "processor.max_cstate=0"
      # "idle=poll"
      # "processor.ignore_ppc=1"
      # "amd_pstate=disable"
      # "intel_pstate=disable"

      "amd_pstate=active"
      "mem_sleep_default=deep"
    ];
  };
}
