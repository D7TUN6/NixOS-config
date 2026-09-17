{...}: {
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      truecolor = true;
      rounded_corners = true;
    };
  };
}
