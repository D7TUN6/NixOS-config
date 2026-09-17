{
  lib,
  ...
}: {
  # Tune the combox-frontend-build timer defined in the combox input module:
  # every 4h instead of hourly, and no Persistent so a reboot doesn't trigger
  # a full npm build during boot (was delaying graphical.target by ~40s).
  systemd.timers.combox-frontend-build.timerConfig = lib.mkForce {
    OnCalendar = "*-*-* 0/4:00:00";
    RandomizedDelaySec = 300;
  };
}