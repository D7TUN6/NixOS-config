{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.services.markov-bot;
  botDir = "/home/d7tun6/files/mounts/TS480SSD/services/bot-dvigunchik";
  botEnv = pkgs.python3.withPackages (ps:
    with ps; [
      python-telegram-bot
      aiosqlite
    ]);
in {
  options.services.markov-bot = {
    enable = lib.mkEnableOption "markov chain telegram bot (dvigunchik)";

    dbPath = lib.mkOption {
      type = lib.types.str;
      default = "${botDir}/brain_v2.db";
      description = "path to sqlite database (DB_PATH)";
    };

    migrateJson = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "optional path to legacy brain_v2.json for one-time migration (MIGRATE_JSON)";
    };
  };

  config = {
    services.markov-bot.enable = lib.mkDefault true;

    environment.systemPackages = lib.mkIf cfg.enable [botEnv];

    systemd.services.markov-bot = lib.mkIf cfg.enable {
      description = "markov chain telegram bot (dvigunchik)";
      after = [
        "network-online.target"
        "telegram-bot-api.service"
        "home-d7tun6-files-mounts-TS480SSD.mount"
        "sops-install-secrets.service"
      ];
      wants = ["network-online.target"];
      requires = [
        "telegram-bot-api.service"
        "home-d7tun6-files-mounts-TS480SSD.mount"
        "sops-install-secrets.service"
      ];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = "d7tun6";
        Group = "users";
        WorkingDirectory = botDir;

        EnvironmentFile = [config.sops.secrets.markov-bot-token.path];
        ExecStartPre = "${pkgs.bash}/bin/bash -c 'for i in $(seq 1 60); do ${pkgs.bash}/bin/bash -c \"echo > /dev/tcp/127.0.0.1/8082\" 2>/dev/null && exit 0; sleep 1; done; echo timed out waiting for bot api; exit 1'";
        ExecStart = "${botEnv}/bin/python3 ${botDir}/main.py";

        Environment = [
          "PYTHONUNBUFFERED=1"
          "DB_PATH=${cfg.dbPath}"
          "BOT_API_URL=http://127.0.0.1:8082"
        ] ++ lib.optional (cfg.migrateJson != null) "MIGRATE_JSON=${cfg.migrateJson}";

        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only";
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
        MemoryDenyWriteExecute = false;
        DeviceAllow = "";
        UMask = "0077";
        ReadWritePaths = [botDir];

        Restart = "on-failure";
        RestartSec = 10;
        TimeoutStopSec = 30;
      };
    };
  };
}
