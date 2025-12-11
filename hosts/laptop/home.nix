{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = lib.filter
            (n: lib.strings.hasSuffix ".nix" n)
            (lib.filesystem.listFilesRecursive ./hm-modules);
  home = {
    # Username of the user.
    username = "alex";

    # Home directory of the user.
    homeDirectory = "/home/alex";

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
