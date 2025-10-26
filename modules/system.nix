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
      dates = "**:30";
      randomizedDelaySec = "5min";
      flake = inputs.self.outPath;
      flags = [
        "--refresh"
        "-L"
      ];
    };
  };
}
