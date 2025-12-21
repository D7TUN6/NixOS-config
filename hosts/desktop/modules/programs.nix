{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs = {
    gphoto2.enable = true;
    hyprland = {
     enable = true;
     xwayland.enable = true;
     withUWSM = true; 
    };
    niri.enable = true;
    java = {
      enable = true;
      package = pkgs.javaPackages.compiler.temurin-bin.jre-25;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraPackages = [ pkgs.jdk ];
      gamescopeSession.enable = true;
    };
    throne = {
      enable = true;
      tunMode.enable = true;
    };
    fish = {
      enable = true;
    };
  };
}
