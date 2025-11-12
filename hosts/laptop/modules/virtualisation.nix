{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}
