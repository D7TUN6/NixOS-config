{
  pkgs,
  ...
}: {
  systemd.services.backup-services = {
    unitConfig = {
      RequiresMountsFor = "/home/d7tun6/files/mounts/wd-purple";
    };
    path = with pkgs; [
      gnutar
      gzip
      coreutils
      findutils
      gnugrep
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "d7tun6";
      Nice = 19;
      IOSchedulingClass = "idle";
      TimeoutStartSec = "60min";
    };
    script = ''
      SRC="/home/d7tun6/files/mounts/TS480SSD/services"
      DEST_DIR="/home/d7tun6/files/mounts/wd-purple/files/services"
      TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
      FILENAME="backup-$TIMESTAMP.tar.gz"

      mkdir -p "$DEST_DIR"

      ${pkgs.gnutar}/bin/tar -czf "$DEST_DIR/$FILENAME" --ignore-failed-read -C "$SRC" .
      ${pkgs.findutils}/bin/find "$DEST_DIR" -maxdepth 1 -name 'backup-*.tar.gz' -printf '%T@ %p\0' \
        | ${pkgs.coreutils}/bin/sort -rn \
        | ${pkgs.coreutils}/bin/cut -z -d' ' -f2- \
        | ${pkgs.coreutils}/bin/tail -z -n +11 \
        | ${pkgs.findutils}/bin/xargs -0 rm -- || true
    '';
  };

  systemd.timers.backup-services = {
    description = "Timer for backup-services";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "backup-services.service";
    };
  };
}

