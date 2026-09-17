{...}: {
  services.pipewire.wireplumber.extraConfig = {
    "99-alsa-lowlatency" = {
      "monitor.alsa.rules" = [
        {
          matches = [{"node.name" = "~alsa_output.*";}];
          actions = {
            update-props = {
              "api.alsa.disable-batch" = true;
              "api.alsa.headroom" = 0;
              "session.suspend-timeout-seconds" = 0;
            };
          };
        }
      ];
    };
  };
}
