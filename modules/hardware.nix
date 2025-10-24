{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  hardware = {
    bluetooth.enable = true;
    # To fix gpu.
    enableAllFirmware = true;
    firmware = with pkgs; [firmwareLinuxNonfree linux-firmware];
    cpu = {
      amd = {
        updateMicrocode = true;
      };
      intel = {
        updateMicrocode = true;
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages32 = with pkgs; [
        driversi686Linux.mesa
      ];
      extraPackages = with pkgs; [
        mesa
      ];
    };
  };
}
