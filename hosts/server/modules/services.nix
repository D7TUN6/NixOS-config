{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services = {
    zfs = {
      autoScrub = {
        enable = true;
        pools = [
          "zservroot"
        ];
        randomizedDelaySec = "12h";
        interval = "monthly";
      };
      trim = {
        enable = true;
        randomizedDelaySec = "12h";
        interval = "weekly";
      };
    };
    irqbalance.enable = true;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
  };
}
