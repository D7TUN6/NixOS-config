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
    useDHCP = lib.mkDefault true;
    interfaces.eth0.useDHCP = lib.mkDefault true;
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
