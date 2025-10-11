{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  users = {
    mutableUsers = false;
    users = {
      root.initialHashedPassword = "$6$5Zt8vPc8BfMeISMu$D4aMwUxPmIUFhbaVcDw15dFxTcRw/3c/2iuHQVy41ZWzoNZCnb62L5m8mx/XBj91HrWHF7yb6kJmQiHyD8tZI/";
      d7tun6 = {
        initialHashedPassword = "$6$5Zt8vPc8BfMeISMu$D4aMwUxPmIUFhbaVcDw15dFxTcRw/3c/2iuHQVy41ZWzoNZCnb62L5m8mx/XBj91HrWHF7yb6kJmQiHyD8tZI/";
        isNormalUser = true;
        description = "d7tun6";
        extraGroups = [
          "networkmanager"
          "wheel"
          "audio"
          "video"
          "realtime"
          "storage"
          "pipewire"
          "plugdev"
          "input"
          "usbmux"
          "gamemode"
          "uinput"
          "ydotool"
          "libvirtd"
        ];
        shell = pkgs.fish;
      };
    };
  };
}
