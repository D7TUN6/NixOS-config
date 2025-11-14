{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  networking = {
    hostName = "desktop";
    enableIPv6 = true;
    hostId = lib.mkDefault "8425e349";
    networkmanager = {
      enable = true;
    };
    interfaces.eth0.useDHCP = lib.mkDefault true;
    nat.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
      rejectPackets = true;
      allowedTCPPorts = [
        # 17011 # Wormnet.
      ];
      allowedUDPPorts = [
        # 17011 # Wormnet.
      ];
    };
  };
}
