{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  networking = {
    hostName = "laptop";
    enableIPv6 = true;
    hostId = lib.mkDefault "laptn33x";
    useDHCP = true;
    interfaces.eth0.useDHCP = lib.mkDefault true;
    nat.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
      rejectPackets = true;
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
      ];
    };
  };
}
