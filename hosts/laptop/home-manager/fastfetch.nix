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
        {
          type = "initsystem";
          key = "init ";
        }
        {
          type = "break";
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
        {
          type = "break";
        }
        # Motherboard name (if available).
        {
          type = "board";
          key = "board ";
        }
        # BIOS.
        {
          type = "bios";
          key = "bios ";
        }
        # TPM.
        {
          type = "tpm";
          key = "tpm ";
        }
        # Cpu model.
        {
          type = "cpu";
          key = "cpu ";
          temp = true;
        }
        # Gpu model.
        {
          type = "gpu";
          key = "gpu ";
          temp = true;
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
        # Local IP.
        {
          type = "localip";
          key = "local ip ";
          showSpeed = true;
        }
        # Uptime.
        {
          type = "uptime";
          key = "uptime ";
        }
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
