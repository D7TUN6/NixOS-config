{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  systemd = {
    network.wait-online.enable = false;
    settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
  };
}
