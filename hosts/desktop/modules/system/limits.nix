{
  lib,
  ...
}: {
  # NixOS containers (container@X.service): payload runs under the service
  # cgroup, so service-level MemoryHigh/MemoryMax apply. MemoryHigh is a soft
  # limit: the kernel swaps/reclaims within the cgroup instead of OOM-killing.
  # Production containers get a low soft limit + generous hard cap so a spike
  # never kills the container.
  systemd.services."container@jellyfin".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "1G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };
  systemd.services."container@xray".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "1G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };
  systemd.services."container@navidrome".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "1G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };
  systemd.services."container@syncthing".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "1G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };
  systemd.services."container@vaultwarden".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "1G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };
  systemd.services."container@tor-gateway".serviceConfig = {
    CPUWeight = 20;
    MemoryHigh = "1G";
    MemoryMax = "3G";
    IOWeight = 20;
    AllowedCPUs = "0,1,6,7";
  };

  # Podman containers run in separate libpod-*.scope cgroups, so limits on the
  # podman-*.service unit never reach the container. The only working way is
  # podman's own --memory flag (verified for both rootful and rootless here).
  virtualisation.oci-containers.containers = {
    # combox stack (rootful, machine.slice)
    minio.extraOptions = ["--memory=2g"];
    postgres.extraOptions = ["--memory=1g"];
    valkey.extraOptions = ["--memory=512m"];
    nginx.extraOptions = ["--memory=512m"];
    anubis-app.extraOptions = ["--memory=512m"];
    anubis-site.extraOptions = ["--memory=512m"];
    pgweb.extraOptions = ["--memory=256m"];
    # qbittorrent trio (rootless, user@1000)
    qbittorrent.extraOptions = ["--memory=2g"];
    net-agent.extraOptions = ["--memory=512m"];
    qbitwebui.extraOptions = ["--memory=1g"];
    # tg-ws-proxy (rootful, host network)
    tg-ws-proxy.extraOptions = ["--memory=1g"];
  };

  # Host services: no cgroup juggling, plain MemoryHigh (soft) + MemoryMax.
  systemd.services.d7tun6-pm2.serviceConfig = {
    MemoryHigh = "1.5G";
    MemoryMax = "3G";
  };
  systemd.services.d7tun6-build.serviceConfig = {
    # npm build is hourly and can spike; MemoryHigh only (no hard cap so a
    # rebuild is never killed, just slowed by reclaim/swap)
    MemoryHigh = "1.5G";
  };
  systemd.services.telegram-bot-api.serviceConfig = {
    MemoryHigh = "1G";
    MemoryMax = "3G";
  };
  systemd.services.markov-bot.serviceConfig = {
    MemoryHigh = "256M";
    MemoryMax = "1G";
  };
  systemd.services.bot-shakalizator.serviceConfig = {
    MemoryHigh = "512M";
    MemoryMax = "2G";
  };
  systemd.services.minecraft.serviceConfig = {
    MemoryHigh = "10G";
    MemoryMax = "12G";
  };

  # --- Systemd slices ---
  # Isolate build processes from services so compilation can't starve
  # running services, and services can't block builds.
  systemd.slices.build = {
    description = "Slice for nix-daemon build workers";
    sliceConfig = {
      # Builds can use up to 6 GiB total across all workers.
      # MemoryHigh triggers reclaim/swap; MemoryMax is hard cap.
      MemoryMax = "6G";
      MemoryHigh = "4G";
      CPUWeight = 80;
      IOWeight = 80;
      # Allow builds to use all cores (no AllowedCPUs restriction)
    };
  };

  systemd.slices.services = {
    description = "Slice for long-running services";
    sliceConfig = {
      # CPU/IO weight for host services. Memory is limited per-service
      # (each service has its own MemoryHigh/MemoryMax).
      CPUWeight = 100;
      IOWeight = 60;
    };
  };

  systemd.slices.containers = {
    description = "Slice for rootful container workloads";
    sliceConfig = {
      # Collective CPU/IO weight for rootful podman containers.
      # Memory is limited per-container via podman --memory, not at slice level,
      # because rootful containers manage their own cgroups.
      CPUWeight = 60;
      IOWeight = 40;
    };
  };

  # --- OOM Score Adjustments ---
  # Protect critical services from OOM-killer; let expendable ones die first.
  systemd.services.sshd.serviceConfig.OOMScoreAdjust = -900;
  systemd.services.earlyoom.serviceConfig.OOMScoreAdjust = -900;
  systemd.services.systemd-journald.serviceConfig.OOMScoreAdjust = -900;
  systemd.services.dnscrypt-proxy.serviceConfig.OOMScoreAdjust = -500;
  systemd.services.dnsmasq.serviceConfig.OOMScoreAdjust = -500;
  systemd.services.NetworkManager.serviceConfig.OOMScoreAdjust = -500;
  systemd.services.tailscaled.serviceConfig.OOMScoreAdjust = -500;
  systemd.services.pipewire.serviceConfig.OOMScoreAdjust = -500;
  # DO NOT set serviceConfig on user@1000 — NixOS generates a drop-in that
  # breaks the user session manager (dbus, XDG_RUNTIME_DIR, env vars).

  # --- cgroup limits for build-related services ---
  # nix-daemon: the main build service — MemoryHigh=4G lets it burst but
  # triggers reclaim before it eats all RAM. MemoryMax=6G is the hard cap.
  # OOMScoreAdjust=-900 protects builds from OOM-killer.
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "4G";
    MemoryMax = "6G";
    CPUWeight = 100;
    IOWeight = 100;
    OOMScoreAdjust = -900;
  };

  # Assign services to slices for resource isolation.
  # NOTE: NixOS containers (container@X.service) are auto-placed in machine.slice
  # by the nixos-containers module — do NOT assign them here (conflicts).
  # Rootless podman services (podman.user = "d7tun6") live in user@1000.service
  # and CANNOT be moved to system-level slices.
  systemd.services.d7tun6-pm2.serviceConfig.Slice = "services.slice";
  systemd.services.d7tun6-build.serviceConfig.Slice = "build.slice";
  systemd.services.telegram-bot-api.serviceConfig.Slice = "services.slice";
  systemd.services.markov-bot.serviceConfig.Slice = "services.slice";
  systemd.services.bot-shakalizator.serviceConfig.Slice = "services.slice";
  systemd.services.minecraft.serviceConfig.Slice = "services.slice";
  systemd.services.caddy.serviceConfig.Slice = "services.slice";
  # Rootful podman containers — can be assigned to system slices
  systemd.services."podman-tg-ws-proxy".serviceConfig.Slice = "containers.slice";
  systemd.services."podman-nginx".serviceConfig.Slice = "containers.slice";
  systemd.services."podman-postgres".serviceConfig.Slice = "containers.slice";
  systemd.services."podman-valkey".serviceConfig.Slice = "containers.slice";
  systemd.services."podman-minio".serviceConfig.Slice = "containers.slice";
  systemd.services."podman-anubis-app".serviceConfig.Slice = "containers.slice";
  systemd.services."podman-anubis-site".serviceConfig.Slice = "containers.slice";
  systemd.services."podman-pgweb".serviceConfig.Slice = "containers.slice";
}
