{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment = {
    variables = {
    };

    systemPackages = with pkgs; [
      # some fhs env for building stuff
      (let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSEnv (base
          // {
            name = "fhs";
            targetPkgs = pkgs:
              (base.targetPkgs pkgs)
              ++ (with pkgs; [
                clang
                gcc
                cargo
              ]);
            profile = "export FHS=1";
            runScript = "bash";
            extraOutputsToInstall = ["dev"];
          }))

      # CLI.
      wget
      unzip
      unrar
      p7zip
      fastfetch
      btop
      stress-ng
      git
      smartmontools
      jq
      killall
      usbutils
      helix

      # CPU.
      linuxPackages.cpupower

      # Base system.
      btrfs-progs
      cryptsetup

      # Base software.
      telegram-desktop
      kdePackages.dolphin
      nwg-look
      vesktop
      strawberry
      firefox
      qbittorrent
      peazip
      keepassxc
      libreoffice
      vlc
      fluidsynth
      schismtracker
      imv
      mpv

      # Gaming.
      osu-lazer-bin
      mangohud

      # Nix.
      appimage-run
      alejandra
      nixfmt-tree

      # Audio production.
      # DAW.
      reaper
      audacity
      # Synth.
      zynaddsubfx
      # Effects.
      lsp-plugins
      calf

      # Compatability, virtulisation, emulation, etc...
      # Wine.
      wineWowPackages.yabridge
      winetricks

      #bottles-unwrapped
      # mono
      # Yabridge.
      yabridgectl
      yabridge

      # Virtualisation tools.
      qemu
      virtualbox
      pcem

      # Recording & streaming
      obs-studio

      # Graphics.
      krita
      gimp
      inkscape

      # Audio tuning.
      pavucontrol
      helvum
      easyeffects

      # Development.
      vscode
      python3

      # Runtime.
      jdk24

      # Flash & program.
      ventoy-full-gtk
      heimdall
      imsprog

      # Desktop.
      wayland-utils
      wl-clipboard
      wf-recorder
      waybar
      swaynotificationcenter
      foot
      kitty
      fuzzel
      yofi
      swaybg
      swaylock
      xwayland-satellite
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    font-awesome
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.bigblue-terminal
  ];
}
