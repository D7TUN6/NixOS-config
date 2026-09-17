{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.services.pivometr;
  botDir = "/home/d7tun6/files/mounts/TS480SSD/services/pivometr";
  botEnv = pkgs.python3.withPackages (ps:
    with ps; [
      python-telegram-bot
      aiosqlite
    ]);
in {
  options.services.pivometr = {
    enable = lib.mkEnableOption "pivometr - local meme drinking bot";

    dbPath = lib.mkOption {
      type = lib.types.str;
      default = "${botDir}/pivometr.db";
      description = "path to sqlite database (DB_PATH)";
    };
  };

  config = {
    services.pivometr.enable = lib.mkDefault true;

    environment.systemPackages = lib.mkIf cfg.enable [botEnv];

    systemd.services.pivometr = lib.mkIf cfg.enable {
      description = "pivometr - local meme drinking bot";
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

        EnvironmentFile = [config.sops.secrets.pivometr-bot-token.path];
        ExecStartPre = "${pkgs.bash}/bin/bash -c 'for i in $(seq 1 60); do ${pkgs.bash}/bin/bash -c \"echo > /dev/tcp/127.0.0.1/8082\" 2>/dev/null && exit 0; sleep 1; done; echo timed out waiting for bot api; exit 1'";
        ExecStart = "${botEnv}/bin/python3 ${botDir}/main.py";

        Environment = [
          "PYTHONUNBUFFERED=1"
          "DB_PATH=${cfg.dbPath}"
          "BOT_API_URL=http://127.0.0.1:8082"
        ];

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
