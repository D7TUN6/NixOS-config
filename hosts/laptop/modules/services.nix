{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services = {
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
  };
}
