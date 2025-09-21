{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs = {
    niri = {
      enable = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    steam.enable = true;
    nekoray = {
      enable = true;
      tunMode.enable = true;
    };
    fish.enable = true;
  };
}
