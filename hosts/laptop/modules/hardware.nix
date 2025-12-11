{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  hardware = {
    # enableAllFirmware = true;
    # enableAllHardware = true;
    enableRedistributableFirmware = true;
    firmware = with pkgs; [linux-firmware];
    amdgpu = {
      opencl.enable = true;
      legacySupport.enable = true;
    };
    block = {
      scheduler = {
        "mmcblk[0-9]*" = "none";
        "nvme[0-9]*" = "none";
        "sd[a-z]*" = "none";
      };
      defaultSchedulerRotational = "none";
    };
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
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
  };
}
