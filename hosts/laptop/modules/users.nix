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
      };
      user = {
        initialHashedPassword = "$6$5Zt8vPc8BfMeISMu$D4aMwUxPmIUFhbaVcDw15dFxTcRw/3c/2iuHQVy41ZWzoNZCnb62L5m8mx/XBj91HrWHF7yb6kJmQiHyD8tZI/";
        isNormalUser = true;
        description = "d7tun6";
        extraGroups = [
          "wheel"
          "audio"
          "video"
          "realtime"
          "storage"
          "pipewire"
          "plugdev"
          "input"
        ];
        shell = pkgs.fish;
      };
    };
  };
}
