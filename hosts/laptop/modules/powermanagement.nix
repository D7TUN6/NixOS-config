{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  powerManagement = {
    enable = true;
    powertop.enable = true;
    # cpuFreqGovernor = "powersave";
  };
}
