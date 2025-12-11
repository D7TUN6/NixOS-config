{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs = {
    coolercontrol = {
      enable = true;
      nvidiaSupport = true;
    };
    java = {
      enable = true;
      package = pkgs.javaPackages.compiler.temurin-bin.jre-21;
    };
    appimage = {
      enable = true;
      binfmt = true;
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
