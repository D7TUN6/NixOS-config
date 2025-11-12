{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
      substitute = true;
      trusted-users = [ "d7tun6" ];
      download-buffer-size = "99999999999";
      max-jobs = 1;
      cores = 1;
      build-cores = 1;
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      randomizedDelaySec = "45min";
      dates = "daily";
    };
  };
}
