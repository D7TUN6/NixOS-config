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
     
      # Diagnostic and metrics.
      hw-probe
      stress-ng
      smartmontools
      iperf3
      memtester
      mprime
      
      # Firmware.
      linux-firmware

      # Nix.
      appimage-run
      alejandra
      nixfmt-tree
      disko

      # Virtualisation tools.
      qemu
      pcem
      distrobox

      # DPI & VPN
      zapret

      # Graphics.
      krita

      # Development.
      python3
      gcc
      
      # Runtime.
      # jdk21
      javaPackages.compiler.temurin-bin.jre-21

      # Flash & program.
      ventoy-full-gtk

    ];
  };
}
