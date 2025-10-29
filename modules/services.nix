{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services = {
    blueman.enable = true;
    lact.enable = true;
    gvfs.enable = true;
    usbmuxd.enable = false;
    fstrim.enable = true;
    dbus.implementation = "broker";
    # zapret = {
    #   enable = true;
    #   params = [
    #     "--dpi-desync=fake,disorder2"
    #     "--dpi-desync-ttl=1"
    #     "--dpi-desync-autottl=2"
    #   ];
    # };
  tor = {
      enable = true;
      client = {
        enable = true;
        transparentProxy.enable = false; # Отключаем для ручной настройки браузера
      };
      settings = {
        UseBridges = true;
        ClientTransportPlugin = "webtunnel exec ${pkgs.obfs4}/bin/obfs4proxy";
      
        Bridge = "webtunnel [2001:db8:5d90:6cd2:fcac:ea1c:67b2:bee0]:443 D85733AB26E770DC4AB2ED44A0559504550D0925 url=https://qbxa1hay.xoomlia.com/k0tf6syz/ ver=0.0.1";
      
        # SOCKSPort = 9050;
        # ControlPort = 9051;
        SOCKSPolicy = "accept 127.0.0.1";
      
        CircuitBuildTimeout = 10;
        LearnCircuitBuildTimeout = 0;
        NumEntryGuards = 2;
        UseEntryGuards = true;
      };
    };
    resolved = {
      enable = lib.mkForce false;
    };
    dnscrypt-proxy = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
          server_names = [
            "cloudflare"
            "cloudflare-ipv6"
            "adguard-dns-doh"
            "adguard-dns-doh-ipv6"
          ];
        };
      };
    logind = {
      settings.Login = {
        HandlePowerKey = "poweroff";
      };
    };
    flatpak = {
      enable = true;
    };
    displayManager = {
      gdm = {
        enable = true;
        # wayland.enable = true;
      };
      autoLogin = {
        user = "d7tun6";
        enable = false;
      };
    };
    desktopManager = {
      gnome.enable = true;
    };
    xserver = {
      enable = true;
      windowManager = {
        dwm.enable = true;
      };
      videoDrivers = ["amdgpu"];
      displayManager = {
        lightdm.enable = lib.mkForce false;
      };
      xkb = {
        layout = "us,ru";
        options = "grp:caps_toggle";
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
    udev.extraRules = ''
      # Audio
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      ACTION=="add", SUBSYSTEM=="sound", KERNEL=="card*", DRIVERS=="snd_hda_intel", TEST!="/run/udev/snd-hda-intel-powersave", \
          RUN+="${pkgs.bash}/bin/bash -c 'touch /run/udev/snd-hda-intel-powersave; \
              [[ $$(cat /sys/class/power_supply/BAT0a/status 2>/dev/null) != \"Discharging\" ]] && \
              echo $$(cat /sys/module/snd_hda_intel/parameters/power_save) > /run/udev/snd-hda-intel-powersave && \
              echo 0 > /sys/module/snd_hda_intel/parameters/power_save'"

      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", TEST=="/sys/module/snd_hda_intel", \
          RUN+="${pkgs.bash}/bin/bash -c 'echo $$(cat /run/udev/snd-hda-intel-powersave 2>/dev/null || \
              echo 10) > /sys/module/snd_hda_intel/parameters/power_save'"

      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", TEST=="/sys/module/snd_hda_intel", \
          RUN+="${pkgs.bash}/bin/bash -c '[[ $$(cat /sys/module/snd_hda_intel/parameters/power_save) != 0 ]] && \
              echo $$(cat /sys/module/snd_hda_intel/parameters/power_save) > /run/udev/snd-hda-intel-powersave; \
              echo 0 > /sys/module/snd_hda_intel/parameters/power_save'"
      
      # PCI
      ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"

      # HDD
      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

      # eMMC/SD/microSD cards
      ACTION=="add|change", KERNEL=="mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

      # SSD
      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

      # NVMe SSD
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

      # SATA
      ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}=="*", ATTR{link_power_management_policy}="max_performance"

      # HDPARM
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTRS{id/bus}=="ata", RUN+="${pkgs.hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"
    '';
    printing.enable = lib.mkForce false;
    pulseaudio.enable = lib.mkForce false;
    openssh = {
      enable = true;
      ports = [ 21001 ];
      settings = {
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
    };
    irqbalance.enable = true;
    earlyoom.enable = true;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
  };
}
