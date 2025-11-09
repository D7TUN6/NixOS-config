{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nix = {
    settings = {
      substitute = true;
      trusted-users = [ "d7tun6" ];
      download-buffer-size = "99999999999";
      max-jobs = 13;
      cores = 13;
      build-cores = 13;
      substituters = [
        "https://nix-community.cachix.org/"
        "https://chaotic-nyx.cachix.org/"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
