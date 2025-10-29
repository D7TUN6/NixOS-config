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
      root = {
        initialHashedPassword = "$6$5Zt8vPc8BfMeISMu$D4aMwUxPmIUFhbaVcDw15dFxTcRw/3c/2iuHQVy41ZWzoNZCnb62L5m8mx/XBj91HrWHF7yb6kJmQiHyD8tZI/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNoXoL0IX/E9/bAdWiY1gOZ6d4MLvG+DZzQ101aKJJ7"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8+mXBaKamU1h8bvYPPyjOfQwJAkop4ABpSX+TwDX9a"
        ];
      };
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
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNoXoL0IX/E9/bAdWiY1gOZ6d4MLvG+DZzQ101aKJJ7"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8+mXBaKamU1h8bvYPPyjOfQwJAkop4ABpSX+TwDX9a"
        ];
        shell = pkgs.fish;
      };
    };
  };
}
