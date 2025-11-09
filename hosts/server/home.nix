{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Apps.
    ./home-manager/apps/helix.nix
    ./home-manager/apps/btop.nix
    ./home-manager/apps/fastfetch.nix

    # System.
    ./home-manager/system/fish.nix
  ];

  home = {
    # Username of the user.
    username = "d7tun6";

    # Home directory of the user.
    homeDirectory = "/home/d7tun6";

    # Home-manager version.
    stateVersion = "25.05";

    # User packages.
    packages = with pkgs; [
      # Home-manager itself (for management).
      inputs.home-manager.packages.${pkgs.system}.default
    ];
  };

  # Let Home-manager enable himself.
  programs.home-manager = {
    enable = true;
  };
}
