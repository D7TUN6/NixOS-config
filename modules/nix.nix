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
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.07"
      ];
    };
  };

  nix = {
    settings = {
      substitute = true;
      trusted-users = [ "d7tun6" ];
      download-buffer-size = "99999999999";
      max-jobs = 13;
      cores = 13;
      build-cores = 13;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
