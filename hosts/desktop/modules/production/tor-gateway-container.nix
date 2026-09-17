{
  lib,
  pkgs,
  ...
}: let
  xrayConfigTemplate = pkgs.writeText "xray-config-template.json" (builtins.toJSON {
    log = {
      level = "warning";
      loglevel = "warning";
    };
    inbounds = [
      {
        tag = "vless-tor";
        listen = "0.0.0.0";
        port = 8443;
        protocol = "vless";
        settings = {
          clients = [
            {
              id = "@XRAY_UUID@";
              flow = "xtls-rprx-vision";
            }
          ];
          decryption = "none";
        };
        streamSettings = {
          network = "tcp";
          security = "reality";
          realitySettings = {
            show = false;
            # dest must be reachable through the routed chain (privoxy -> tor),
            # since the fronting handshake follows the same routing rules.
            dest = "www.apple.com:443";
            serverNames = ["www.apple.com"];
            privateKey = "@XRAY_PRIVATE_KEY@";
            shortIds = ["85082626"];
          };
        };
        sniffing = {
          enabled = true;
          destOverride = ["http" "tls"];
        };
      }
    ];
    outbounds = [
      {
        tag = "tor-privoxy";
        protocol = "http";
        settings.servers = [
          {
            address = "127.0.0.1";
            port = 8118;
          }
        ];
      }
      {
        tag = "direct";
        protocol = "freedom";
      }
    ];
    routing = {
      domainStrategy = "AsIs";
      rules = [
        {
          type = "field";
          inboundTag = ["vless-tor"];
          outboundTag = "tor-privoxy";
        }
      ];
    };
  });
in {
  # secrets (xray-reality-private-key, xray-client-uuid) are declared in flake.nix

  # the container's bind mounts need the sops secrets to exist before nspawn starts
  systemd.services."container@tor-gateway" = {
    after = ["sops-install-secrets.service"];
    requires = ["sops-install-secrets.service"];
  };

  containers.tor-gateway = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.233.1.1";
    localAddress = "10.233.1.2";

    bindMounts = {
      "/run/secrets/xray-reality-private-key" = {
        hostPath = "/run/secrets/xray-reality-private-key";
        isReadOnly = true;
      };
      "/run/secrets/xray-client-uuid" = {
        hostPath = "/run/secrets/xray-client-uuid";
        isReadOnly = true;
      };
    };

    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      system.stateVersion = "24.11";
      time.timeZone = "Asia/Yekaterinburg";

      environment.systemPackages = [pkgs.obfs4];

      networking = {
        nameservers = lib.mkForce [
          "8.8.8.8"
          "1.1.1.1"
        ];
        firewall = {
          allowedTCPPorts = [8443 8118];
        };
      };

      services.tor = {
        enable = true;
        client = {
          enable = true;
          dns.enable = true;
        };

        settings = {
          UseBridges = 1;
          ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/lyrebird";
          SocksPort = "127.0.0.1:9051";
          Bridge = [
            "obfs4 51.89.231.85:24526 A44162645CEAA39C7106C49A3F36FD99FF8D8A00 cert=cVNRBh1enpvEGxA0ouu568EDFhWPl9taldydYgiJk77OX4MzoYIRz3qx4q7yHL5bRN60Gg iat-mode=0"
            "obfs4 51.89.228.250:21668 BA8BD67D8898CF378D4F73821DEB5657F4BB98DF cert=bEpLLgOwJ9fOJbeHb5r+ronUF2ck5nRd0Jl3zuy7rLoUp732QK2p/CUHjTAfBPCGfcVtSA iat-mode=0"
            "obfs4 82.64.115.17:990 B08238781C2CD80DBD95AEABEB6F6C75F2E2CEB6 cert=1udeMlFNs3sJ20zwpPE6nShZqqwDb3F1ET4KzfSfD+fktkue9zNx9H3t+yLCPAsg+6UTUA iat-mode=1"
            "obfs4 216.250.97.105:4433 886237343D8956C90CA31DD60428D52B1EC34CE7 cert=R8/DwEPD4r7K91wvSshFVig8Jj94CmWc8eZu3Rl07YnE0lkjkb/bvIbApY/BrmzvALZTeA iat-mode=0"
          ];
        };
      };

      # nspawn's startScript overwrites /etc/resolv.conf with a copy of the
      # host's resolv.conf (nameserver 127.0.0.1), which is unreachable from
      # the container's own netns. openresolv then registers it as the "host"
      # record and keeps regenerating /etc/resolv.conf from it, so the
      # container's own nameservers below are never applied. Fix it after boot:
      # drop the host record and regenerate from networking.nameservers.
      systemd.services.fix-resolv-conf = {
        description = "Point /etc/resolv.conf at the container's own nameservers";
        wantedBy = ["multi-user.target"];
        after = ["resolvconf.service" "networking.service"];
        serviceConfig.Type = "oneshot";
        script = ''
          ln -sfn /run/resolvconf/resolv.conf /etc/resolv.conf
          ${pkgs.openresolv}/bin/resolvconf -d host || true
          ${pkgs.openresolv}/bin/resolvconf -u
        '';
      };

      services.privoxy = {
        enable = true;
        # 0.0.0.0 inside the container: only reachable via the private veth
        # (hostAddress 10.233.1.1 / 10.233.1.0/24), never from the internet.
        settings = {
          listen-address = "0.0.0.0:8118";
          forward-socks5t = "/ 127.0.0.1:9051 .";
        };
      };

      services.xray = {
        enable = true;
        # config is generated at boot from sops secrets by xray-config.service
        settingsFile = "/run/xray/config.json";
      };

      systemd.services.xray-config = {
        description = "Generate xray config from sops secrets";
        wantedBy = ["multi-user.target"];
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /run/xray
          umask 077
          sed \
            -e "s|@XRAY_PRIVATE_KEY@|$(cat /run/secrets/xray-reality-private-key)|" \
            -e "s|@XRAY_UUID@|$(cat /run/secrets/xray-client-uuid)|" \
            ${xrayConfigTemplate} > /run/xray/config.json
        '';
      };

      systemd.services.xray.after = ["xray-config.service" "privoxy.service" "network.target"];
      systemd.services.xray.requires = ["xray-config.service" "privoxy.service"];
    };
  };
}