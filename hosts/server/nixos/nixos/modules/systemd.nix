{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
    network.wait-online.enable = false;
    tmpfiles.rules = [
      # "w! /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
      "d /var/lib/systemd/coredump 0755 root root 3d"
      "w! /sys/module/zswap/parameters/enabled - - - - 0"
      "w! /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 2000"
      "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
      # "w /sys/kernel/mm/transparent_hugepage/enabled - - - - madvise"
      # "w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - advise"
      # "w /sys/kernel/mm/transparent_hugepage/defrag - - - - never"
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
    settings.Manager = {
      DefaultLimitNOFILE = "523288";
      DefaultTimeoutStopSec = "5s";
    };
  };
}
