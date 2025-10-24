{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services = {
    getty.autologinUser = "d7tun6";
    blueman.enable = true;
    lact.enable = true;
    gvfs.enable = true;
    usbmuxd.enable = false;
    fstrim.enable = true;
    dbus.implementation = "broker";
    zapret = {
      enable = true;
      params = [
        "--dpi-desync=fake,disorder2"
        "--dpi-desync-ttl=1"
        "--dpi-desync-autottl=2"
      ];
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
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      autoLogin = {
        user = "d7tun6";
        enable = false;
      };
    };
    desktopManager = {
      plasma6.enable = true;
      gnome.enable = true;
    };
    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      displayManager = {
        lightdm.enable = lib.mkForce false;
      };
      xkb = {
        layout = "us,ru";
        options = "grp:shift_caps_toggle";
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
        PasswordAuthentication = true;
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "no";
      };
    };
    irqbalance.enable = true;
    earlyoom.enable = true;
  };
}
