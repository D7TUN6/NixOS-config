{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services = {
    fstrim.enable = true;
    power-profiles-daemon.enable = false;
    flatpak = {
      enable = false;
    };
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      autoLogin = {
        user = "d7tun6";
        enable = true;
      };
    };
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
    das_watchdog.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
      };
    };
    udev.extraRules = ''
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
    '';
    printing.enable = lib.mkForce false;
    pulseaudio.enable = lib.mkForce false;
    ananicy = {
      enable = false;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos_git;
    };
    irqbalance.enable = false;
    earlyoom.enable = true;
  };
}
