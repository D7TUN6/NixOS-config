{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  users = {
    users = {
      d7tun6 = {
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
        ];
        shell = pkgs.fish;
      };
    };
  };
}
