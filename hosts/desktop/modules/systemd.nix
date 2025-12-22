{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
systemd.services.nginx.serviceConfig.ProtectHome = false;
  systemd = {
    services = {
      minecraft-server-thecomboxmc = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          WorkingDirectory = "/home/d7tun6/files/data/server/data/combox-space/game-servers/mc-1_21_5-private/mc";
          ExecStart = "${pkgs.bash}/bin/bash -c 'cd /home/d7tun6/files/data/server/data/combox-space/game-servers/mc-1_21_5-private/mc && ${pkgs.javaPackages.compiler.temurin-bin.jdk-25}/bin/java -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar --nogui'";
          Restart = "on-failure";
          User = "d7tun6";
        };
      };
    };
    tmpfiles.rules = [
      "d /var/lib/systemd/coredump 0755 root root 3d"
      "w! /sys/module/zswap/parameters/enabled - - - - 0"
      "w! /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 2000"
      "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
    ];
    user = {
      extraConfig = ''
        DefaultLimitNOFILE=523288
        DefaultTimeoutStopSec=15s
      '';
      services = {
        polkit-gnome-authentication-agent-1 = {
          description = "polkit-gnome-authentication-agent-1";
          wantedBy = ["graphical-session.target"];
          wants = ["graphical-session.target"];
          after = ["graphical-session.target"];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
          };
        };
      };
    };
    # extraConfig = "
    #   DefaultLimitNOFILE=523288
    #   DefaultTimeoutStopSec=5s
    # ";
    settings = {
      Manager = {
        DefaultLimitNOFILE = 523288;
        DefaultTimeoutStopSec = "15s";    
      };
    };
  };
}
