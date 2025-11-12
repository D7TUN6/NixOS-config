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

      # Network
      traceroute
      tcpdump
      iftop
      nmap
      whois
      dig
           
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
      
      # Firmware.
      linux-firmware

      # Base software.
      telegram-desktop
      firefox
      mupdf
      qbittorrent
      keepassxc
      libreoffice
      vlc
      bleachbit
      gnome-calculator
       
      # Nix.
      appimage-run
      alejandra
      nixfmt-tree
      disko
     
      # Compatability, virtulisation, emulation, etc...
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
      pywal
    ];
  };
}
