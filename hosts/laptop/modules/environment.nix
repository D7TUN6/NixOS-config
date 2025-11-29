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
      mesa_glthread = "true";
      __GL_YIELD = "USLEEP";
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
      sbctl
      tpm2-tools
      tpm2-tss

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

      # Apple
      libimobiledevice
      ideviceinstaller
      bsdiff
            
      # Compression & archives.
      unzip
      unrar
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
      qbittorrent
      keepassxc
      libreoffice
      onlyoffice-desktopeditors
      vlc
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
     
      # Wine.
      wineWowPackages.yabridge
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
      ventoy-full-gtk
      heimdall
      imsprog

      # Desktop.
      xorg.xinit
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
