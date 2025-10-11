{
  config,
  libs,
  pkgs,
  inputs,
  ...
}: {
  gtk = {
    # Enable GTK.
    enable = true;
    # Set GTK theme.
    theme = {
      # Catpuccin
      #package = pkgs.catppuccin-gtk.override {
      #  accents = ["lavender"];
      #  size = "standard";
      #  tweaks = ["rimless" "normal"];
      #  variant = "mocha";

      # adw-gtk3
      package = pkgs.adw-gtk3;
      #name = "catppuccin-mocha-lavender-standart+rimless,normal";
      name = "adw-gtk3-dark";
    };
    # Set icon theme.
    iconTheme = {
      name = "Papirus-Dark";
      # Catpuccin.
      #package = pkgs.catppuccin-papirus-folders.override {
      #  flavor = "mocha";
      #  accent = "lavender";
      #};
      package = pkgs.papirus-icon-theme;
    };
    # Set font.
    font = {
      name = "JetBrainsMonoNerdFont";
      # Size of font.
      size = 9;
    };
    # Set GTK2 config location.
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    # Configure GTK3.
    gtk3.extraConfig = {
      # Prefer dark theme.
      gtk-application-prefer-dark-theme = 1;
      # Disable GTK error bell.
      gtk-error-bell = 0;
    };
    # Configure GTK4.
    gtk4.extraConfig = {
      # Prefer dark theme.
      gtk-application-prefer-dark-theme = 1;
      # Disable GTK error bell.
      gtk-error-bell = 0;
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  # Set QT.
  qt = {
    # Enable QT.
    enable = true;
  };
}
