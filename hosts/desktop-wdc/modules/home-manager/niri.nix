{...}: {
  home.file.".config/niri/config.kdl" = {
    text = ''
      // --- Input ---
      input {
          keyboard {
              xkb {
                  layout "us,ru"
                  options "grp:caps_toggle"
              }
              numlock
          }
          touchpad {
              tap
              natural-scroll
              scroll-method "two-finger"
          }
          mouse {
              accel-speed -0.5
              accel-profile "flat"
          }
          trackpoint {
              off
          }
          warp-mouse-to-focus
          focus-follows-mouse max-scroll-amount="0%"
      }

      // --- outputs ---
      output "VGA-1" {
          //mode custom=true "1440x1080@75"
          //mode custom=true "1280x960@86"
          //mode custom=true "1152x864@86"
          //mode custom=true"1440x900@85"
          //mode custom=true "1024x768@106"
          //mode custom=true "640x480@162"
          //mode custom=true "800x600@132"

          mode custom=true "1280x960@86"

          transform "normal"
          position x=0 y=0
          scale 1
          focus-at-startup
      }
      output "DVI-D-2" {
          //mode custom=true "1920x1080@60"
          transform "normal"
          position x=0 y=0
          scale 1
      }
      output "DP-1" {
          mode custom=true "1920x1080@60"
          // mode custom=true "1440x1080@"
          position x=0 y=0
          scale 1
          // transform "270"
      }
      output "DVI-D-1" {
          mode "1920x1080@60"
          transform "270"
          variable-refresh-rate
      }

      debug {
           disable-cursor-plane
      }


      // --- Layout & Appearance ---
      layout {
          gaps 8 // was 17 in past
          center-focused-column "never"
          // preset-column-widths {
          //  proportion 0.33333
          //    proportion 0.5
          //    proportion 0.66667
          //}
          default-column-width { proportion 0.5; }

          focus-ring {
              width 4
              active-color "#7f7fb3"
              inactive-color "#A6A1B0"
          }

          border {
              off
              width 4
          }

          shadow {
              off
              softness 30
              spread 5
              offset x=0 y=5
              color "#0007"
          }
      }

      environment {
          "WLR_DRM_NO_MODIFIERS" "1"
          "MOZ_ENABLE_WAYLAND" "1"
          "NIXOS_OZONE_AUTOPRIVAL_WAYLAND" "1"
      }


      // --- Startup services ---
      spawn-sh-at-startup "waybar"
      spawn-sh-at-startup "swaync"
      spawn-at-startup "sh" "-c" "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE"
      spawn-sh-at-startup "systemctl start --user polkit-gnome-authentication-agent-1"
      spawn-sh-at-startup "swaybg -o DP-1 -i /home/d7tun6/files/wallpaper/wall-dp.jpg -m fill -o VGA-1 -i /home/d7tun6/files/wallpaper/wall-vga.jpg -m fill"
      // spawn-sh-at-startup "easyeffects --gapplication-service"
      // spawn-sh-at-startup "wl-paste --type text --watch cliphist store"
      // spawn-sh-at-startup "wl-paste --type image --watch cliphist store"
      // --- Autostart ---
      // spawn-at-startup "AyuGram" "-startintray"
      // spawn-at-startup "Telegram" "-startintray"
      // spawn-at-startup "Throne" "-tray"


      // --- General settings ---
      prefer-no-csd
      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      animations {
          off
          workspace-switch {
              curve "cubic-bezier" 0.05 0.9 0.1 1
              duration-ms 300
          }
          window-open {
              curve "cubic-bezier" 0.06 1.2 0.25 1
              duration-ms 350
          }
          window-close {
              curve "cubic-bezier" 0.17 0.69 0.01 0.74
              duration-ms 500
          }
          horizontal-view-movement {
              curve "cubic-bezier" 0.05 0.9 0.1 1
              duration-ms 500
          }
      }

      // --- Window rules ---
      // Maximized apps
      window-rule {
          match app-id="foot"
          match app-id="firefox"
          match app-id="com.ayugram.desktop"
          match app-id="org.telegram.desktop"
          match app-id="Throne"
          match app-id="code"
          match app-id="org.gnome.Nautilus"
          match app-id="REAPER"
          match app-id="Renoise"
          match app-id="Krita"
          match app-id="chromium-browser"
          match app-id="com.obsproject.Studio"
          match app-id="org.strawberrymusicplayer.strawberry"
          match app-id="obsidian"
          match app-id="blender"
          match app-id="libreoffice-startcenter"
          match app-id="schismtracker"
          match app-id="org.coolercontrol.CoolerControl"
          open-maximized true
      }

      // Floating rules
      window-rule {
          match app-id="org.gnome.Calculator"
          match app-id=r#"firefox$"# title="^Picture-in-Picture$"
          match app-id="foot-floating"
          open-floating true
      }

      // Privacy Rules
      window-rule {
          match app-id=r#"^org\.keepassxc\.KeePassXC$"#
          match app-id=r#"^org\.gnome\.World\.Secrets$"#
          block-out-from "screen-capture"
      }

      // Fancy shit
      window-rule {
          // geometry-corner-radius 19
          clip-to-geometry true
      }

      // --- Binds ---
      binds {
          // System & UI
          Mod+Shift+Slash { show-hotkey-overlay; }
          Mod+Shift+Return { spawn "foot"; }
          Mod+D { spawn "fuzzel"; }
          Super+L { spawn "swaylock"; }
          Mod+O { toggle-overview; }
          Mod+Shift+C { close-window; }
          Mod+Shift+Q { quit; }
          Ctrl+Alt+Delete { quit; }
          Mod+Shift+P { power-off-monitors; }
          Mod+X { spawn "systemctl" "suspend"; }

          // Audio & brightness
          XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
          XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
          XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

          // Navigation
          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }
          Mod+Right { focus-column-right; }
          Mod+Shift+Left  { focus-monitor-left; }
          Mod+Shift+Down  { focus-monitor-down; }
          Mod+Shift+Up    { focus-monitor-up; }
          Mod+Shift+Right { focus-monitor-right; }

          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Down  { move-window-down; }
          Mod+Ctrl+Up    { move-window-up; }
          Mod+Ctrl+Right { move-column-right; }

          Mod+Home { focus-column-first; }
          Mod+End  { focus-column-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End  { move-column-to-last; }

          // Workspaces
          Mod+Page_Down { focus-workspace-down; }
          Mod+Page_Up   { focus-workspace-up; }
          Mod+U         { focus-workspace-down; }
          Mod+I         { focus-workspace-up; }

          Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
          Mod+Ctrl+U         { move-column-to-workspace-down; }
          Mod+Ctrl+I         { move-column-to-workspace-up; }

          // Workspace shortcuts
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }

          // Column & window management
          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }
          Mod+Comma        { consume-window-into-column; }
          Mod+Period       { expel-window-from-column; }
          Mod+R            { switch-preset-column-width; }
          Mod+F            { maximize-column; }
          Mod+Shift+F      { fullscreen-window; }
          Mod+C            { center-column; }
          Mod+Minus        { set-column-width "-10%"; }
          Mod+Equal        { set-column-width "+10%"; }
          Mod+V            { toggle-window-floating; }
          Mod+W            { toggle-column-tabbed-display; }

          // Screenshots
          Print      { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print  { screenshot-window; }

          // --- Custom Binds ---
          Mod+Alt+I { spawn "foot" "ff"; }

          // NixOS & Home-Manager Rebuilds
          Mod+Shift+S { spawn "foot" "--app-id" "foot-floating" "sh" "-c" "run0 nixos-rebuild switch --flake /home/d7tun6/files/system#desktop-wdc || read -p 'Error! Press enter...'"; }
          Mod+Shift+H { spawn "foot" "--app-id" "foot-floating" "sh" "-c" "home-manager switch --flake /home/d7tun6/files/system#desktop-wdc || read -p 'Error! Press enter...'"; }
          Mod+Shift+M { spawn "foot" "--app-id" "foot-floating" "sh" "-c" "nix flake update --commit-lock-file --flake /home/d7tun6/files/system/. && run0 nixos-rebuild switch --flake /home/d7tun6/files/system#desktop-wdc && run0 nix-collect-garbage -d || read -p 'Error! Press enter...'"; }
          Mod+Shift+Y { spawn "foot" "--app-id" "foot-floating" "sh" "-c" "run0 nix-store --verify --check-contents --repair || read -p 'Error! Press enter...'"; }

          // --- Application binds ---
          Mod+B { spawn "firefox"; }
          Mod+E { spawn "nautilus"; }
          Mod+T { spawn "Telegram"; }
          Mod+Alt+T { spawn "Ayugram"; }
          Mod+Alt+H { spawn "throne"; }
          Mod+N { spawn "obsidian"; }
          Mod+Shift+N { spawn "vscode"; }

          // Music production
          Mod+Alt+R { spawn "reaper"; }
          Mod+Alt+N { spawn "renoise"; }
          Mod+Alt+S { spawn "schismtracker"; }
          Mod+Alt+A { spawn "audacity"; }

          // Graphics & video
          Mod+Alt+K { spawn "krita"; }
          Mod+Alt+V { spawn "kdenlive"; }
          Mod+Alt+B { spawn "blender"; }
          Mod+Alt+O { spawn "obs"; }

          // Utilities & media
          Mod+Alt+P { spawn "pavucontrol"; }
          Mod+Alt+Equal { spawn "gnome-calculator"; }
          Mod+Alt+C { spawn "coolercontrol"; }
          Mod+Alt+M { spawn "mpv"; }
          Mod+Alt+L { spawn "vlc"; }
          Mod+Alt+G { spawn "libreoffice"; }
          Mod+Shift+G { spawn "steam"; }
      }
    '';
  };
}
