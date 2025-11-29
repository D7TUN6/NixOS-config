{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
    scsiLinkPolicy = "max_performance";
    powertop.enable = true;
  };
}
