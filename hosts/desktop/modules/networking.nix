{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  networking = {
    nameservers = lib.mkForce [
      "127.0.0.1"
      "::1"
    ];
    hostName = "desktop";
    enableIPv6 = true;
    hostId = lib.mkDefault "8425e349";
    networkmanager = {
      enable = true;
      dhcp = "dhcpcd";
      dns = "none";
    };
    dhcpcd = {
      enable = true;
      extraConfig = "nohook resolv.conf";
      persistent = true;  
    };
    nat = {
      enable = true;
      # internalInterfaces = [ "ens3" ];
      # externalInterface = "wg0";
    };
    # interfaces = {
    # };
    firewall = {
      enable = true;
      allowPing = false;
      rejectPackets = true;
      allowedTCPPorts = [
        67 # DHCP Server.
        17011 # Wormnet.
        25565 # Minecraft Server.
        2017 # v2raya web interface.
      ];
      allowedUDPPorts = [
        67 # DHCP Server.
        17011 # Wormnet.
        25565 # Minecraft Server.
        2017 # v2raya web interface.
      ];
    };
  };
}


