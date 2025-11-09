{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  containers = {
    "thecomboxmc" = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.15";
      localAddress = "192.168.100.16";
      hostAddress6 = "fc00::5";
      localAddress6 = "fc00::6";
      bindMounts = {
        "/home/user/data" = {
          hostPath = "/home/d7tun6/server/data/thecomboxmc/";
          isReadOnly = false;
        };
      };
      config = {
        config,
        pkgs,
        libs,
        inputs,
        ...
      }: {
        environment.systemPackages = with pkgs; [
          javaPackages.compiler.temurin-bin.jdk-21
          bash
        ];
        networking = {
          nameservers = [
            "8.8.8.8"
            "8.8.4.4"
          ];
          firewall = {
            enable = true;
            allowPing = false;
            rejectPackets = true;
            allowedTCPPorts = [
              25565
              25575
            ];
            allowedUDPPorts = [
              25565
              25575
            ];
          };
        };
        system.stateVersion = "25.11";
        systemd.services.thecomboxmc = {
          wantedBy = [ "multi-user.target" ];
          path = with pkgs; [
            javaPackages.compiler.temurin-bin.jdk-21
            bash
          ];
          serviceConfig = {
            ExecStart = "${pkgs.bash}/bin/bash -c 'cd /home/user/data && ${pkgs.javaPackages.compiler.temurin-bin.jdk-21
}/bin/java -jar server.jar Xms10G -Xmx10G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true --nogui'";
            ExecStop = "${pkgs.mcrcon}/bin/mcrcon -H localhost -P 25575 -p 'A$$w0rd' stop";
            Restart = "always";
            User = "user";
          };
        };
        users = {
          groups.minecraft = {};
          users.user = {
            isSystemUser = true;
            createHome = true;
            group = "minecraft";
          };
        };
      };
    };
  };
}
