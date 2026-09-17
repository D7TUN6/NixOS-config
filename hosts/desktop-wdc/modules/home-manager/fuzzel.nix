{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "no";
        layer = "overlay";
        terminal = "${pkgs.foot}/bin/foot";
        icon-theme = "Papirus-Dark";
        font = "monospace:size=10";
      };
      border = {
        radius = 0;
        selection-radius = 0;
      };
      colors = {
        background = "1c1c24ff";
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
