{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
}
