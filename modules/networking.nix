{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  networking = {
    hostName = "nixos";
    wireless.enable = false;
    networkmanager.enable = false;
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    nat.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
      ];
    };
  };
}
