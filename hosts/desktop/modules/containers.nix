{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  containers = {
    webserver = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.1.10";
      localAddress = "192.168.1.11";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::2";
      bindMounts = {
        "/var/www/d7tun6.site" = {
          hostPath = "/var/www/d7tun6.site";
          isReadOnly = false;
        };
      };
      config = { config, pkgs, lib, ... }: {
        networking = {
          nameservers = lib.mkForce [
            "8.8.8.8"
          ];
          firewall = {
            # allowPing = false;
            # rejectPackets = true;
            # logRefusedConnections = false;
            allowedTCPPorts = [
              443
              80
            ];
            allowedUDPPorts = [
              443
              80
            ];
          };
        };
        services = {
          nginx = {
            enable = true;
            virtualHosts = {
              "d7tun6.site" = {
                # addSSL = true;
                # enableACME = true;
                root = "/var/www/d7tun6.site";
              };
            };
          };
        };
        security = {
          # acme = {
          #   acceptTerms = true;
          #   defaults.email = "d7tun6.site";
          # };
        };
        system = {
          stateVersion = "24.11";
        };
      };
    };
  };
}
