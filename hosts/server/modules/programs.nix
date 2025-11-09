{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs = {
    java = {
      enable = true;
      package = pkgs.javaPackages.compiler.temurin-bin.jre-21;
    };
    fish = {
      enable = true;
    };
  };
}
