{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.telegram-bot-api;
in {
  options.services.telegram-bot-api = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the local Telegram Bot API server (tdlib)";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8082;
      description = "HTTP port for the local Bot API server";
    };

    maxFileSizeMb = lib.mkOption {
      type = lib.types.int;
      default = 2000;
      description = "Max upload/download file size in MB (default is 20)";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.telegram-bot-api = {
      isSystemUser = true;
      group = "telegram-bot-api";
      home = "/var/lib/telegram-bot-api";
      createHome = true;
      # NixOS activation re-applies homeMode on every switch (default 0700),
      # overriding StateDirectoryMode; keep both in sync so d7tun6 can traverse.
      homeMode = "0750";
    };
    users.groups.telegram-bot-api = {};
    # shakalizator-bot (runs as d7tun6) reads downloaded media directly from
    # the state dir: in --local mode getFile returns an absolute filesystem
    # path and the server has no HTTP /file/bot<token>/ endpoint at all.
    users.users.d7tun6.extraGroups = ["telegram-bot-api"];

    systemd.services.telegram-bot-api = {
      description = "Local Telegram Bot API server (tdlib)";
      after = [
        "sops-install-secrets.service"
        "podman-tg-ws-proxy.service"
        "network.target"
      ];
      requires = [
        "sops-install-secrets.service"
        "podman-tg-ws-proxy.service"
      ];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = "telegram-bot-api";
        Group = "telegram-bot-api";
        StateDirectory = "telegram-bot-api";
        # 0750: group (telegram-bot-api) may traverse; bot user is in the group
        StateDirectoryMode = "0750";

        EnvironmentFile = [
          config.sops.secrets.telegram-bot-api-id.path
          config.sops.secrets.telegram-bot-api-hash.path
          config.sops.secrets.tg-ws-proxy-secret.path
          config.sops.secrets.shakalizator-bot-token.path
          config.sops.secrets.markov-bot-token.path
          config.sops.secrets.blurt-bot-token.path
          config.sops.secrets.blogbot-token.path
        ];

        # local mode: one directory per bot token
        ExecStartPre = pkgs.writeShellScript "telegram-bot-api-token-dirs" ''
          set -eu
          mkdir -p "/var/lib/telegram-bot-api/$SHAKALIZATOR_BOT_TOKEN" "/var/lib/telegram-bot-api/$MARKOV_BOT_TOKEN" "/var/lib/telegram-bot-api/$BLURT_BOT_TOKEN" "/var/lib/telegram-bot-api/$BLOGBOT_TOKEN"
          chmod -R g+rX /var/lib/telegram-bot-api/
        '';

        # --local lifts the 20MB file size limits (up to 2000MB).
        # No MTProto proxy support in telegram-bot-api: TDLib connects to its
        # built-in DC IPs; dc2/dc4 (149.154.167.220) is the open one here.
        ExecStart = pkgs.writeShellScript "telegram-bot-api-start" ''
          exec ${pkgs.telegram-bot-api}/bin/telegram-bot-api \
            --api-id="$TELEGRAM_BOT_API_ID" \
            --api-hash="$TELEGRAM_BOT_API_HASH" \
            --http-ip-address=127.0.0.1 \
            --http-port=${toString cfg.port} \
            --dir=/var/lib/telegram-bot-api \
            --local
        '';

        Restart = "on-failure";
        RestartSec = 5;
        TimeoutStopSec = 30;

        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = [""];
        AmbientCapabilities = [""];
        SystemCallArchitectures = "native";
        SystemCallFilter = ["@system-service" "~@privileged" "~@resources" "~@obsolete"];
        RemoveIPC = true;
        RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK"];
        DeviceAllow = "";
      };
    };
  };
}