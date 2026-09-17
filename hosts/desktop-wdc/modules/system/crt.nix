{
  pkgs,
  ...
}: {
  systemd.services.crt-init-color = {
    description = "load custom samtron crt color profile";
    after = ["display-manager.service"];
    wantedBy = ["graphical.target"];
    path = with pkgs; [ddcutil bash coreutils gnugrep gawk];
    script = ''
      bus=""
      for d in /sys/class/i2c-dev/*; do
        if grep -q "bus-0001" "$d/name" 2>/dev/null; then
          bus="--bus $(basename "$d" | sed 's/i2c-//')"
          break
        fi
      done
      o="--noverify --skip-ddc-checks --sleep-multiplier 1.5"
      for code in "0x16 168" "0x18 101" "0x1a 75" "0x6c 103" "0x6e 104" "0x70 74"; do
        set -- $code
        ddcutil setvcp $1 $2 $bus $o >> /tmp/crt-service.log 2>&1 || true
      done
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.services.crt-init-color-resume = {
    description = "re-apply crt color profile after resume";
    after = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    wants = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    path = with pkgs; [ddcutil bash coreutils gnugrep gawk];
    script = ''
      exec ${pkgs.systemd}/bin/systemctl start crt-init-color.service
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}

