{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  console = {
    earlySetup = true;
    useXkbConfig = true;
  };
}
