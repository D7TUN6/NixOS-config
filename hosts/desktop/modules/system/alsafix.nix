{...}: {
  services.pipewire.wireplumber.extraConfig = {
    "99-alsa-bit-perfect" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {"node.name" = "~alsa_output.*";}
            {"node.name" = "~alsa_input.*";}
          ];
          actions = {
            update-props = {
              # S32LE = the native HDA container for this codec's 24-bit DAC
              "audio.format" = "S32LE";
              "alsa.volume-method" = "hw";
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
