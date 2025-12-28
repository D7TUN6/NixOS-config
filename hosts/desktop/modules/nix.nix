{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nix = {
    optimise = {
      automatic = true;
      dates = "daily";
    };
    settings = {
      auto-optimise-store = true;
      substitute = true;
      allowed-users = [ "d7tun6" "root" ];
      download-buffer-size = "99999999999";
      max-jobs = 13;
      cores = 13;
      build-cores = 13;
      substituters = [
        "https://cache.nixos.org/"
        "https://cache.garnix.io"
        "https://cache.m7.rs"
        "https://nix-gaming.cachix.org"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        # "https://nix-community.cachix.org"
        
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.m7.rs:kszZ/NSwE/TjhOcPPQ16IuUiuRSisdiIwhKZCxguaWg="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        #"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
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
