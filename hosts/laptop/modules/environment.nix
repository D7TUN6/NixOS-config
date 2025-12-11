{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  environment = {
    sessionVariables = {
      __GL_MaxFramesAllowed = 1;
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
      __GL_THREADED_OPTIMIZATIONS = 1;
      RUSTICL_ENABLE = "radeonsi";
      RADV_PERFTEST = "sam";
      mesa_glthread = "true";
      __GL_YIELD = "NOTHING";
      
      
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
        (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
    exec qemu-system-x86_64 \
      -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
      "$@"
      '')

      # CLI.
      lsd
      curl
      wget
      fastfetch
      btop
      htop
      jq
      efibootmgr
      efivar
      parted
      gptfdisk
      ddrescue
      ccrypt
      cryptsetup
      git
      killall
      usbutils
      pciutils
      util-linux
      hdparm
      helix
      tree
      ncdu
      w3m
      tty-clock
      kernel-hardening-checker
      sbctl
      tpm2-tools
      tpm2-tss
      powertop
      rt-tests
      tuna
      lshw

      # lib.
      glib
      gsettings-desktop-schemas
      libsForQt5.qt5.qtwayland
      kdePackages.qtwayland

      # Network
      traceroute
      tcpdump
      iftop
      nmap
      whois
      dig
      fuse
      fuse3
      sshfs-fuse
      socat
      screen
      # net-tools
      iftop
      iproute2
      nethogs

      # Apple
      libimobiledevice
      ideviceinstaller
      bsdiff
            
      # Compression & archives.
      unzip
      # unrar
      p7zip
      lrzip
      
      # Diagnostic and metrics.
      hw-probe
      stress-ng
      smartmontools
      iperf3
      memtester
      mprime
      sdparm
      nvme-cli
      ms-sys
      mission-center
      lm_sensors
      xsensors
      
      # Firmware.
      linux-firmware

      # Base software.
      telegram-desktop
      overskride
      strawberry
      firefox
      brave
      google-chrome
      zathura
      mupdf
      tor-browser
      qbittorrent
      keepassxc
      libreoffice
      onlyoffice-desktopeditors
      kdePackages.dolphin
      kdePackages.gwenview
      kdePackages.okular
      vlc
      schismtracker
      imv
      mpv
      bleachbit
      gnome-calculator
      cheese
      gnome-sound-recorder
      gparted
      gnome-disk-utility
      gnome-text-editor
      wlr-randr
      
      # Nix.
      appimage-run
      alejandra
      nixfmt-tree
      disko
      
      # Compatability, virtulisation, emulation, etc...
      # Wine.
      # wineWow64Packages.yabridge
      wineWow64Packages.waylandFull
      winetricks
      
      # Virtualisation tools.
      qemu
      pcem
      distrobox

      # DPI & VPN
      zapret

      # Recording & streaming
      obs-studio

      # Graphics.
      krita

      # Audio tuning.
      pavucontrol
      helvum
      easyeffects

      # Development.
      python3
      gcc
      
      # Runtime.
      # jdk21
      javaPackages.compiler.temurin-bin.jre-21

      # Flash & program.
      # ventoy-full-gtk
      heimdall
      imsprog

      # Desktop.
      xorg.xinit
      cool-retro-term
      xorg.xkill
      wayland-utils
      wl-clipboard
      waybar
      swaynotificationcenter
      foot
      kitty
      fuzzel
      swaybg
      swaylock
      xwayland-satellite
      pywal
      swayimg
    ];
  };
}
