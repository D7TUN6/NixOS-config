{pkgs, ...}: {
  users = {
    # No sops on desktop-wdc, so no password is committed to the repo. Passwords
    # are set interactively with `passwd` on the machine itself.
    mutableUsers = true;
    users = {
      root = {};
      d7tun6 = {
        linger = true;
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
        ];
        shell = pkgs.fish;
      };
    };
  };
}

