{...}: {
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
      colors-dark = {
        alpha = "1.0";
        foreground = "ECEAFA";
        background = "1A1F25";

        regular0 = "1A1F25"; # black
        regular1 = "B17280"; # red
        regular2 = "ABB8BA"; # green
        regular3 = "D9D6AA"; # yellow
        regular4 = "8382B7"; # blue
        regular5 = "A385B5"; # magenta
        regular6 = "A2B9BA"; # cyan
        regular7 = "CCCFD8"; # white

        bright0 = "2A313A"; # black
        bright1 = "F3A7B7"; # red
        bright2 = "B0D5D1"; # green
        bright3 = "EBDEAE"; # yellow
        bright4 = "A3A2E1"; # blue
        bright5 = "CDA3E6"; # magenta
        bright6 = "AEE4E6"; # cyan
        bright7 = "E4EEF5"; # white

        selection-background = "ECEAFA";
        selection-foreground = "1A1F25";
      };
    };
  };
}
