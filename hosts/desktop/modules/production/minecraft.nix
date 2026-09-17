{pkgs, config, ...}: let
  rcon_port = "25575";
  mc_port = "25566";
  proxy_port = "25565";
  mc_dir = "/home/d7tun6/files/mounts/TS480SSD/services/minecraft";
  lazymcConfig = ../../smth/config/lazymc.toml;
  rconPasswordSecret = config.sops.secrets.minecraft-rcon-password.path;
  # GraalVM CE 25 — optimized for Ryzen 5 2600 (6C/12T, 3.9 GHz boost, 16 GB DDR4-2800)
  javaFlags = builtins.concatStringsSep " " [
    # Heap: start small, grow up to 8 GB on demand — idle server uses ~2 GB
    "-Xms2G" "-Xmx8G"

    # Must come before experimental flags below (G1NewSizePercent etc.)
    "-XX:+UnlockExperimentalVMOptions"

    # G1GC — tuned for 8 GB heap on 12-thread CPU
    "-XX:+UseG1GC"
    "-XX:MaxGCPauseMillis=40"
    "-XX:G1HeapRegionSize=8M"
    "-XX:G1NewSizePercent=15"
    "-XX:G1MaxNewSizePercent=30"
    "-XX:G1ReservePercent=20"
    "-XX:G1HeapWastePercent=5"
    "-XX:G1MixedGCCountTarget=6"
    "-XX:G1MixedGCLiveThresholdPercent=75"
    "-XX:InitiatingHeapOccupancyPercent=35"
    "-XX:+ParallelRefProcEnabled"
    "-XX:+DisableExplicitGC"
    "-XX:-UseAdaptiveSizePolicy"

    # Thread pools — reserve 2 cores for OS/other services
    "-XX:ActiveProcessorCount=10"
    "-XX:ConcGCThreads=4"
    "-XX:ParallelGCThreads=10"

    # GraalVM CE JIT optimizations
    "-XX:+UseStringDeduplication"
    "-XX:+UseVectorCmov"

    # Sockets / memory
    "-XX:+UseContainerSupport"
    "-XX:+UseTransparentHugePages"
  ];
in {
  systemd.services.lazymc = {
    description = "LazyMC proxy - wake-on-login for Minecraft server";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lazymc}/bin/lazymc --config ${lazymcConfig}";
      Restart = "always";
      RestartSec = "3s";
      User = "root";

      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = ["@system-service" "~@obsolete"];
    };
  };

  systemd.services.minecraft = {
    description = "Minecraft server (controlled by lazymc)";
    after = ["network.target"];
    serviceConfig = {
      User = "d7tun6";
      Group = "users";
      WorkingDirectory = mc_dir;
      ExecStart = "${pkgs.graalvmPackages.graalvm-ce}/bin/java ${javaFlags} -jar server.jar nogui";
      ExecStop = "${pkgs.bash}/bin/bash -c 'source ${rconPasswordSecret} && exec ${pkgs.mcrcon}/bin/mcrcon -h 127.0.0.1 -P ${rcon_port} -p \"$RCON_PASSWORD\" save-all stop'";
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStopSec = 60;
      SuccessExitStatus = 143;

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
      # Paper's bundled spark starts a background profiler that calls
      # perf_event_open, which @system-service blocks => SIGSYS crash loop.
      # Allow just that one syscall while keeping the rest of the sandbox.
      # (Note: "+name" is NOT valid systemd filter syntax — plain name entry.)
      SystemCallFilter = ["@system-service" "~@obsolete" "perf_event_open"];
      RemoveIPC = true;
      RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK"];
      MemoryDenyWriteExecute = false;
      DeviceAllow = "";
      UMask = "0077";
      ReadWritePaths = [mc_dir];
    };
  };
}
