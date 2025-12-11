{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.helix = {
    # Enable Helix.
    enable = true;
    # Set Helix as defautl editor.
    defaultEditor = true;
    # Set Helix package.
    package = pkgs.helix;
    # Set themes.
    themes = {
      # My custom standart transparent theme
      std_trans = {
        "inherits" = "base16_transparent";
        "ui.background" = {};
      };
    };
    # Helix settings.
    settings = {
      # Theme section.
      theme = "std_trans";
      # Editor section.
      editor = {
        # Enable auto-info.
        auto-info = true;
        # Ignore file-picker.
        file-picker.ignore = true;
        # Enable auto-pairs.
        auto-pairs = true;
        # Enable truecolor.
        true-color = true;
        # Enable color-modes.
        color-modes = true;
        # Set line number to relative.
        line-number = "relative";
        # Enable auto-completion.
        auto-completion = true;
        # Enable completition replace.
        completion-replace = true;
        # Enable mouse.
        mouse = true;
        # Enable soft-wrap.
        soft-wrap.enable = true;
        # LSP section.
        lsp = {
          # Enable LSP.
          enable = true;
          # Enable LSP snippets.
          snippets = true;
          # Enable LSP auto signature help.
          auto-signature-help = true;
          # Display messages from LSP.
          display-messages = true;
        };
        # Statusline section.
        statusline = {
          # Left modules.
          left = ["mode" "spinner" "file-name" "read-only-indicator"];
          # Center modules.
          center = [];
          # Right modules.
          right = ["file-type" "separator" "spacer" "position-percentage" "position" "separator" "total-line-numbers"];
          # Set separator symbol.
          separator = "|";
        };
      };
    };
  };
}
