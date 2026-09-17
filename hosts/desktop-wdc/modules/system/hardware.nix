{pkgs, ...}: {
  hardware = {
    enableRedistributableFirmware = true;
    firmware = with pkgs; [linux-firmware];

    ksm.enable = false;

    amdgpu = {
      opencl.enable = true;
      legacySupport.enable = true;
      initrd.enable = true;
    };

    block = {
      scheduler = {
        "nvme[0-9]*" = "none";
        "sd[a-z]*" = "none";
      };
      defaultSchedulerRotational = "mq-deadline";
    };

    cpu = {
      amd.updateMicrocode = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages32 = with pkgs.driversi686Linux; [
        mesa
      ];
      extraPackages = with pkgs; [
        libva
        libva-utils
        libva-vdpau-driver
        mesa
      ];
    };
  };
}

