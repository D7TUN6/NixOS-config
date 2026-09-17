{pkgs, ...}: {
  services.swaync = {
    enable = true;
    settings = {
      positionx = "right";
      positiony = "top";
      layer = "top";
      control-center-margin-top = 5;
      control-center-margin-bottom = 5;
      control-center-margin-right = 5;
      control-center-margin-left = 5;
      notification-icon-size = 32;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 5;
      timeout-low = 2;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 320;
      widgets = [
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];
      widget-config = {
        title = {
          text = "notifications";
          clear-all-button = true;
          button-text = "clear";
        };
        dnd = {
          text = "dnd";
        };
      };
    };
    style = ''
      @define-color bg #1a1f25;
      @define-color bg2 #2a313a;
      @define-color text #eceafa;
      @define-color main #8382b7;
      @define-color overlay #6c6b8f;
      @define-color red #b17280;
      @define-color green #abb8ba;

      * {
        font-family: BigBlueTermPlusNerdFont;
        font-size: 9px;
        background-clip: padding-box;
        box-shadow: none;
        text-shadow: none;
        border-radius: 0;
      }

      .control-center {
        background: @bg;
        border: 4px solid @overlay;
        padding: 8px;
      }

      .control-center .widget-title {
        color: @text;
        background: @overlay;
        padding: 4px;
        margin-bottom: 6px;
      }

      .control-center .widget-title > button {
        background: @bg2;
        color: @text;
        border: none;
        padding: 2px 6px;
      }

      .control-center .widget-title > button:hover {
        background: @main;
      }

      .widget-dnd {
        background: @bg2;
        padding: 4px;
        margin-bottom: 6px;
        color: @text;
      }

      .widget-dnd > switch {
        background: @overlay;
        border: none;
      }

      .widget-dnd > switch:checked {
        background: @main;
      }

      .notification {
        background: @overlay;
        margin: 4px 0;
        padding: 6px;
      }

      .notification-content {
        background: @bg2;
        padding: 6px;
        color: @text;
      }

      .notification-default-action:hover {
        background: @bg2;
      }

      .notification-red {
        border: 1px solid @red;
      }

      .blank-window {
        background: transparent;
      }

      .mpris {
        background: @bg2;
        color: @text;
        padding: 6px;
        margin-bottom: 6px;
      }

      .mpris-button {
        color: @text;
        background: @overlay;
      }

      .mpris-button:hover {
        background: @main;
      }
    '';
  };
}
