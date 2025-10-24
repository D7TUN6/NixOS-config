{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  pkgsStable,
  pkgsMaster,
  ...
}: {
  environment = {
    sessionVariables = {
      # Graphics optimize.
      __GL_MaxFramesAllowed = "1";
      RADV_PERFTEST = "sam";
      RUSTICL_ENABLE = "radeonsi";
      # Base.
      TERMINAL = "kitty";
      EDITOR = "helix";
      XDG_BIN_HOME = "$HOME/.local/bin";
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
            extraOutputsToInstall = ["my-dev-env"];
          }))

      # CLI.
      wget
      fastfetch
      btop
      git
      jq
      killall
      usbutils
      pciutils
      compsize
      libimobiledevice
      libimobiledevice-glue
      android-file-transfer
      jmtpfs
      go-mtpfs
      usbmuxd
      cryptsetup
      btrfs-progs
      e2fsprogs
      util-linux
      hdparm
      sysstat
      mtools
      gnome.gvfs
      helix
      modprobed-db
      sbctl
      efitools
      kernel-hardening-checker

      # Compression & archives.
      unzip
      unrar
      p7zip
      lrzip
      squashfsTools
      peazip
      
      # Diagnostic and metrics.
      hw-probe
      cpu-x
      hardinfo2
      stress-ng
      smartmontools
      kdiskmark
      
      # Firmware.
      linux-firmware

      # Base software.
      telegram-desktop
      kdePackages.dolphin
      kdePackages.gwenview
      blueman
      overskride
      nwg-look
      vesktop
      strawberry
      firefox
      chromium
      google-chrome
      qutebrowser
      nyxt
      qbittorrent
      keepassxc
      libreoffice-fresh-unwrapped
      vlc
      schismtracker
      imv
      mpv
      cmus
      bleachbit
      btrfs-assistant
      kdePackages.filelight
      gnome-calculator
      gnome-disk-utility
      gparted
      wlr-randr
      kanshi
      way-displays

      # Gaming.
      osu-lazer-bin
      mangohud
      steamcmd
      steam-run

      # Nix.
      appimage-run
      alejandra
      nixfmt-tree

      # Audio production.
      # DAW.
      pkgsMaster.reaper
      # audacity
      # Synth.
      pkgsMaster.zynaddsubfx

      # Compatability, virtulisation, emulation, etc...
      # Wine.
      wineWowPackages.yabridge
      winetricks
      
      # Yabridge.
      yabridgectl
      yabridge

      # Virtualisation tools.
      qemu
      gnome-boxes
      pcem

      # DPI & VPN
      zapret
      amnezia-vpn

      # Recording & streaming
      obs-studio

      # Graphics.
      krita

      # Audio tuning.
      pavucontrol
      helvum
      easyeffects
      jamesdsp

      # Development.
      python3
      gcc
      clang
      cargo
      gnumake
      pkg-config-unwrapped
      
      # Runtime.
      jdk21

      # Flash & program.
      ventoy-full-gtk
      heimdall
      imsprog

      # Desktop.
      lutgen
      lutgen-studio
      pywal
      wayland-utils
      wl-clipboard
      # waybar
      # swaynotificationcenter
      # foot
      # kitty
      # fuzzel
      # swaybg
      # swaylock
      # xwayland-satellite
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.bigblue-terminal
  ];
}
