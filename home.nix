{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Desktop.
    ./home-manager/desktop/niri.nix
    ./home-manager/desktop/waybar.nix
    ./home-manager/desktop/foot.nix
    ./home-manager/desktop/kitty.nix
    ./home-manager/desktop/fuzzel.nix
    ./home-manager/desktop/gtk.nix

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
    stateVersion = "25.11";

    # User packages.
    packages = with pkgs; [
      # Home-manager itself (for management).
      inputs.home-manager.packages.${pkgs.system}.default
      # Freesm Minecraft launcher.
      # inputs.freesm.packages.${pkgs.system}.freesmlauncher
    ];
  };

  # Let Home-manager enable himself.
  programs.home-manager = {
    enable = true;
  };
}
