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
        # Hardware Information column.
        {
          type = "custom";
          format = "┏━━━━━━━━━━━━━ Hardware Information ━━━━━━━━━━━━━┓";
        }
        # Motherboard name (if available).
        {
          type = "host";
          key = "   ";
        }
        # Cpu model.
        {
          type = "cpu";
          key = "   ";
        }
        # Gpu model.
        {
          type = "gpu";
          key = "   ";
        }
        # Disks, mounts and space.
        {
          type = "disk";
          key = "   ";
        }
        # Ram amount and usage.
        {
          type = "memory";
          key = "   ";
        }
        # Displays information.
        {
          type = "display";
          key = "  󰍹 ";
        }
        # Software information column
        {
          type = "custom";
          format = "┣━━━━━━━━━━━━━ Software Information ━━━━━━━━━━━━━┫";
        }
        # Username and hostname.
        {
          type = "title";
          key = "   ";
          format = "{1}@{2}";
        }
        # Distro name.
        {
          type = "os";
          key = "   ";
        }
        # Kernel version.
        {
          type = "kernel";
          key = "   ";
          format = "{1} {2}";
        }
        # Amount of packages.
        {
          type = "packages";
          key = "  󰏖 ";
        }
        # Desktop environment.
        {
          type = "de";
          key = "   ";
        }
        # Window manager.
        {
          type = "wm";
          key = "   ";
        }
        # Shell name.
        {
          type = "shell";
          key = "   ";
        }
        # Terminal name.
        {
          type = "terminal";
          key = "   ";
        }
        # Terminal font name.
        {
          type = "terminalfont";
          key = "   ";
        }
        # Theme name.
        {
          type = "theme";
          key = "  󰉼 ";
        }
        # Icon theme name.
        {
          type = "icons";
          key = "  󰀻 ";
        }
        # End column.
        {
          type = "custom";
          format = "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛";
        }
        # Colors module.
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
