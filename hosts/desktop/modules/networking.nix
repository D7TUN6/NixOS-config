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
    stevenBlackHosts = {
      enableIPv6 = true;
    };
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
      internalInterfaces = ["ve-+"];
      externalInterface = "ens3";
    };
    interfaces = {
      eth0 = {
        mtu = 1500;
      };
    };
    firewall = {
      enable = true;
      allowPing = false;
      rejectPackets = true;
      logRefusedConnections = false;
      allowedTCPPorts = [
        67 # DHCP Server.
        17011 # Wormnet.
        25565 # Minecraft Server.
        2017 # v2raya web interface.
        21435 # SSH
        444 # vpn server
        443
        80
        1080
        53
        14027
        5201
        5001
      ];
      allowedUDPPorts = [
        67 # DHCP Server.
        17011 # Wormnet.
        25565 # Minecraft Server.
        2017 # v2raya web interface.
        21435 # SSH
        444 # vpn server
        443
        80
        1080
        53
        14027
        5201
        5001
      ];
    };
  };
}


