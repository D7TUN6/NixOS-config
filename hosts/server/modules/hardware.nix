{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  hardware = {
    enableAllFirmware = true;
    enableAllHardware = true;
    enableRedistributableFirmware = true;
    firmware = with pkgs; [linux-firmware];
    block = {
      scheduler = {
        "mmcblk[0-9]*" = "bfq";
        "nvme[0-9]*" = "none";
        "sd[a-z]*" = "none";
      };
      defaultSchedulerRotational = "bfq";
    };
    cpu = {
      amd = {
        updateMicrocode = true;
      };
      intel = {
        updateMicrocode = true;
      };
    };
  };
}
