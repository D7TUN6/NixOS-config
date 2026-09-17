{
  lib,
  pkgs,
  config,
  ...
}: {
  services = {
    lact.enable = true;
    happ = {
      enable = true;
      forceXwayland = true;
    };
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
    gvfs.enable = true;
    usbguard = {
      enable = false;
      dbus.enable = true;
      implicitPolicyTarget = "block";
      rules = ''
        # root hubs
        allow id 1d6b:0002 # Linux Foundation 2.0 root hub
        allow id 1d6b:0003 # Linux Foundation 3.0 root hub

        # input devices
        allow id 046d:c31c # Logitech Keyboard K120
        allow id 09da:365e # A4Tech Mouse / Input Device

        # internal devices
        allow id 0b05:18f3 # ASUSTek AURA LED Controller
        allow id 8087:0025 # Intel Bluetooth Adapter

        # audio
        allow id 0c76:161e # JMTek USB PnP Audio Device
      '';
    };

    v2raya = {
      enable = true;
      cliPackage = pkgs.xray;
    };
    tailscale = {
      enable = true;
      openFirewall = true;
      authKeyFile = config.sops.secrets.tailscale-key.path;
      useRoutingFeatures = "both";
      disableUpstreamLogging = true;
    };
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    udisks2.enable = true;
  };
}
