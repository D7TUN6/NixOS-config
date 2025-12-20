{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.kitty = {
    # Enable kitty.
    enable = true;

    # Font settings.
    font = {
      # Set font name.
      #name = "JetBrainsMonoNerdFont";
      name = "BigBlueTermPlusNerdFont";
      # Set font size.
      size = 9;
    };
    # Configure kitty.
    settings = {
      # Disable confirmation when closing window.
      confirm_os_window_close = 0;
      # Set width of window padding.
      window_padding_width = 16;
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.4";
      # Set background opacity.
      #background_opacity = 0.9;
      # Toggle dynamic background opacity.
      #dynamic_background_opacity = "yes";

      # The basic colors
      foreground = "#F1FAFB";
      background = "#1C1C24";
      selection_foreground = "#1C1C24";
      selection_background ="#868195";

      # Cursor colors
      cursor = "#868195";
      cursor_text_color = "#1C1C24";

      # URL underline color when hovering with mouse
      url_color = "#868195";

      # Kitty window border colors
      active_border_color = "#b4befe";
      inactive_border_color = "#6c7086";
      bell_border_color = "#f9e2af";

      # OS Window titlebar colors
      wayland_titlebar_color = "system";
      macos_titlebar_color = "system";

      # Tab bar colors
      active_tab_foreground = "#11111b";
      active_tab_background = "#cba6f7";
      inactive_tab_foreground = "#cdd6f4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111b";

      # Colors for marks (marked text in the terminal)
      mark1_foreground = "#1e1e2e";
      mark1_background = "#b4befe";
      mark2_foreground = "#1e1e2e";
      mark2_background = "#cba6f7";
      mark3_foreground = "#1e1e2e";
      mark3_background = "#74c7ec";

      # The 16 terminal colors

      # black
      color0 = "#1C1C24";
      color8 = "#868195";

      # red
      color1 = "#E44D42";
      color9 = "#F29693";

      # green
      color2  = "#7FB188";
      color10 = "#BAD0B5";

      # yellow
      color3  = "#D4C451";
      color11 = "#EDE6AC";

      # blue
      color4  = "#7F7FB3";
      color12 = "#C4B4D1";

      # magenta
      color5  = "#B469B5";
      color13 = "#DFB7E0";

      # cyan
      color6  = "#7FB1A8";
      color14 = "#B1DED0";

      # white
      color7  = "#F1FAFB";
      color15 = "#FFFFFF";
      
    };
  };
}
