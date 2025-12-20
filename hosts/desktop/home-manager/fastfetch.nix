{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.fastfetch = {
    # Enable fastfetch.
    enable = true;
    # Fastfetch settings.
    settings = {
      # Modules settings.
      modules = [
        # Username and hostname.
        {
          type = "title";
          key = "   ";
          format = "{1}@{2}";
        }
        # Distro name.
        {
          type = "os";
          key = "distro ";
        }
        # Kernel version.
        {
          type = "kernel";
          key = "kernel ";
          format = "{1} {2}";
        }
        # Amount of packages.
        {
          type = "packages";
          key = "packages ";
        }
        # Desktop environment.
        {
          type = "de";
          key = "de ";
        }
        # Window manager.
        {
          type = "wm";
          key = "wm ";
        }
        # Shell name.
        {
          type = "shell";
          key = "sh ";
        }
        # Terminal name.
        {
          type = "terminal";
          key = "term ";
        }
        # Terminal font name.
        {
          type = "terminalfont";
          key = "font ";
        }
        # Theme name.
        {
          type = "theme";
          key = "theme ";
        }
        # Icon theme name.
        {
          type = "icons";
          key = "icons ";
        }
        # Motherboard name (if available).
        {
          type = "host";
          key = "host ";
        }
        # Cpu model.
        {
          type = "cpu";
          key = "cpu ";
        }
        # Gpu model.
        {
          type = "gpu";
          key = "gpu ";
        }
        # Disks, mounts and space.
        {
          type = "disk";
          key = "disk ";
        }
        # Ram amount and usage.
        {
          type = "memory";
          key = "ram ";
        }
        # Displays information.
        {
          type = "display";
          key = "disp ";
        }
        {
          type = "uptime";
          key = "uptime ";
        }
        # Software information column
        {
          type = "colors";
          paddingLeft = 2;
          # Use circles.
          symbol = "circle";
        }
      ];
    };
  };
}
