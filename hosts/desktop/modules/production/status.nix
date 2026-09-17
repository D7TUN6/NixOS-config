{
  config,
  pkgs,
  lib,
  ...
}: let
  siteDir = "/home/d7tun6/files/mounts/TS480SSD/services/site/d7tun6";
  outDir = "${siteDir}/server/generated";
  outFile = "${outDir}/production-status.json";
in {
  # d7tun6.site production status: a root-side collector samples systemd units
  # once a minute and drops a JSON file that the sandboxed Bun API can read.
  # The d7tun6-pm2 service cannot talk to systemd itself (it runs sandboxed
  # with no dbus access), so this file is the boundary between the host and
  # the site's /api/home/production endpoint.
  systemd.tmpfiles.rules = [
    "d ${outDir} 0755 d7tun6 users -"
  ];

  systemd.services.d7tun6-production-status = {
    description = "Collect production service status for d7tun6.site";
    after = ["network.target"];
    path = [pkgs.systemd];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.python3}/bin/python3 ${./status-collect.py} ${outFile}";
    };
  };

  systemd.timers.d7tun6-production-status = {
    description = "Periodic production status collection for d7tun6.site";
    wantedBy = ["multi-user.target"];
    timerConfig = {
      OnBootSec = 30;
      OnCalendar = "*-*-* *:*:00";
      RandomizedDelaySec = 3;
    };
  };
}