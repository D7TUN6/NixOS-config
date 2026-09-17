{
  config,
  pkgs,
  ...
}: {
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrainsMonoNerdFont";
      size = 9;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-error-bell = 0;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-error-bell = 0;
    };
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @define-color window_bg_color #1a1f25;
    @define-color window_fg_color #eceafa;
    @define-color view_bg_color #1a1f25;
    @define-color view_fg_color #eceafa;
    @define-color headerbar_bg_color #1a1f25;
    @define-color headerbar_fg_color #eceafa;
    @define-color headerbar_backdrop_color #1a1f25;
    @define-color sidebar_bg_color #1a1f25;
    @define-color sidebar_fg_color #eceafa;
    @define-color sidebar_backdrop_color #1a1f25;
    @define-color card_bg_color #2a313a;
    @define-color card_fg_color #eceafa;
    @define-color popover_bg_color #2a313a;
    @define-color popover_fg_color #eceafa;
    @define-color dialog_bg_color #1a1f25;
    @define-color dialog_fg_color #eceafa;

    @define-color accent_bg_color #8382b7;
    @define-color accent_fg_color #1a1f25;
    @define-color accent_color #8382b7;

    @define-color destructive_bg_color #b17280;
    @define-color destructive_fg_color #eceafa;
    @define-color destructive_color #b17280;

    @define-color success_bg_color #abb8ba;
    @define-color success_fg_color #1a1f25;
    @define-color success_color #abb8ba;

    @define-color warning_bg_color #d9d6aa;
    @define-color warning_fg_color #1a1f25;
    @define-color warning_color #d9d6aa;

    @define-color error_bg_color #b17280;
    @define-color error_fg_color #eceafa;
    @define-color error_color #b17280;

    window, .background, messagebox, dialog, headerbar, .header-bar, sidebar, .sidebar, stack {
      background-color: #1a1f25 !important;
      color: #eceafa !important;
    }
  '';

  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @define-color window_bg_color #1a1f25;
    @define-color window_fg_color #eceafa;
    @define-color view_bg_color #1a1f25;
    @define-color view_fg_color #eceafa;
    @define-color headerbar_bg_color #1a1f25;
    @define-color headerbar_fg_color #eceafa;
    @define-color headerbar_backdrop_color #1a1f25;
    @define-color sidebar_bg_color #1a1f25;
    @define-color sidebar_fg_color #eceafa;
    @define-color sidebar_backdrop_color #1a1f25;
    @define-color card_bg_color #2a313a;
    @define-color card_fg_color #eceafa;
    @define-color popover_bg_color #2a313a;
    @define-color popover_fg_color #eceafa;
    @define-color dialog_bg_color #1a1f25;
    @define-color dialog_fg_color #eceafa;

    @define-color accent_bg_color #8382b7;
    @define-color accent_fg_color #1a1f25;
    @define-color accent_color #8382b7;

    @define-color destructive_bg_color #b17280;
    @define-color destructive_fg_color #eceafa;
    @define-color destructive_color #b17280;

    @define-color success_bg_color #abb8ba;
    @define-color success_fg_color #1a1f25;
    @define-color success_color #abb8ba;

    @define-color warning_bg_color #d9d6aa;
    @define-color warning_fg_color #1a1f25;
    @define-color warning_color #d9d6aa;

    @define-color error_bg_color #b17280;
    @define-color error_fg_color #eceafa;
    @define-color error_color #b17280;

    window, .background, messagebox, dialog, headerbar, .header-bar, sidebar, .sidebar, stack {
      background-color: #1a1f25 !important;
      color: #eceafa !important;
    }
  '';

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adw-gtk3";
  };
}
