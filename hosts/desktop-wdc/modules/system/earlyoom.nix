{...}: {
  # Tuned to not kill GUI apps under load: zramSwap is capped at 50% RAM (was
  # 100%), so swap doesn't always look exhausted, and the OOM thresholds are
  # lowered so earlyoom only fires as a last resort.
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 2;
    freeSwapThreshold = 2;
    extraArgs = [
      "-r 3"
      "--avoid"
      "^(renoise|schism|reaper|jackd|pipewire)$"
    ];
  };
}
