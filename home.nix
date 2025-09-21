{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Desktop.
    ./home-manager/niri.nix
    ./home-manager/waybar.nix

    # Apps.
    ./home-manager/foot.nix
    ./home-manager/fuzzel.nix
    ./home-manager/helix.nix
    ./home-manager/btop.nix
    ./home-manager/fastfetch.nix
    ./home-manager/fish.nix
    ./home-manager/gtk.nix
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
      inputs.freesm.packages.${pkgs.system}.freesmlauncher
    ];
  };

  # Let Home-manager enable himself.
  programs.home-manager.enable = true;
}
