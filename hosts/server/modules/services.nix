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
      ];
      params = [
        "--dpi-desync=fake,disorder2"
        "--dpi-desync-ttl=1"
        "--dpi-desync-autottl=2"
      ];
    };
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
      autoLogin = {
        user = "d7tun6";
        enable = true;
      };
      defaultSession = "niri";
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
        options = "grp:caps_toggle";
      };
    };
    zfs = {
      autoScrub = {
        enable = true;
        pools = [
          "zroot"
        ];
        randomizedDelaySec = "12h";
        interval = "monthly";
      };
      trim = {
        enable = true;
        randomizedDelaySec = "12h";
        interval = "weekly";
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
