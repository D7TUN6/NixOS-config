{pkgs, config, ...}: let
  rcon_port = "25575";
  mc_dir = "/home/d7tun6/files/mounts/TS480SSD/services/minecraft";
  mc_user = "d7tun6";
  rconPasswordSecret = config.sops.secrets.minecraft-rcon-password.path;
  python = pkgs.python3;

  updateScript = pkgs.writeShellScript "mc-auto-update.sh" ''
    set -u

    MC_DIR="${mc_dir}"
    MC_USER="${mc_user}"
    PY="${python}/bin/python3"
    MCRCON="${pkgs.mcrcon}/bin/mcrcon"
    SYSTEMCTL="${pkgs.systemd}/bin/systemctl"
    NOTIFY="${pkgs.systemd}/lib/systemd/systemd-notify"
    FIND="${pkgs.findutils}/bin/find"
    GREP="${pkgs.gnugrep}/bin/grep"
    SED="${pkgs.gnused}/bin/sed"
    TAIL="${pkgs.coreutils}/bin/tail"
    HEAD="${pkgs.coreutils}/bin/head"
    WC="${pkgs.coreutils}/bin/wc"
    RCON_HOST=127.0.0.1
    RCON_PORT=${rcon_port}
    RCON_PW_FILE="${rconPasswordSecret}"

    fail() {
      echo "mc-auto-update FAILED: $*"
      echo "[mc-auto-update] $*" >&2
      "$NOTIFY" --status="mc-auto-update FAILED: $*" --no-block || true
      exit 1
    }

    "$NOTIFY" --ready --no-block || true

    if [ -r "$RCON_PW_FILE" ]; then
      # shellcheck disable=SC1090
      source "$RCON_PW_FILE"
    fi
    players_out="$("$MCRCON" -h "$RCON_HOST" -P "$RCON_PORT" -p "$RCON_PASSWORD" list 2>/dev/null)"
    n="$(printf '%s\n' "$players_out" | "$SED" -nE 's/There are ([0-9]+) of a max.*/\1/p' | "$HEAD" -1)"
    n="''${n:-0}"
    if [ "$n" -gt 0 ]; then
      echo "players online ($n), skipping update window"
      "$NOTIFY" --status="mc-auto-update skipped: $n player(s) online" --no-block || true
      exit 0
    fi

    STAMP="$(date +%Y%m%d-%H%M%S)"
    OUTLOG="$MC_DIR/logs/auto-update-$STAMP.log"
    {
      echo "==== mc-auto-update $STAMP ===="
      echo "players online: $n"
    } | tee "$OUTLOG"
    "$NOTIFY" --status="mc-auto-update: stopping server" --no-block || true

    "$SYSTEMCTL" stop minecraft.service || true

    echo "server stopped, running updater..."
    "$NOTIFY" --status="mc-auto-update: updating core+plugins" --no-block || true
    runuser -u "$MC_USER" -- \
      "$PY" "$MC_DIR/update_server.py" 2>&1 | tee -a "$OUTLOG"
    updater_rc="''${PIPESTATUS[0]}"
    if [ "$updater_rc" -ne 0 ]; then
      latest="$("$FIND" "$MC_DIR/backups" -maxdepth 1 -type d -name 'updater-*' | sort | "$TAIL" -1)"
      if [ -n "$latest" ]; then
        echo "updater failed (rc=$updater_rc), rolling back from $latest"
        runuser -u "$MC_USER" -- "$PY" "$MC_DIR/update_server.py" --rollback "$latest" | tee -a "$OUTLOG"
      fi
      fail "updater error, rolled back"
    fi

    echo "starting server..."
    "$NOTIFY" --status="mc-auto-update: starting server" --no-block || true
    boot_lines="$("$WC" -c < "$MC_DIR/logs/latest.log" 2>/dev/null || echo 0)"
    "$SYSTEMCTL" start minecraft.service || fail "server did not start"

    deadline="$(( $(date +%s) + 180 ))"
    while : ; do
      if "$GREP" -q 'Done (' "$MC_DIR/logs/latest.log" 2>/dev/null; then
        break
      fi
      [ "$(date +%s)" -ge "$deadline" ] && break
      sleep 5
    done

    new_log="$("$TAIL" -c +$((boot_lines + 1)) "$MC_DIR/logs/latest.log" 2>/dev/null)"
    errors="$(printf '%s\n' "$new_log" \
      | "$GREP" -E '^\[[0-9:.]+\] (ERROR|SEVERE):' \
      | "$HEAD" -15)"
    errors="''${errors}$(printf '%s\n' "$new_log" \
      | "$GREP" -iE 'Could not load|Failed to enable|UnsupportedClassVersionError|NoSuchMethod|ClassNotFound|Exception in thread|Failed to load plugin|Invalid plugin|Invalid plugin.yml' \
      | "$HEAD" -15)"
    updater_errors="$("$GREP" -iE 'Traceback|^ERROR| FAILED |checksum mismatch|unexpected plugin' "$OUTLOG" | "$HEAD" -15)"

    if [ -n "$errors" ] || [ -n "$updater_errors" ]; then
      echo "post-update errors detected:"
      echo "$errors"
      echo "$updater_errors"
      "$NOTIFY" --status="mc-auto-update: errors found, rolling back" --no-block || true
      "$SYSTEMCTL" stop minecraft.service || true
      latest="$("$FIND" "$MC_DIR/backups" -maxdepth 1 -type d -name 'updater-*' | sort | "$TAIL" -1)"
      if [ -n "$latest" ]; then
        runuser -u "$MC_USER" -- "$PY" "$MC_DIR/update_server.py" --rollback "$latest" | tee -a "$OUTLOG"
      fi
      "$SYSTEMCTL" start minecraft.service || true
      fail "errors after update, rolled back to previous jars"
    fi

    echo "update OK, server is running with the new jars"
    "$NOTIFY" --status="mc-auto-update OK, server updated" --no-block || true
  '';
in {
  systemd.services.mc-auto-update = {
    description =
      "Biweekly Minecraft core/plugin update window (2-5am, only when empty), with auto-rollback";
    unitConfig.RequiresMountsFor = [mc_dir];
    path = with pkgs; [
      coreutils
      systemd
      util-linux
      mcrcon
      python
      gnugrep
      gawk
      findutils
      gnused
    ];
    environment = {};
    serviceConfig = {
      Type = "notify";
      User = "root";
      TimeoutStartSec = "30min";
      ExecStart = "${updateScript}";
    };
  };

  systemd.timers.mc-auto-update = {
    description =
      "Biweekly timer for mc-auto-update (1st/15th, 02:00-05:00)";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-1/14 02:00:00";
      RandomizedDelaySec = "3h";
      Persistent = true;
    };
  };
}