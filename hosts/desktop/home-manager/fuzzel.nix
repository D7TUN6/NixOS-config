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
        # Set default terminal.
        terminal = "${pkgs.foot}/bin/foot";
        icon-theme = "Papirus-Dark";
      };
      colors = {
        background = "1c1c24dd";
        text = "f1fafbff";
        prompt = "ffffffff";
        placeholder = "868195ff";
        input = "f1fafbff";
        match = "c4b4d1ff";
        selection = "868195ff";
        selection-text = "1c1c24ff";
        selection-match = "c4b4d1ff";
        counter = "868195ff";
        border = "c4b4d1ff";
      };
    };
  };
}
