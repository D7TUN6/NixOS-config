{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  systemd = {
    tmpfiles.rules = [
      "d /var/lib/systemd/coredump 0755 root root 3d"
      "w! /sys/module/zswap/parameters/enabled - - - - 0"
      "w! /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 2000"
      "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
    ];
    user = {
      extraConfig = ''
        DefaultLimitNOFILE=523288
        DefaultTimeoutStopSec=5s
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
        DefaultTimeoutStopSec = "5s";    
      };
    };
  };
}
