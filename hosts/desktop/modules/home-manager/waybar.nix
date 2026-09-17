{...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        spacing = 0;
        gtk-layer-shell = true;
        modules-left = [
          "custom/menu"
          "niri/workspaces"
        ];

        modules-center = [];

        modules-right = [
          "custom/cpu-temp"
          "custom/gpu-temp"
          "custom/mb-temp"
          "custom/weather"
          "cpu"
          "memory"
          "tray"
          "niri/language"
          "network"
          "pulseaudio"
          "clock"
          "custom/notifications"
        ];

        "niri/language" = {
          format = "{}";
          format-en = "us";
          format-ru = "ru";
        };

        "custom/menu" = {
          format = " menu";
          on-click = "/home/d7tun6/files/system/hosts/desktop/smth/scripts/menu/menu.sh";
        };

        "custom/cpu-temp" = {
          format = "cpu {}°C";
          exec = "sensors | awk -F'[:°]' '/Tctl/ {gsub(/ /, \"\", $2); print $2}'";
          interval = 5;
          tooltip = false;
        };

        "custom/gpu-temp" = {
          format = "gpu {}°C";
          exec = "sensors | awk -F'[:°]' '/edge/ {gsub(/ /, \"\", $2); print $2}'";
          interval = 5;
          tooltip = false;
        };

        "custom/mb-temp" = {
          format = "mb {}°C";
          exec = "sensors | awk -F'[:°]' '/SYSTIN/ {gsub(/ /, \"\", $2); print $2}'";
          interval = 5;
          tooltip = false;
        };

        "custom/weather" = {
          format = "{}";
          interval = 1800;
          exec = "curl -s 'wttr.in/?format=%c%t' | sed -E 's/\\s*([+-]?[0-9]+)/ \\1/; s/° ?C/°C/'";
          tooltip = "false";
        };

        "network" = {
          format-wifi = "󰤨 wifi";
          format-ethernet = "󰈀 eth";
          format-linked = "󰈁 link";
          format-disconnected = "󰇨 no";
        };

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

        "clock" = {
          format = " {:%H:%M:%S}";
          interval = 1;
          min-height = 5;
          max-height = 5;
          tooltip = true;
          tooltip-format = "<big>{:%d/%m/%Y}</big>\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            on-scroll = 1;
            format = {
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {};
          on-click = "activate";
          tooltip = false;
        };

        "tray" = {
          spacing = "10";
          icon-size = "1";
        };

        "cpu" = {
          interval = 5;
          format = " {usage}%";
          tooltip = "false";
        };

        "memory" = {
          interval = 5;
          format = " {}%";
        };

        "pulseaudio" = {
          format = "󰕾 {volume}%";
          format-muted = "󰝟 {volume}%";
          on-click = "/home/d7tun6/files/system/hosts/desktop/smth/scripts/menu/sound.sh";
          on-click-middle = "pamixer -t";
          scroll-step = 1;
        };
      };
    };

    style = ''
      /* --- Colors --- */
      @define-color main #8382B7;
      @define-color bg #1A1F25;
      @define-color text #ECEAFA;
      @define-color overlay #6C6B8F;
      @define-color focused #B1B0CE;
      @define-color bg2 #2A313A;
      @define-color fg #6C6B8F;
      @define-color pink #CDA3E6;
      @define-color green #ABB8BA;
      @define-color fl #f2cdcd;
      @define-color blue #7F7FB3;
      @define-color red #B17280;
      @define-color vl #cba6f7;

      /* --- Params for all modules --- */
      * {
        font-family: BigBlueTermPlusNerdFont;
        font-size: 9px;
        min-height: 0;
      }

      /* --- Main Modules --- */
      #workspaces, #custom-weather, #cpu,
      #memory, #tray, #language, #network,
      #pulseaudio, #clock, #custom-notifications,
      #custom-cpu-temp, #custom-gpu-temp, #custom-mb-temp,
      #window {
        padding: 2px;
        margin: 5 2 5 2px;
        color: @text;
        font-family: BigBlueTermPlusNerdFont;
        background-color: @overlay;
      }

      /* --- Waybar itself --- */
      window#waybar {
        background: transparent;
      }
      window#waybar > box {
        background-color: @bg;
      }

      /* --- Padding/margin fixes lmao (average nerd icons enjoyer) --- */
      #custom-menu {
        padding: 2px;
        margin: 5 2 5 5px;
        color: @text;
        background-color: @overlay;
      }
      #custom-notifications, #network {
        padding: 2 5 2 5px;
        margin: 5 2 5 2px;
        color: @text;
        background-color: @overlay;
      }

      /* --- Tooltip ---*/
      tooltip label {
        color: @text;
        padding: 8px;
      }
      tooltip {
        background: @bg;
        margin: 20px;
        padding: 15px;
      }

      /* --- Buttons --- */
      #button {
        border: none;
      }
      #workspaces button {
        padding: 2px;
        background-color: transparent;
        color: @text;
      }

      /* --- Hovers --- */
      #battery.charging, #battery.plugged,
      #pulseaudio:hover,
      #workspaces button:hover, #workspaces button.active,
      #custom-menu:hover,
      #button:hover {
        background: inherit;
        box-shadow: inset 0 -3px transparent;
        padding: 2px;
      }

      /* --- Urgent --- */
      #workspaces button.urgent,
      #pulseaudio.muted {
        color: @red;
      }
    '';
  };
}
