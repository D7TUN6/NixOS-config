{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.services.blurt-bot;
  botDir = "/home/d7tun6/files/mounts/TS480SSD/services/blurt";
  botEnv = pkgs.python3.withPackages (ps: with ps; [
    python-telegram-bot
    aiosqlite
    aiohttp
    onnxruntime
    numpy
  ]);
in {
  options.services.blurt-bot = {
    enable = lib.mkEnableOption "blurt telegram chat manager bot";

    dbPath = lib.mkOption {
      type = lib.types.str;
      default = "${botDir}/blurt.db";
      description = "path to sqlite database (DB_PATH)";
    };

    sensevoiceModel = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "${botDir}/models/gigaam";
      description = "path to ASR ONNX model directory";
    };
  };

  config = {
    services.blurt-bot.enable = lib.mkDefault true;

    systemd.services.blurt-bot = lib.mkIf cfg.enable {
      description = "blurt telegram chat manager bot";
      after = [
        "network-online.target"
        "telegram-bot-api.service"
        "ollama.service"
        "home-d7tun6-files-mounts-TS480SSD.mount"
        "sops-install-secrets.service"
      ];
      wants = ["network-online.target"];
      requires = [
        "telegram-bot-api.service"
        "ollama.service"
        "home-d7tun6-files-mounts-TS480SSD.mount"
        "sops-install-secrets.service"
      ];
      wantedBy = ["multi-user.target"];

      path = with pkgs; [
        espeak-ng
        nanotts
        ffmpeg
      ];

      serviceConfig = {
        Type = "simple";
        User = "d7tun6";
        Group = "users";
        WorkingDirectory = botDir;

        EnvironmentFile = [config.sops.secrets.blurt-bot-token.path];
        ExecStartPre = "${pkgs.bash}/bin/bash -c 'for i in $(seq 1 60); do ${pkgs.bash}/bin/bash -c \"echo > /dev/tcp/127.0.0.1/8082\" 2>/dev/null && exit 0; sleep 1; done; echo timed out waiting for bot api; exit 1'";
        ExecStart = "${botEnv}/bin/python3 ${botDir}/main.py";

        Environment = [
          "PYTHONUNBUFFERED=1"
          "DB_PATH=${cfg.dbPath}"
          "BOT_API_URL=http://127.0.0.1:8082"
          "OLLAMA_HOST=http://127.0.0.1:11434"
          "OLLAMA_MODEL=mistral:7b-instruct"
        ] ++ lib.optional (cfg.sensevoiceModel != null) "SENSEVOICE_MODEL=${cfg.sensevoiceModel}";

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
        SystemCallFilter = ["@system-service" "~@obsolete"];
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
