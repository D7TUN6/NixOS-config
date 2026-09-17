{config, pkgs, ...}: {
  users = {
    mutableUsers = false;
    groups.realtime = {};
    users = {
      root = {
        hashedPasswordFile = config.sops.secrets.root-password-hash.path;
      };
      d7tun6 = {
        linger = true;
        hashedPasswordFile = config.sops.secrets.user-password-hash.path;
        isNormalUser = true;
        autoSubUidGidRange = true;
        description = "d7tun6";
        extraGroups = [
          "wheel"
          "audio"
          "video"
          "realtime"
          "storage"
          "pipewire"
          "plugdev"
          "input"
          "camera"
          "podman"
          "cdrom"
          "uinput"
        ];
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCBMsMIlex63xu7gKPeknVpwaEuNfGZKX+Z1T5PUHpX d7tun6@desktop-nixos"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzDd2Q8k6U7qFOGsEv1uVfdSMzuDug9a9CwHLr/aSdt termius-d7tun6"
        ];
      };
    };
  };

  # `nixos-rebuild switch` stops sops-install-secrets before running activation,
  # so update-users-groups.pl cannot read hashedPasswordFile during a switch and
  # locks the accounts ('!' in /etc/shadow). This unit re-applies the sops hashes
  # after the secrets are installed, covering both switch and boot.
  # Note: root and d7tun6 use separate secrets (root-password-hash /
  # user-password-hash), so changing one password never affects the other.
  systemd.services.password-hash-sync = {
    description = "Apply sops password hashes to users";
    wantedBy = ["multi-user.target"];
    after = ["sops-install-secrets.service"];
    requires = ["sops-install-secrets.service"];
    serviceConfig.Type = "oneshot";
    script = ''
      echo "root:$(cat ${config.sops.secrets.root-password-hash.path})" | ${pkgs.shadow}/bin/chpasswd -e
      echo "d7tun6:$(cat ${config.sops.secrets.user-password-hash.path})" | ${pkgs.shadow}/bin/chpasswd -e
    '';
  };
}
