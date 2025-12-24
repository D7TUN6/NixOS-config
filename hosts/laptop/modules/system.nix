{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  system = {
    stateVersion = "25.05";
    autoUpgrade = {
      enable = true;
      dates = "daily";
      randomizedDelaySec = "45min";
      flake = inputs.self.outPath;
      flags = [
        "--refresh"
        "-L"
        "--update-input"
        "nixpkgs"
        "--update-input"
        "home-manager"
        "--update-input"
        "hosts"
      ];
    };
  };
}
