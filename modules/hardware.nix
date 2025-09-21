{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  hardware = {
    # To fix gpu.
    enableAllFirmware = true;
    firmware = with pkgs; [firmwareLinuxNonfree];

    cpu = {
      amd = {
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
        mesa.opencl
        mesa
      ];
    };
  };
}
