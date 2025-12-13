{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services = {
    lact.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = lib.mkForce false;
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    dnscrypt-proxy = {
      enable = true;
      settings = {
        ipv4_servers = true;
        ipv6_servers = true;
        dnscrypt_servers = true;
        doh_servers = true;
        require_nofilter = true;
        require_dnssec = true;
        query_log.file = "/var/log/dnscrypt-proxy/query.log";
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        # server_names = [ ... ];
      };
    };


  zapret = {
    enable = true;
    whitelist = [
      "youtube.com"
      "googlevideo.com"
      "ytimg.com"
      "youtu.be"
      "discord.com"
      "discord-attachmets-uploads-prd.storage.googleapis.com"
      "googleapis.com"
      "gstatic.com"
      "www.google.com"
      "telegram.com"
      "telegram.org"
      "whatsapp.com"
    ];
    params = [
      "--dpi-desync=fake,disorder2"
      "--dpi-desync-ttl=1"
      "--dpi-desync-autottl=2"
    ];
  };

  tlp = {
    enable = true;
    settings = {
      # Governors.
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      # Energy perf.
      CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      # CPU perf.
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;
      # CPU boost.
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      # Sound.
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";
      
      # Drive bay.
      BAY_POWEROFF_ON_AC = 0;
      BAY_POWEROFF_ON_BAT = 1;

      # Disk apm.
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
      DISK_APM_CLASS_DENYLIST = "usb ieee1394";
      DISK_SPINDOWN_TIMEOUT_ON_AC = "0 0";
      DISK_SPINDOWN_TIMEOUT_ON_BAT = "1 240";

      # Sata linkpower.
      SATA_LINKPWR_ON_AC = "max_performance";
      SATA_LINKPWR_ON_BAT = "min_power";
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "auto";
      AHCI_RUNTIME_PM_TIMEOUT = 15;

      # File system.
      DISK_IDLE_SECS_ON_AC = 0;
      DISK_IDLE_SECS_ON_BAT = 2;
      MAX_LOST_WORK_SECS_ON_AC = 15;
      MAX_LOST_WORK_SECS_ON_BAT = 60;

      # AMD GPU.
      RADEON_DPM_PERF_LEVEL_ON_AC = "high";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";
      AMDGPU_ABM_LEVEL_ON_AC = 0;
      AMDGPU_ABM_LEVEL_ON_BAT = 1;
      AMDGPU_ABM_LEVEL_ON_SAV = 3;

      # Network.
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # Platform.
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Sleep.
      MEM_SLEEP_ON_AC = "s2idle";
      MEM_SLEEP_ON_BAT = "deep";

      # Radio.
      RESTORE_DEVICE_STATE_ON_STARTUP = 0;
      DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth wifi wwan";
      DEVICES_TO_ENABLE_ON_AC = "bluetooth wifi wwan";
      DEVICES_TO_DISABLE_ON_BAT = "bluetooth";
      DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi wwan";
      DEVICES_TO_DISABLE_ON_WIFI_CONNECT = "wwan";
      DEVICES_TO_DISABLE_ON_WWAN_CONNECT = "wifi";
      DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi wwan";
      DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT = "";
      DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT = "";

      # Runtime power management & ASPM.
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      RUNTIME_PM_DENYLIST = "11:22.3 44:55.6";
      RUNTIME_PM_DRIVER_DENYLIST = "mei_me nouveau radeon amdgpu xhci_hcd";
      RUNTIME_PM_ENABLE = "11:22.3";
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # USB.
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      USB_EXCLUDE_BTUSB = 1;
      USB_EXCLUDE_PHONE = 1;
      USB_EXCLUDE_PRINTER = 1;
      USB_EXCLUDE_WWAN = 0;
      USB_AUTOSUSPEND_DISABLE_ON_SHUTDOWN = 1;
    };
  };
    
    openssh = {
      enable = true;
      ports = [ 32546 ];
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
        AllowUsers = [ "alex" ];
      };
    };
    desktopManager = {
      plasma6 = {
        enable = true;
      };
    };
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
      autoLogin = {
        user = "alex";
        enable = true;
      };
      defaultSession = "plasma";
    };
    dbus.implementation = "broker";
    blueman.enable = true;
    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      displayManager = {
        lightdm.enable = lib.mkForce false;
      };
      xkb = {
        layout = "us,ru";
        options = "grp:alt_shift_toggle";
      };
    };
    btrfs = {
      autoScrub = {
        enable = true;
        fileSystems = [
          "/"
          "/nix"
          "/home"
          "/etc/nixos"
        ];
        interval = "monthly";
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    irqbalance.enable = true;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    udev = {
      extraRules = ''
        ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 41 /dev/%k"
        ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
      '';
    };
  };
}
