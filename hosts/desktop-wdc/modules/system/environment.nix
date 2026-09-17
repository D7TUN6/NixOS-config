{
  pkgs,
  lib,
  ...
}: let
  makePluginPath = format:
    (lib.makeSearchPath format [
      "$HOME/.nix-profile/lib"
      "/run/current-system/sw/lib"
      "/etc/profiles/per-user/$USER/lib"
    ])
    + ":$HOME/.${format}";
in {
  environment = {
    variables = {
      CLAP_PLUGIN_PATH = makePluginPath "clap";
      DSSI_PATH = makePluginPath "dssi";
      LADSPA_PATH = makePluginPath "ladspa";
      LV2_PATH = makePluginPath "lv2";
      LXVST_PATH = makePluginPath "lxvst";
      VST_PATH = makePluginPath "vst";
      VST3_PATH = makePluginPath "vst3";
    };

    sessionVariables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      # Niri.
      "XCURSOR_SIZE" = 24;
      "XDG_CURRENT_DESKTOP" = "niri";
      "XDG_SESSION_DESKTOP" = "niri-session";
      "XDG_SESSION_TYPE" = "wayland";

      "QT_QPA_PLATFORM" = "wayland";
      "QT_QPA_PLATFORMTHEME" = "qt6ct";
      "QT_AUTO_SCREEN_SCALE_FACTOR" = 1;
      "QT_WAYLAND_DISABLE_WINDOWDECORATION" = 1;

      "GDR_BACKEND" = "wayland";
      "SDL_VIDEODRIVER" = "wayland";
      "CLUTTER_BACKEND" = "wayland";
      "MOZ_ENABLE_WAYLAND" = 1;
      "RTC_USE_PIPEWIRE" = "true";

      "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
      "MICRO_TRUECOLOR" = 1;
      NH_FLAKE = "/home/d7tun6/files/system";

      # AMD GPU gaming
      RADV_PERFTEST = "aco";
      mesa_glthread = "true";
      DXVK_HDR = "1";
      GAMESCOPE_LIMITER = "1";
      MANGOHUD = "1";
    };

    shellAliases = {
      ff = "fastfetch";
      nrs = "nh os switch";
      hms = "nh home switch";
      nfu = "nix flake update --commit-lock-file --flake /home/d7tun6/files/system/.";
      nm = "nix flake update --commit-lock-file --flake /home/d7tun6/files/system/. && nh os switch && sudo nix-collect-garbage -d";
      nsr = "sudo nix-store --verify --check-contents --repair";
    };

    systemPackages = with pkgs; [
      (let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSEnv (base
          // {
            name = "fhs";
            targetPkgs = pkgs:
              (base.targetPkgs pkgs)
              ++ (with pkgs; [
                ]);
            profile = "export FHS=1";
            runScript = "fish";
          }))
      (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
        exec qemu-system-x86_64 \
          -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
          "$@"
      '')

      # bench & test
      mprime
      stress-ng

      # monitor stuff
      ddcutil
      i2c-tools

      # audio core & tools
      pipewire
      pipewire.jack
      pulseaudio
      jack_capture
      pavucontrol
      crosspipe
      sox
      spek

      # cd ripping & lossless tools
      cdparanoia
      cuetools
      cdrtools
      cdrdao

      # tracking & production
      schismtracker
      reaper
      musescore
      kid3
      kdePackages.kdenlive
      shotcut
      krita

      # synths & FX
      zynaddsubfx
      cardinal
      surge-xt
      odin2
      dexed
      lsp-plugins
      x42-plugins
      calf
      easyeffects

      # wine & translation layer
      wineWow64Packages.stable
      winetricks
      yabridgectl
      yabridge

      # system base & cli
      wget
      aria2
      fastfetch
      btop
      gitMinimal
      onefetch
      killall
      usbutils
      pciutils
      util-linux
      hdparm
      helix
      # vscode
      tree
      ncdu
      ffmpeg
      mesa-demos
      lm_sensors
      ethtool
      bc

      # nix tools
      alejandra
      nixfmt-tree
      disko
      appimage-run
      nix-output-monitor
      nh

      # security & hw-modding
      # sbctl
      # tpm2-tools
      # tpm2-tss
      # tpm2-abrmd
      gphoto2
      libgphoto2
      gphoto2fs
      imsprog
      smartmontools
      hw-probe

      # network & deploy
      zapret
      tailscale
      nmap
      socat
      tcpdump
      iproute2
      nethogs
      doggo
      curlie
      termshark
      mtr
      iperf3
      grepcidr
      bind
      webtunnel

      # environment utils
      unzip
      p7zip
      lrzip
      zpaq

      # desktop apps & wayland spec
      telegram-desktop
      ayugram-desktop
      vesktop
      chromium
      luakit
      epiphany
      qutebrowser
      nyxt
      vimb-unwrapped
      qbittorrent
      keepassxc
      nautilus
      imv
      mpv
      vlc
      strawberry
      wlr-randr
      wayland-utils
      wl-clipboard
      cliphist
      hyprpicker
      waybar
      swaynotificationcenter
      foot
      fuzzel
      swaybg
      grim
      slurp
      grimblast
      xwayland-satellite
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.bigblue-terminal
  ];
}
