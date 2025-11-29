{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
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
    username = "user";

    # Home directory of the user.
    homeDirectory = "/home/user";

    # Home-manager version.
    stateVersion = "25.05";

    # User packages.
    packages = with pkgs; [
      # Home-manager itself (for management).
      inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
      # Freesm Minecraft launcher.
      # inputs.freesm.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher
    ];
  };

  # Let Home-manager enable himself.
  programs.home-manager = {
    enable = true;
  };
}
