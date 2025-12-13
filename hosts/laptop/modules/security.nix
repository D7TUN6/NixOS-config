{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  security = {
    tpm2.enable = true;
    polkit.enable = true;
    rtkit.enable = true;
    pam = {
      loginLimits = [
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
          domain = "alex";
          type = "hard";
          item = "nofile";
          value = "524288";
        }
        {
          domain = "alex";
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
