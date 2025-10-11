{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "BigBlueTermPlusNerdFont:size=9";
        pad = "16x16";
      };

      scrollback = {
        lines = 10000;
      };

      cursor = {
        style = "block";
      };

      colors = {
        foreground = "F1FAFB";
        background = "1C1C24";

        regular0 = "1C1C24"; # black
        regular1 = "E44D42"; # red
        regular2 = "7FB188"; # green
        regular3 = "D4C451"; # yellow
        regular4 = "7F7FB3"; # blue
        regular5 = "B469B5"; # magenta
        regular6 = "7FB1A8"; # cyan
        regular7 = "F1FAFB"; # white

        bright0 = "868195"; # black
        bright1 = "F29693"; # red
        bright2 = "BAD0B5"; # green
        bright3 = "EDE6AC"; # yellow
        bright4 = "C4B4D1"; # blue
        bright5 = "DFB7E0"; # magenta
        bright6 = "B1DED0"; # cyan
        bright7 = "FFFFFF"; # white

        selection-background = "868195";
        selection-foreground = "1C1C24";

        alpha = 1.0;
      };
    };
  };
}
