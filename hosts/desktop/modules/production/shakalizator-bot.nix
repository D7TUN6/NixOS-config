{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.services.shakalizator-bot;
  dataDir = "/home/d7tun6/files/mounts/TS480SSD/services/bot-shakalizator/data";
  tmpDir = "/home/d7tun6/files/mounts/TS480SSD/services/bot-shakalizator/tmp";

  botEnv = pkgs.python3.withPackages (ps:
    with ps; [
      python-telegram-bot
      aiosqlite
      pillow
    ]);
in {
  options.services.shakalizator-bot = {
    enable = lib.mkEnableOption "Shakalizator Telegram Bot";
  };

  config = {
    services.shakalizator-bot.enable = lib.mkDefault true;

    environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [
      ffmpeg-headless
      dcraw
      dejavu_fonts
      botEnv
    ]);

    systemd.tmpfiles.rules = lib.mkIf cfg.enable [
      "d ${tmpDir} 0755 d7tun6 users -"
      "d ${dataDir} 0755 d7tun6 users -"
    ];

    systemd.services.bot-shakalizator = lib.mkIf cfg.enable {
      description = "Shakalizator Telegram Bot (Python)";
      after = [
        "network-online.target"
        "telegram-bot-api.service"
        "home-d7tun6-files-mounts-TS480SSD.mount"
        "sops-install-secrets.service"
      ];
      requires = [
        "telegram-bot-api.service"
        "home-d7tun6-files-mounts-TS480SSD.mount"
        "sops-install-secrets.service"
      ];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      path = with pkgs; [
        ffmpeg-headless
        dcraw
        fontconfig
      ];

      serviceConfig = {
        Type = "simple";
        User = "d7tun6";
        Group = "users";
        WorkingDirectory = "/home/d7tun6/files/mounts/TS480SSD/services/bot-shakalizator";
        UMask = "0077";

        EnvironmentFile = [config.sops.secrets.shakalizator-bot-token.path];
        ExecStart = "${botEnv}/bin/python3 /home/d7tun6/files/mounts/TS480SSD/services/bot-shakalizator/main.py";

        Environment = [
          "PYTHONUNBUFFERED=1"
          "SHAKALIZATOR_TEMP_DIR=${tmpDir}"
          "SHAKALIZATOR_DATA_DIR=${dataDir}"
          "SHAKALIZATOR_USE_VAAPI=1"
          "SHAKALIZATOR_VAAPI_DEVICE=/dev/dri/renderD128"
          "SHAKALIZATOR_FFMPEG_LIMIT=1"
          "SHAKALIZATOR_MAX_INPUT_MB=2000"
          "SHAKALIZATOR_MAX_OUTPUT_MB=2000"
          "BOT_API_URL=http://127.0.0.1:8082"
          "LIBVA_DRIVER_NAME=radeonsi"
          "FONTCONFIG_FILE=/etc/fonts/fonts.conf"
        ];

        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        PrivateTmp = true;
        PrivateDevices = false;
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
        DeviceAllow = [
          "/dev/dri/renderD128 rw"
        ];
        ReadWritePaths = [
          "${dataDir}"
          "${tmpDir}"
        ];

        Restart = "on-failure";
        RestartSec = 5;
        TimeoutStopSec = 30;
      };
    };
  };
}
