{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports =
    lib.filter
    (n: lib.strings.hasSuffix ".nix" n)
    (lib.filesystem.listFilesRecursive ./modules/home-manager);
  home = {
    username = "d7tun6";
    homeDirectory = "/home/d7tun6";
    stateVersion = "26.11";
    packages = with pkgs; [
      starship
      inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.freesm.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher
      # inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
    ];
  };
  programs.home-manager = {
    enable = true;
  };
}
