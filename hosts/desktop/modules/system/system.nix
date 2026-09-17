{...}: {
  system = {
    stateVersion = "26.05";
  };

  systemd.services.systemd-machined = {
    after = [ "systemd-machined.socket" ];
    requires = [ "systemd-machined.socket" ];
  };
}

