{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    # Enable the Hyprland.
    enable = true;
    # Enable Xwayland support.
    xwayland.enable = true;
    systemd.enable = true;
    systemd.variables = ["--all"];
    # Configure Hyprland.
    settings = {
      # Define Mod key.
      "$Mod" = "SUPER";

      # Define username.
      "$UserName" = "alex";
      
      # Define dirs.
      "$HomeDir" = "/home/$UserName";
      "$ConfigDir" = "/home/$UserName/.config";
      "$WallpapersDir" = "/home/$UserName/Wallpapers";
      "$ScreenshotsDir" = "/home/$UserName/Images/Screenshots";

      # Define parts of desktop.
      # App launcher.
      "$AppLauncher" = "fuzzel";
      # Bar.
      "$Bar" = "waybar";
      # Wallpaper.
      "$Wallpaper" = "swaybg -i ~/files/walls/wall.jpg";
      # Notification Centre.
      "$NotificationCentre" = "swaync";
      # Desktop init.
      "$DesktopInit" = "mkdir -p $HomeDir/Images $WallpapersDir $ScreenshotsDir";
      # Screenshot commands.
      # Take screenshot of whole screen, copy and save.
      "$ScreenshotScr" = "grimblast copysave screen $ScreenshotsDir/Screenshot-$(date +%s).png";
      # Take screenshot of area, copy and save.
      "$ScreenshotArea" = "grimblast --freeze copysave area $scr/Screen-$(date +%s).png";

      # Default apps.
      # Terminal emulator.
      "$Terminal" = "kitty";
      # File manager.
      "$FileManager" = "nemo";
      # Music player.
      "$MusicPlayer" = "strawberry";

      # Envs for various fixes and params.
      env = [
        # Hyprland stuff.
        "XCURSOR_SIZE,24" # Set the cursor size in Xorg apps in px.
        "HYPRCURSOR_SIZE,24" # Set the Hyprland cursor size in px.
      #  "XDG_CURRENT_DESKTOP,Hyprland" # Set this to fix some apps.
       # "XDG_SESSION_DESKTOP,Hyprland"
       # "XDG_SESSION_TYPE,wayland"

        # QT6 stuff.
 #       "QT_QPA_PLATFORM,wayland"
     #   "QT_QPA_PLATFORMTHEME,qt6ct" # Use QT6 theme.
    #    "QT_AUTO_SCREEN_SCALE_FACTOR,1" # Scaling factor in QT apps.
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1" # Tiling integration, no window bars.

        # Wayland & Pipewire stuff.
#        "GDR_BACKEND,wayland"
#        "SDL_VIDEODRIVER,wayland"
#        "CLUTTER_BACKEND,wayland"
#        "MOZ_ENABLE_WAYLAND,1"
#        "RTC_USE_PIPEWIRE,true"

        # Nvidia stuff.
        #"LIBVA_DRIVER_NAME,nvidia"
        #"GBM_BACKEND,nvidia-drm"
        #"__GLX_VENDOR_LIBRARY_NAME,nvidia"
        #"NVD_BACKEND,direct"
        #"__GLX_VENDOR_LIBRARY_NAME,nvidia"

        # Various apps stuff.
  #      "ELECTRON_OZONE_PLATFORM_HINT,auto"
   #     "MICRO_TRUECOLOR,1"
      ];

      # Monitor configuration.
      monitor = [
        "DVI-I-1,1024x768@106,1920x0,1"
        "HDMI-A-1,1920x1080@74,0x0,1"
      ];
      
      # Autostart.
      # Exec on start.
      exec-once = [
        "$DesktopInit"
        "$Bar"
        "$Wallpaper"
        "$NotificationCentre"
        "dbus-update-activation-environment --systemd --all"
      ];

      # Exec on reload.
      exec = [
        "export GTK_ICON_THEME_NAME='Papirus-Dark'"
      ];

      # Windows layout settings.
      # Dwindle layout.
      dwindle = {
        # Set pseudo tiling.
        pseudotile = true;
        # Set preserver split.
        preserve_split = true;
        # Set smart split.
        smart_split = false;
      };

      # Master layout.
      master = {
        # Status of new window.
        new_status = "master";
        # Set mfact.
        mfact = 0.67;
      };

      # Misc settings.
      misc = {
        # Some optimisations.
        vfr = true;
        # Apply animation when resizing windows manually.
        animate_manual_resizes = true;
        # Toggle default wallpaper.
        force_default_wallpaper = 0;
        # Toggle Hyprland logo.
        disable_hyprland_logo = true;
      };

      # Appearence.
      # General settings.
      general = {
        # Gaps beetween windows.
        gaps_in = 5;
        # Gaps between windows and desktop.
        gaps_out = 10;
        # Size of border, 0 = off.
        border_size = 0;
        # Default layout for new windows.
        layout = "dwindle";
        # Toggle tearing (enable for gaming).
        allow_tearing = true;
        # Colors of active and inactive borders (useless if border_size = 0).
        #"col.active_border" = "rgb(b4befe)";
        #"col.inactive_border" = "rgb(313244)";
      };

      # Decoration settings.
      decoration = {
        # Window corners rounding.
        rounding = 20;
        # Dim inactive windows.
        #dim_inactive = true;
        #active_opacity = 1;
        #inactive_opacity = 0.8;
        # Blur settings.
        blur = {
          enabled = true;
          # Size of blur.
          size = 4;
          # Blur passes.
          passes = 3;
          # Xray.
          xray = false;
          # Blur noise.
          vibrancy = 0.18;
        };
        # Shadow settings.
        shadow = {
          # Disable shadow.
          enabled = false;
        };
      };

      # Animations.
      animations = {
        enabled = true;
        # Custom bezier.
        bezier = "1, 0.23, 1, 0.32, 1";
        # Animanions settings.
        animation = [
          "windows, 	1, 5, 1"
          "windowsIn, 	1, 5, 1, slide"
          "windowsOut,	1, 5, 1, slide"
          "border, 	1, 5, 	 default"
          "borderangle, 1, 5, 	 default"
          "fade, 	1, 5, 	 default"
          "workspaces,  1, 5, 1, slidefade 30%"
        ];
      };

      # Input settings.
      input = {
        # Keyboard layout.
        kb_layout = "us,ru";
        # Hotkeys for changing keymap.
        kb_options = "grp:alt_shift_toggle";
        # Follow mouse.
        follow_mouse = 1;
        # Force disable acceleration.
        force_no_accel = true;
        # Mouse sensitivity.
        sensitivity = 0;
        # Touchpad settings.
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };

      # Key bindings.
      bind = [
        # Windows.
        # Base.
        "$Mod SHIFT, C, killactive"
        "$Mod, V, togglefloating"
        "$Mod, F, fullscreen"
        "$Mod SHIFT, Q, exit"
        "$Mod, P, exec, hyprpicker | wl-copy"

        # Move focus.
        "$Mod, left, movefocus, l"
        "$Mod, right, movefocus, r"
        "$Mod, up, movefocus, u"
        "$Mod, down, movefocus, d"

        # Workspaces.
        # Switch to workspace.
        "$Mod, 1, workspace, 1"
        "$Mod, 2, workspace, 2"
        "$Mod, 3, workspace, 3"
        "$Mod, 4, workspace, 4"
        "$Mod, 5, workspace, 5"
        "$Mod, 6, workspace, 6"
        "$Mod, 7, workspace, 7"
        "$Mod, 8, workspace, 8"
        "$Mod, 9, workspace, 9"
        "$Mod, 0, workspace, 10"

        # Move active window to workspace.
        "$Mod SHIFT, 1, movetoworkspace, 1"
        "$Mod SHIFT, 2, movetoworkspace, 2"
        "$Mod SHIFT, 3, movetoworkspace, 3"
        "$Mod SHIFT, 4, movetoworkspace, 4"
        "$Mod SHIFT, 5, movetoworkspace, 5"
        "$Mod SHIFT, 6, movetoworkspace, 6"
        "$Mod SHIFT, 7, movetoworkspace, 7"
        "$Mod SHIFT, 8, movetoworkspace, 8"
        "$Mod SHIFT, 9, movetoworkspace, 9"
        "$Mod SHIFT, 0, movetoworkspace, 10"

        # Scroll through workspaces.
        "$Mod, mouse_down, workspace, e+1"
        "$Mod, mouse_up, workspace, e-1"

        # Launch apps.
        # Terminal emulator.
        "$Mod SHIFT, return, exec, $Terminal"
        # File manager.
        "$Mod, E, exec, $FileManager"
        # Volume control.
        "$Mod, V, exec, pkill $VolumeControl || $VolumeControl"
        # Task manager.
        " , CTRL ALT DEL, exec, pkill $TaskManager || $TaskManager"
        # App launcher.
        "$Mod, R, exec, pkill $AppLauncher || $AppLauncher"

        # Open notification centre.
        "$Mod, R, exec, pkill $NotificationCentre || $NotificationCentre"

        # Wallpaper.
        # Restart.
        "$Mod, U, exec, pkill $Wallpaper || $Wallpaper"

        # Lockscreen.
        # Lock screen.
        "$Mod, L, exec, $LockScreen"

        # Screenshot.
        # Take screenshot of whole screen, copy to clipboard and save.
        ", Print, exec, $ScreenshotScr"
        # Take screenshot of area? copy to clipboard and save.
        "SHIFT, Print, exec, $ScreenshotArea"
        # Audio control.
        # Volume up/down using media keys and Mod + F3/F2.
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        "$Mod, F3, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        "$Mod, F2, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        # Mute volume using media keys and Mod + F1.
        "$Mod, F1, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"

        # Lock laptop on lid close.
        ", switch:on:Lid Switch, exec, hyprlock"

        # Move floating windows, 40px step.
        "$Mod SHIFT, right, moveactive, 40 0"
        "$Mod SHIFT, left, moveactive, -40 0"
        "$Mod SHIFT, up, moveactive, 0 -40"
        "$Mod SHIFT, down, moveactive, 0 40"

        # Move floating windows, 10px step.
        "$Mod ALT SHIFT, right, moveactive, 10 0"
        "$Mod ALT SHIFT, left, moveactive, -10 0"
        "$Mod ALT SHIFT, up, moveactive, 0 -10"
        "$Mod ALT SHIFT, down, moveactive, 0 10"

        # Move windows to a screen edge.
        "$Mod ALT, Left, movewindow, l"
        "$Mod ALT, Right, movewindow, r"
        "$Mod ALT, Up, movewindow, u"
        "$Mod ALT, Down, movewindow, d"

        # Resize windows, 40px step.
        "$Mod CTRL, left, resizeactive,-40 0"
        "$Mod CTRL, right, resizeactive,40 0"
        "$Mod CTRL, up, resizeactive,0 -40"
        "$Mod CTRL, down, resizeactive,0 40"

        # Resize windows, 10px step.
        "$Mod ALT CTRL, left, resizeactive,-10 0"
        "$Mod ALT CTRL, right, resizeactive,10 0"
        "$Mod ALT CTRL, up, resizeactive,0 -10"
        "$Mod ALT CTRL, down, resizeactive,0 10"
        # Hide bar.
        "$Mod, D, exec, pkill -SIGUSR1 $Bar"

        # Restart Bar.
        "$Mod ALT, D, exec, pkill $Bar && $Bar"
      ];

      bindm = [
        # Move/resize windows with mouse/touchpad.
        "$Mod, mouse:272, movewindow"
        "$Mod, mouse:273, resizewindow"
      ];
    };
  };
}
