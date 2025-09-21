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
    networkmanager.enable = true;
    nat.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [
        47610 # P2P
        25565 # Minecraft
        443 # HTTPS
        80 # HTTP
        34655 # SSH
      ];
      allowedUDPPorts = [
        47610 # P2P
        25565 # Minecraft
        443 # HTTPS
        80 # HTTP
        34655 # SSH
      ];
    };
  };
}
