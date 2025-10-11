{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config = {
      allowInsecure = true;
      allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "reaper"
      ];
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.07"
        "ventoy-gtk3-1.1.05"
      ];
    };
  };

  nix = {
    settings = {
      extra-platforms = [ "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      system-features = ["nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-znver1" "gccarch-native"];
      download-buffer-size = "99999999999";
      max-jobs = 13;
      cores = 13;
      build-cores = 13;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substitute = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://cache.garnix.io"
        "https://chaotic-nyx.cachix.org/"
        "https://nix-gaming.cachix.org"
        "https://freesmlauncher.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "freesmlauncher.cachix.org-1:Jcp5Q9wiLL+EDv8Mh7c6L9xGk+lXr7/otpKxMOuBuDs="
      ];
    };
  };
}
