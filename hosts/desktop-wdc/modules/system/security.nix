{...}: {
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              subject.isInGroup("wheel")) {
              return polkit.Result.YES;
          }
          if (action.id == "org.freedesktop.systemd1.reply-password" &&
              subject.isInGroup("wheel")) {
              return polkit.Result.YES;
          }
        });
      '';
    };
    rtkit.enable = true;

    tpm2 = {
      enable = true;
      tctiEnvironment.enable = true;
      pkcs11.enable = true;
    };

    pam.services.swaylock = {};
    pam.loginLimits = [
      {
        domain = "@audio";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "@audio";
        type = "-";
        item = "nice";
        value = "-20";
      }
      {
        domain = "@audio";
        type = "-";
        item = "rtprio";
        value = "99";
      }
      {
        domain = "@audio";
        type = "soft";
        item = "nofile";
        value = "99999";
      }
      {
        domain = "@audio";
        type = "hard";
        item = "nofile";
        value = "99999";
      }

      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "523288";
      }
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "524288";
      }
    ];
  };
}
