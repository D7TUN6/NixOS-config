{
  config,
  pkgs,
  inputs,
  ...
}: let
  flakeDir = "/home/d7tun6/files/system";
  user = "d7tun6";
  nix = config.nix.package;
  homeManager = inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  # Mirrors the nfu / nrs / ngc aliases from environment.nix, but made
  # non-interactive:
  #   nfu -> nix flake update --commit-lock-file --flake /home/d7tun6/files/system/.
  #       (as d7tun6 so flake.lock is written with the user's permissions)
  #   nrs -> nh os switch
  #       (as root; no sudo needed since the unit itself runs as root)
  #   ngc -> home-manager expire-generations + user nix-collect-garbage (as
  #       d7tun6), then root nix-collect-garbage + nix-store --optimize.
  # All user stages go through `runuser`, so no password is ever prompted.
  systemd.services.nixos-maintenance = {
    description =
      "Daily NixOS maintenance: flake update (nfu), system switch (nrs), garbage collection (ngc)";
    wantedBy = [];
    after = ["network-online.target" "nix-daemon.service"];
    wants = ["network-online.target"];
    environment = {
      NH_FLAKE = flakeDir;
      NH_OS_FLAKE = flakeDir;
    };
    path = [
      nix
      homeManager
      pkgs.nh
      pkgs.util-linux
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnused
      pkgs.gnugrep
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Nice = 10;
      IOSchedulingClass = "idle";
      TimeoutStartSec = "4h";
    };
    script = ''
      set -euo pipefail
      step() { echo "[nixos-maintenance] $*"; }

      step "nfu: nix flake update as ${user}"
      runuser -u ${user} -- \
        ${nix}/bin/nix flake update --commit-lock-file --flake ${flakeDir}/.

      step "nrs: nh os switch as root"
      ${pkgs.nh}/bin/nh os switch ${flakeDir}

      step "ngc: home-manager expire-generations as ${user}"
      runuser -u ${user} -- \
        ${homeManager}/bin/home-manager expire-generations '-0 days'

      step "ngc: user nix-collect-garbage as ${user}"
      runuser -u ${user} -- ${nix}/bin/nix-collect-garbage -d

      step "ngc: root nix-collect-garbage"
      ${nix}/bin/nix-collect-garbage -d

      step "ngc: nix-store --optimize"
      ${nix}/bin/nix-store --optimize

      step "done"
    '';
  };

  systemd.timers.nixos-maintenance = {
    description = "Timer for daily NixOS maintenance (01:00)";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00";
      Persistent = true;
    };
  };
}