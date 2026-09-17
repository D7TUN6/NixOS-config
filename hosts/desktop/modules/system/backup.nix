{
  pkgs,
  ...
}: {
  systemd.services.backup-services = {
    unitConfig = {
      # both the source (TS480SSD) and destination (wd-purple) must be mounted,
      # otherwise we'd write an empty/partial archive and prune real ones
      RequiresMountsFor = [
        "/home/d7tun6/files/mounts/wd-purple"
        "/home/d7tun6/files/mounts/TS480SSD"
      ];
    };
    path = with pkgs; [
      gnutar
      pigz
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

      # Exclude recreatable/duplicate content (npm/node deps, git history,
      # rust targets, old site versions, prev backup copies). Live production
      # data (site source, bots, minecraft, combox, vaultwarden, navidrome,
      # boxchat) is still archived.
      mkdir -p "$DEST_DIR"

      ${pkgs.gnutar}/bin/tar \
        --use-compress-program=${pkgs.pigz}/bin/pigz \
        -cf "$DEST_DIR/$FILENAME" \
        --ignore-failed-read \
        --exclude='*/node_modules' \
        --exclude='*/.git' \
        --exclude='*/target' \
        --exclude='*/.cache' \
        --exclude='*/BACKUP' \
        --exclude='*/olds' \
        --exclude='*/d7tun6-node-back' \
        --exclude='*/d7tun6-rust' \
        -C "$SRC" .
      ${pkgs.findutils}/bin/find "$DEST_DIR" -maxdepth 1 -name 'backup-*.tar.gz' -printf '%T@ %p\0' \
        | ${pkgs.coreutils}/bin/sort -rn \
        | ${pkgs.coreutils}/bin/cut -z -d' ' -f2- \
        | ${pkgs.coreutils}/bin/tail -z -n +4 \
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

