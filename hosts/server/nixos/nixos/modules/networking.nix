{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  networking = {
    hostName = "nixos";
    enableIPv6 = true;
    hostId = lib.mkDefault "8425e349";
    useDHCP = true;
    interfaces.eth0.useDHCP = lib.mkDefault true;
    nat.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [
        17011 # Wormnet.
      ];
      allowedUDPPorts = [
        17011 # Wormnet.
      ];
    };
  };
}
