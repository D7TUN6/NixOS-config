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
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::2";
      bindMounts = {
        "/var/www/d7tun6.site" = {
          hostPath = "/home/d7tun6/files/data/server/data/d7tun6-space/site";
          isReadOnly = true;
        };
      };
      config = { config, pkgs, lib, inputs, ... }: {
        networking = {
          nameservers = lib.mkForce [
            "127.0.0.1"
            "::1"
          ];
          stevenBlackHosts = {
            enableIPv6 = true;
          };
          firewall = {
            allowPing = false;
            rejectPackets = true;
            logRefusedConnections = false;
            allowedTCPPorts = [
              67 # DHCP Server.
              443
              80
            ];
            allowedUDPPorts = [
              67 # DHCP Server.
              443
              80
            ];
          };
        };
        services = {
          dnscrypt-proxy = {
            enable = true;
            settings = {
              ipv4_servers = true;
              ipv6_servers = true;
              dnscrypt_servers = true;
              doh_servers = true;
              require_nofilter = true;
              require_dnssec = true;
              query_log.file = "/var/log/dnscrypt-proxy/query.log";
              sources.public-resolvers = {
                urls = [
                  "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                  "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
                ];
                cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
                minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
              };
            };
          };
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
            defaults.email = "d7tun6.site";
          };
        };
        system = {
          stateVersion = "24.11";
        };
      };
    };
  };
}
