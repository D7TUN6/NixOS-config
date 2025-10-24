{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    nat.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [
        17011
        21001
      ];
      allowedUDPPorts = [
        17011
        21001
      ];
    };
  };
}
