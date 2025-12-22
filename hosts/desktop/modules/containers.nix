{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  containers = {
    webserver-d7tun6-site = {
      autoStart = true;
      privateNetwork = false;
      bindMounts = {
        "/var/www/d7tun6.site" = {
          hostPath = "/home/d7tun6/files/data/server/data/d7tun6-space/site";
          isReadOnly = false;
        };
      };
      config = { config, pkgs, lib, ... }: {
        networking = {
          nameservers = lib.mkForce [
            "8.8.8.8"
          ];
          firewall = {
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
                addSSL = true;
                enableACME = true;
                root = "/var/www/d7tun6.site";
              };
            };
          };
        };
        security = {
          acme = {
            acceptTerms = true;
            defaults.email = "d7tun6@gmail.com";
          };
        };
        system = {
          stateVersion = "24.11";
        };
      };
    };
  };
}
