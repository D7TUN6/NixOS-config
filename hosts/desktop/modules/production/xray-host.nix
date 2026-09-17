{
  lib,
  pkgs,
  ...
}: let
  vlessPort = 54321;
  xrayConfigTemplate = pkgs.writeText "xray-host-config-template.json" (builtins.toJSON {
    log = {
      level = "warning";
      loglevel = "warning";
    };
    inbounds = [
      {
        tag = "vless-host";
        listen = "0.0.0.0";
        port = vlessPort;
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
        tag = "direct";
        protocol = "freedom";
      }
    ];
  });
in {
  # secrets (xray-reality-private-key, xray-client-uuid) are declared in flake.nix

  networking.firewall.allowedTCPPorts = [vlessPort];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 47984;
      to = 48010;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 47998;
      to = 48010;
    }
  ];

  systemd.services.xray-host-config = {
    description = "Generate host xray config from sops secrets";
    wantedBy = ["multi-user.target"];
    after = ["sops-install-secrets.service"];
    requires = ["sops-install-secrets.service"];
    before = ["xray.service"];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /run/xray-host
      umask 077
      sed \
        -e "s|@XRAY_PRIVATE_KEY@|$(cat /run/secrets/xray-reality-private-key)|" \
        -e "s|@XRAY_UUID@|$(cat /run/secrets/xray-client-uuid)|" \
        ${xrayConfigTemplate} > /run/xray-host/config.json
    '';
  };

  services.xray = {
    enable = true;
    settingsFile = "/run/xray-host/config.json";
  };

  systemd.services.xray.after = ["xray-host-config.service"];
  systemd.services.xray.requires = ["xray-host-config.service"];
}