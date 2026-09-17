{
  config,
  pkgs,
  ...
}: {
  systemd.services.disable-turbo-and-c6 = {
    description = "Disable AMD Turbo Boost and C6 state";
    after = ["sysinit.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '
          echo 0 > /sys/devices/system/cpu/cpufreq/boost
          ${pkgs.zenstates}/bin/zenstates --c6-disable
        '
      '';
    };
  };
}
