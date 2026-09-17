{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.services.blogbot;
  botDir = "/home/d7tun6/files/mounts/TS480SSD/services/blogbot";
  siteRoot = "/home/d7tun6/files/mounts/TS480SSD/services/site/d7tun6";
  tmpDir = "${botDir}/tmp";

  botEnv = pkgs.python3.withPackages (ps: [
    ps.python-telegram-bot
  ]);
in {
  options.services.blogbot = {
    enable = lib.mkEnableOption "blogbot - Telegram channel -> site /blog live publisher";
  };

  config = {
    services.blogbot.enable = lib.mkDefault true;

    systemd.tmpfiles.rules = lib.mkIf cfg.enable [
      "d ${botDir} 0755 d7tun6 users -"
      "d ${tmpDir} 0755 d7tun6 users -"
      "d ${siteRoot}/content/mdx/ru/blog 0755 d7tun6 users -"
      "d ${siteRoot}/content/mdx/en/blog 0755 d7tun6 users -"
      "d ${siteRoot}/public/media/blog 0755 d7tun6 users -"
    ];

    systemd.services.blogbot = lib.mkIf cfg.enable {
      description = "blogbot — Telegram channel -> site /blog live publisher";
      after = [
        "network-online.target"
        "telegram-bot-api.service"
        "sops-install-secrets.service"
        "home-d7tun6-files-mounts-TS480SSD.mount"
      ];
      wants = ["network-online.target"];
      requires = [
        "telegram-bot-api.service"
        "sops-install-secrets.service"
        "home-d7tun6-files-mounts-TS480SSD.mount"
      ];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = "d7tun6";
        Group = "users";
        WorkingDirectory = botDir;
        UMask = "0077";

        EnvironmentFile = [config.sops.secrets.blogbot-token.path];
        ExecStart = "${botEnv}/bin/python3 ${botDir}/blogbot.py";

        Environment = [
          "PYTHONUNBUFFERED=1"
          "BLOGBOT_BOT_API_URL=http://127.0.0.1:8082"
          "BLOGBOT_CHANNEL_ID=-1001667272666"
          "BLOGBOT_SITE_ROOT=${siteRoot}"
          "BLOGBOT_STATE=${botDir}/blogbot-state.json"
          "BLOGBOT_TMP=${tmpDir}"
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
        DeviceAllow = "";
        ReadWritePaths = [
          botDir
          "${siteRoot}/content/mdx"
          "${siteRoot}/public/media/blog"
        ];

        Restart = "on-failure";
        RestartSec = 5;
        TimeoutStopSec = 30;
      };
    };
  };
}