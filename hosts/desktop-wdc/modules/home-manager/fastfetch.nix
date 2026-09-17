{...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        {
          type = "os";
          key = "distro ";
        }
        {
          type = "kernel";
          key = "kernel ";
          format = "{1} {2}";
        }
        {
          type = "packages";
          key = "packages ";
        }
        {
          type = "initsystem";
          key = "init ";
        }
        {
          type = "break";
        }
        {
          type = "de";
          key = "de ";
        }
        {
          type = "wm";
          key = "wm ";
        }
        {
          type = "shell";
          key = "sh ";
        }
        {
          type = "terminal";
          key = "term ";
        }
        {
          type = "terminalfont";
          key = "font ";
        }
        {
          type = "theme";
          key = "theme ";
        }
        {
          type = "icons";
          key = "icons ";
        }
        {
          type = "break";
        }
        {
          type = "board";
          key = "board ";
        }
        {
          type = "bios";
          key = "bios ";
        }
        {
          type = "tpm";
          key = "tpm ";
        }
        {
          type = "cpu";
          key = "cpu ";
        }
        {
          type = "gpu";
          key = "gpu ";
        }
        {
          type = "disk";
          key = "disk ";
        }
        {
          type = "memory";
          key = "ram ";
        }
        {
          type = "display";
          key = "disp ";
        }
        {
          type = "localip";
          key = "local ip ";
          showspeed = true;
        }
        {
          type = "uptime";
          key = "uptime ";
        }
        {
          type = "command";
          key = "system age ";
          text = "birth=$(btrfs subvolume show / 2>/dev/null | awk '/Creation time:/ {print $3,$4}'); if [ -n \"$birth\" ]; then echo $(( ($(date +%s) - $(date -d \"$birth\" +%s)) / 86400 )); else echo $(( ($(date +%s) - $(stat -c %W / 2>/dev/null || stat -c %Z /)) / 86400 )); fi";
          format = "{1} days";
        }
        {
          type = "colors";
          paddingleft = 2;
          symbol = "circle";
        }
      ];
    };
  };
}
