{...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "auto";
        source = "/home/d7tun6/.config/fastfetch/nixos-small.txt";
        color = {
          "1" = "#4d6fb7";
          "2" = "#77b6e1";
        };
        padding = {
          top = 1;
          left = 2;
        };
      };
      modules = [
        {
          type = "os";
          key = "os ";
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
          type = "uptime";
          key = "uptime ";
        }
        {
          type = "shell";
          key = "shell ";
        }
        {
          type = "wm";
          key = "wm ";
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
          type = "break";
        }
        {
          type = "cpu";
          key = "cpu ";
          format = "{1} ({3}C/{4}T) @ {6}";
        }
        {
          type = "gpu";
          key = "gpu ";
          format = "{2} ({3})";
        }
        {
          type = "memory";
          key = "ram ";
        }
        {
          type = "disk";
          key = "disk ";
        }
        {
          type = "display";
          key = "disp ";
        }
        {
          type = "localip";
          key = "lan ";
          showspeed = true;
        }
        {
          type = "command";
          key = "installed ";
          text = "birth=$(btrfs subvolume show / 2>/dev/null | awk '/Creation time:/ {print $3, $4}'); if [ -n \"$birth\" ]; then echo $(( ($(date +%s) - $(date -d \"$birth\" +%s)) / 86400 )); else echo $(( ($(date +%s) - $(stat -c %W / 2>/dev/null || stat -c %Z /)) / 86400 )); fi";
          format = "{1} days ago";
        }
        {
          type = "colors";
          paddingleft = 1;
          symbol = "circle";
        }
      ];
    };
  };
  home.file.".config/fastfetch/nixos-small.txt".text = ''
    $1      __  $2__  __
    $1    __\ \_$2\ \/ /
    $1   /_______$2\  / 
    $2  ___/ /    $2\ \$1/\
    $2 /__  /      $2\$1/ /__
    $2   / /$1\      $1/ ___/
    $2   \/$1\ \$2____$1/$2_$1/$2__
    $1     /\ \$2___  __/
    $1    /_/\_\  $2\_\
  '';
}