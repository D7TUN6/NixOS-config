{pkgs, ...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      # Nix
      nil
      # Rust
      rust-analyzer
      bacon
      # Go
      gopls
      # Web (HTML/CSS/JS/TS)
      vscode-langservers-extracted
      typescript-language-server
      # Python
      pyright # LSP
      black # formatter
      # C
      clang-tools # provides clangd and clang-format
    ];

    themes = {
      std_trans = {
        "inherits" = "base16_transparent";
        "ui.background" = {};
      };
    };

    settings = {
      theme = "std_trans";
      editor = {
        color-modes = true;
        line-number = "relative";
        indent-guides = {
          render = true;
          last-line-only = true;
        };
        gutters = ["diagnostics" "spacer" "line-numbers" "spacer" "diff"];

        auto-info = true;
        auto-pairs = true;
        true-color = true;
        auto-completion = true;
        completion-replace = true;
        mouse = true;
        soft-wrap.enable = true;

        file-picker = {
          hidden = false;
          ignore = true;
        };

        lsp = {
          enable = true;
          snippets = true;
          auto-signature-help = true;
          display-messages = true;
          display-inlay-hints = true;
        };

        statusline = {
          left = ["mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator"];
          center = [];
          right = ["diagnostics" "selections" "position" "file-encoding" "file-type" "total-line-numbers"];
          separator = "│";
        };
      };

      keys.normal = {
        "space"."f" = "file_picker";
      };
    };

    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
          language-servers = ["nil"];
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = ["rust-analyzer"];
        }
        {
          name = "go";
          auto-format = true;
          language-servers = ["gopls"];
        }
        {
          name = "javascript";
          language-servers = ["typescript-language-server"];
          auto-format = true;
        }
        {
          name = "typescript";
          language-servers = ["typescript-language-server"];
          auto-format = true;
        }
        # Python
        {
          name = "python";
          auto-format = true;
          formatter = {command = "${pkgs.black}/bin/black";};
          language-servers = ["pyright"];
        }
        # C
        {
          name = "c";
          auto-format = true;
          formatter = {command = "${pkgs.clang-tools}/bin/clang-format";};
          language-servers = ["clangd"];
        }
      ];

      language-server = {
        nil = {command = "${pkgs.nil}/bin/nil";};
        rust-analyzer = {
          config.rust-analyzer = {
            cargo.loadOutDirsFromCheck = true;
            checkOnSave.command = "clippy";
          };
        };
        vscode-html-language-server = {command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";};
        vscode-css-language-server = {command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";};
        # Python LSP
        pyright = {command = "${pkgs.pyright}/bin/pyright-langserver";};
        # C LSP
        clangd = {command = "${pkgs.clang-tools}/bin/clangd";};
      };
    };
  };
}
