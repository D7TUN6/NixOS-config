{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  networking = {
    hostName = "server";
    enableIPv6 = true;
    hostId = lib.mkDefault "d33db33f";
    useDHCP = true;
    interfaces.eth0.useDHCP = lib.mkDefault true;
    nat = {
      enable = true;
      enableIPv6 = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "enp4s0";
    };
    firewall = {
      enable = true;
      allowPing = false;
      rejectPackets = true;
      allowedTCPPorts = [
        443
        80
        25565
      ];
      allowedUDPPorts = [
        443
        80
        25565
      ];
    };
  };
}
