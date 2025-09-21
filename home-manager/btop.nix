{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.btop = {
    # Enable btop.
    enable = true;
    # Configure btop.
    settings = {
      # Disable theme backround.
      theme_background = false;
      # Enable truecolor.
      truecolor = true;
      # Enable rounded corners.
      rounded_corners = true;
    };
  };
}
