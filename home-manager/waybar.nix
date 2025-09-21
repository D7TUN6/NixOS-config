{
  programs.waybar = {
    # Enable waybar.
    enable = true;
    # Waybar config.
    settings = {
      # Main bar.
      mainBar = {
        # Set position of bar.
        position = "bottom";
        # Set space between modules.
        spacing = 0;
        # Set margins (floating).
        #margin-right = 10;
        margin-left = 10;
        margin-right = 10;
        margin-top = 10;
        margin-bottom = 10;
        # Enable GTK layer shell.
        gtk-layer-shell = true;

        # Modules placement.
        # Left modules.
        modules-left = [
          "custom/menu"
          "hyprland/workspaces"
        ];

        # Center modules.
        modules-center = [
        ];

        # Right modules.
        modules-right = [
          "custom/weather"
          "cpu"
          "memory"
          "tray"
          "hyprland/language"
          "network"
          "pulseaudio"
          "clock"
          "custom/notifications"
        ];

        # Modules Configuration.
        # Hyprland language module.
        "hyprland/language" = {
          format = "{}";
          format-en = "Us";
          format-ru = "Ru";
        };

        # Menu module.
        "custom/menu" = {
          format = " menu";
          on-click = "fuzzel";
        };
        # Power menu module.
        "custom/power" = {
          format = "pomer";
          on-click = "wlogout";
        };

        # Weather module.
        "custom/weather" = {
          format = "{}";
          interval = "300";
          exec = "curl -s 'wttr.in/?format=%c%t' | sed -E 's/\\s*([+-]?[0-9]+)/ \\1/; s/° ?C/°C/'";
          tooltip = "false";
        };

        "network" = {
          format-wifi = "󰤨 {ifname}";
          format-ethernet = "󰈀 {ifname}";
          format-linked = "󰈁 {ifname}";
          format-disconnected = "󰇨 Disconnected.";
        };

        # Notifications module.
        "custom/notifications" = {
          tooltip = "false";
          format = "{icon}";
          format-icons = {
            notification = "󰂜<span foreground='white'><small><sup>⬤</sup></small></span>";
            none = "󰂜";
            dnd-notification = "󱏨<span foreground='white'><small><sup>⬤</sup></small></span>";
            dnd-none = "󱏨";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = "true";
        };

        # Clock module.
        "clock" = {
          format = " {:%H:%M:%S}";
          interval = 1;
          tooltip = false;
          min-height = 5;
          max-height = 5;
        };

        # Workspaces module.
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
          };
          on-click = "activate";
          tooltip = false;
          persistent_workspaces = {
            "*" = 7;
          };
        };

        # Tray module.
        "tray" = {
          "spacing" = "10";
        };

        # Cpu usage module.
        "cpu" = {
          "format" = " {usage}%";
          "tooltip" = "false";
        };

        # RAM usage module.
        "memory" = {
          "format" = " {}%";
        };

        # Sound and volume module.
        "pulseaudio" = {
          format = "󰕾 {volume}%";
          format-muted = "󰝟 {volume}%";
        };
      };
    };

    style = ''
      * {
        font-family: BigBlueTermPlusNerdFont;
        font-size: 12px;
        min-height: 0;
        /*font-weight: bold;*/
      }

      /*@define-color bg #1e1e2e;*/
      /*@define-color main #b4befe;*/


      @define-color main #868195;
      @define-color bg #1C1C24;
      @define-color text #E9E4E4;


      @define-color overlay #868195;
      /*@define-color overlay #292949;*/
      @define-color focused #c6a0f6;

      @define-color bg2 #2b2b4b;
      @define-color fg #a6adc8;
      @define-color pink #f5c2e7;
      @define-color green #a6e3a1;
      @define-color fl #f2cdcd;
      @define-color blue #89b4fa;
      @define-color red #eba0ac;
      @define-color vl #cba6f7;

      window#waybar {
        background: transparent;
      }

      window#waybar > box {
        /*border: 4px solid @main;*/
        background-color: @bg;
      }

      #workspaces,
      #custom-weather,
      #cpu,
      #memory,
      #tray,
      #language,
      #network,
      #pulseaudio,
      #clock,
      #custom-notifications,
      #window {
        padding: 2px;
        margin: 5 2 5 2px;
        color: @text;
        background-color: @overlay;
      }

      #custom-menu {
        padding: 2px;
        margin: 5 2 5 5px;
        color: @text;
        background-color: @overlay;
      }

      #custom-notifications {
        padding: 2 5 2 5px;
        margin: 5 5 5 2px;
        color: @text;
        background-color: @overlay;
      }

      #network {
        padding: 2 5 2 5px;
        margin: 5 2 5 2px;
        color: @text;
        background-color: @overlay;
      }

      #custom-menu:hover {
        color: @focused;
      }

      button {
        border: none;
      }

      button:hover {
        background: inherit;
        box-shadow: inset 0 -3px transparent;
        padding: 2px;
      }

      #workspaces button {
       /* padding: 2 2 2 2px;*/
        padding: 2px;
        background-color: transparent;
        color: @text;
      }

      #workspaces button.active {
        background-color: #696673;
        padding: 2px;
      }

      #workspaces button:hover {
        background-color: #696673;
      }

      #workspaces button.urgent {
        color: @red;
      }

      #pulseaudio.muted {
        color: @red;
      }

      #pulseaudio:hover {
        color: @focused;
      }

      #battery.charging, #battery.plugged {
        color: @focused;
      }

      tooltip {
        background: @bg;
        margin: 20px;
        padding: 15px;
      }
    '';
  };
}
