{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  security = {
    tpm2 = {
      enable = true;
    };
    polkit.enable = true;
    rtkit.enable = true;
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };
    # allowUserNamespaces = false;
    virtualisation = {
      flushL1DataCache = "always";
    };
    pam = {
      loginLimits = [
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "99";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "soft";
          value = "99999";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "hard";
          value = "99999";
        }
        {
          domain = "*";
          type = "hard";
          item = "nofile";
          value = "524288";
        }
        {
          domain = "*";
          type = "soft";
          item = "nofile";
          value = "523288";
        }
        {
          domain = "d7tun6";
          type = "hard";
          item = "nofile";
          value = "524288";
        }
        {
          domain = "d7tun6";
          type = "soft";
          item = "nofile";
          value = "523288";
        }
        {
          domain = "*";
          item = "core";
          type = "hard";
          value = "0";
        }
      ];
    };
    acme = {
      acceptTerms = true;
      defaults.email = "d7tun6.site";
    };
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/systemctl suspend";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/poweroff";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };
}
