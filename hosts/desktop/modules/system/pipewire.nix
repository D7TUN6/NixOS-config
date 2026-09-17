{...}: {
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    extraConfig = {
      pipewire = {
        "99-audio-realtime" = {
          "context.properties" = {
            # rtkit denies RT to the lingering user manager (no active session
            # ACL), leaving pipewire on SCHED_OTHER+nice. The pipewire user
            # service already carries LimitRTPRIO=95, so request RT directly.
            "rt.use-rtkit" = false;
            "rt.prio" = 88;
            "default.clock.rate" = 48000;
            # ALC1220 DAC rates: 44100 48000 96000 192000 (no 88200)
            "default.clock.allowed-rates" = [44100 48000 96000 192000];
            "default.clock.quantum" = 256;
            "default.clock.min-quantum" = 256;
            "default.clock.max-quantum" = 256;
          };
        };
        "99-bit-perfect" = {
          "stream.properties" = {
            "resample.disable" = true;
            "channelmix.disable" = true;
            "dither.disable" = true;
          };
        };
      };
    };
  };
}
