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
    hostName = "laptop";
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
    };
    interfaces = {
      eth0 = {
        mtu = 1400;
      };
    };
    firewall = {
      enable = true;
      allowPing = false;
      rejectPackets = true;
      allowedTCPPorts = [
        67 # DHCP Server.
      ];
      allowedUDPPorts = [
        67 # DHCP Server.
      ];
    };
  };
}


