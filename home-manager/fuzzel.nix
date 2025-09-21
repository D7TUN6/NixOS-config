{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.fuzzel = {
    # Enable fuzzel.
    enable = true;
    # Fuzzel settings.
    settings = {
      # Main section.
      main = {
        # Set layer for fuzzel window.
        layer = "overlay";
      };
    };
  };
}
