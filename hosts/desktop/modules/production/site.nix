{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  siteDir = "/home/d7tun6/files/mounts/TS480SSD/services/site/d7tun6";
  appDir = siteDir;
  appUser = "d7tun6";
  appGroup = "users";
  envFile = "${appDir}/.env";
  pm2Dir = "${appDir}/.pm2";
  bun = inputs.nix-bun.packages.x86_64-linux.default;
in {
  # d7tun6 24/7 radio: icecast (loopback :8000, Ogg Vorbis /stream.ogg) +
  # liquidsoap streamer. The site's server proxies /api/radio/stream from
  # 127.0.0.1:8000 and a NowPlayingTracker polls icecast status-json for live
  # metadata. The radio module ships with the site repo so it versions together
  # with liquidsoap.liq / playlist handling.
  imports = [ "${inputs.d7tun6-radio}/nixos-module.nix" ];

  environment.etc."d7tun6-radio/liquidsoap.liq".source = "${inputs.d7tun6-radio}/liquidsoap.liq";

  services.d7tun6-radio = {
    enable = true;
    playlistHost = "127.0.0.1";
    playlistPort = 3001;
    # Baked into icecast.xml + the liquidsoap service env at build time.
    # Rotate by editing this value and re-running nixos-rebuild switch.
    icecastSourcePassword = "MthJxjkKuFvCTenpxF75NzJ0";
    domain = "radio.d7tun6.site";
    # Background priority: keep the 24/7 streamer from starving the interactive
    # desktop or the d7tun6 site server (CPU/IO weight + idle IO + hard caps).
    niceLevel = 15;
    cpuWeight = 20;
    ioWeight = 20;
    cpuQuota = "50%";
    memoryMax = "512M";
  };

  # Polkit: allow d7tun6 to restart d7tun6-pm2.service without sudo
  security.polkit.extraConfig = lib.mkAfter ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          subject.user == "${appUser}" &&
          action.lookup("unit") == "d7tun6-pm2.service") {
        return polkit.Result.YES;
      }
    });
  '';

  systemd.tmpfiles.rules = [
    "d ${appDir}/logs 0755 ${appUser} ${appGroup} -"
    "d ${pm2Dir} 0755 ${appUser} ${appGroup} -"
  ];

  systemd.services.d7tun6-build = {
    description = "d7tun6 site build (frontend + server)";
    after = ["network.target"];
    path = [bun] ++ (with pkgs; [nodejs_24 ffmpeg git bash coreutils systemd]);
    environment = {HOME = appDir;};
    serviceConfig = {
      Type = "oneshot";
      User = appUser;
      Group = appGroup;
      WorkingDirectory = appDir;

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
      ReadWritePaths = [appDir];
    };
    script = ''
      set -a
      . <(grep -v '^\s*#' "${envFile}")
      set +a
      bun install --frozen-lockfile
      bun run build
    '';
  };

  systemd.timers.d7tun6-build = {
    description = "d7tun6 periodic rebuild";
    wantedBy = ["multi-user.target"];
    timerConfig = {
      OnCalendar = "*-*-* 0/4:00:00";
      RandomizedDelaySec = 300;
    };
  };

  systemd.services.d7tun6-pm2 = {
    description = "d7tun6 pm2 (web cluster + worker)";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    path = [bun] ++ (with pkgs; [nodejs_24 ffmpeg pm2 coreutils glibc]);

    environment = {
      HOME = appDir;
      LD_LIBRARY_PATH = lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib];
    };

    serviceConfig = {
      Type = "simple";
      User = appUser;
      Group = appGroup;
      WorkingDirectory = appDir;
      EnvironmentFile = envFile;
      TimeoutStartSec = 60;
      TimeoutStopSec = 30;
      Restart = "on-failure";
      RestartSec = 5;
      ExecStartPre = pkgs.writeShellScript "pm2-prestart" ''
        mkdir -p "${pm2Dir}" "${appDir}/logs"
      '';
      ExecStart = "${pkgs.pm2}/bin/pm2-runtime ecosystem.config.js --env production";
      ExecStopPost = "${pkgs.pm2}/bin/pm2 kill";

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
      ReadWritePaths = [appDir];
    };
  };

  systemd.services.caddy = {
    after = ["sops-install-secrets.service"];
    requires = ["sops-install-secrets.service"];
  };

  services.caddy = {
    enable = true;
    globalConfig = ''
      servers {
        protocols h1 h2 h3
        timeouts {
          read_body 1800s
          read_header 10s
          write 1800s
          idle 10m
        }
      }
    '';
    virtualHosts."d7tun6.neome.uk".extraConfig = ''
      tls /run/secrets/cloudflare-origin-cert /run/secrets/cloudflare-origin-key
      encode {
        zstd best
        gzip 9
      }
      request_body {
        max_size 10gb
      }
      header {
        strict-transport-security "max-age=63072000; includesubdomains; preload"
        x-content-type-options "nosniff"
        -x-frame-options
        -referrer-policy
      }
      @not-assets path_regexp !/assets/.*
      header @not-assets {
        cache-control "no-cache"
      }
      header /assets/* {
        cache-control "public, max-age=31536000, immutable"
      }
      reverse_proxy 127.0.0.1:3001 {
        transport http {
          read_timeout 1800s
          write_timeout 1800s
        }
      }
    '';
    virtualHosts."cb.neome.uk".extraConfig = ''
      tls /run/secrets/cloudflare-origin-cert /run/secrets/cloudflare-origin-key
      reverse_proxy 10.90.0.2:80 {
        transport http {
          read_timeout 600s
          write_timeout 600s
        }
      }
    '';
  };

  services.redis.servers.d7tun6 = {
    enable = true;
    port = 6379;
    bind = "127.0.0.1";
  };
}
