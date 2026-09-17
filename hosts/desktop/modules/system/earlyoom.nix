{...}: {
  # Tuned for 100% zram setup: with zram at 100% of RAM, swap is fast and
  # compressed. earlyoom triggers early (5% threshold) to prevent the system
  # from entering heavy swap thrashing — better to kill a low-priority process
  # than slow down everything.
  services.earlyoom = {
    enable = true;
    # 5% free RAM ≈ 380 MiB — triggers before the system becomes sluggish.
    # 10% free swap — ensures we still have headroom in disk swap.
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    extraArgs = [
      # -r 0 disables the periodic memory report that spammed the journal
      # every 3 seconds (hundreds of lines per 30min); OOM protection stays.
      "-r 0"
      # Protect audio/DJ apps from OOM kills
      "--avoid"
      "^(renoise|schism|reaper|jackd|pipewire)$"
    ];
  };
}
