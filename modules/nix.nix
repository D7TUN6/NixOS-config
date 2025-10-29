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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
