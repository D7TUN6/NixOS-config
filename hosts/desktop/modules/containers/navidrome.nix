{...}: let
  musicPath = "/home/d7tun6/files/mounts/wd-purple/files/media/Audio/Music";
  navidromeDataPath = "/home/d7tun6/files/mounts/TS480SSD/services/navidrome-data";
in {
  containers.navidrome = {
    autoStart = true;
    privateNetwork = false;
    forwardPorts = [
      {
        containerPort = 4533;
        hostPort = 4533;
        protocol = "tcp";
      }
    ];

    bindMounts = {
      "/media/music" = {
        hostPath = musicPath;
        isReadOnly = true;
      };
      "/var/lib/navidrome" = {
        hostPath = navidromeDataPath;
        isReadOnly = false;
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
      users.users.d7tun6 = {
        isNormalUser = true;
        group = "users";
      };
      users.groups.d7tun6 = {};
      networking = {
        nameservers = lib.mkForce [
          "8.8.8.8"
          "1.1.1.1"
        ];
        firewall = {
          allowedTCPPorts = [4533];
          allowedUDPPorts = [4533];
        };
      };
      services.navidrome = {
        enable = true;
        settings = {
          Address = "0.0.0.0";
          Port = 4533;
          MusicFolder = "/media/music";
          DataFolder = "/var/lib/navidrome";
        };
      };
    };
  };
}
