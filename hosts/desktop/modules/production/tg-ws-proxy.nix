{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.services.tg-ws-proxy;
  src = inputs.tg-ws-proxy;
  flakeDir = "/home/d7tun6/files/system";
  user = "d7tun6";
  nix = config.nix.package;

  venv = pkgs.python3.withPackages (ps: [
    ps.cryptography
    ps.certifi
  ]);

  app = pkgs.stdenv.mkDerivation {
    pname = "tg-ws-proxy";
    version = src.shortRev or "dirty";
    src = src;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/lib
      cp -r proxy utils $out/lib/
    '';
  };

  startScript = pkgs.writeShellScriptBin "tg-ws-proxy-start" ''
    set -eu
    args="--host ${cfg.host} --port ${toString cfg.port}"
    for dc in ${lib.concatStringsSep " " cfg.dcIps}; do
      args="$args --dc-ip $dc"
    done
    if [ -n "''${TG_WS_PROXY_SECRET:-}" ]; then
      args="$args --secret $TG_WS_PROXY_SECRET"
    fi
    exec ${venv}/bin/python -u ${app}/lib/proxy/tg_ws_proxy.py $args
  '';

  image = pkgs.dockerTools.buildImage {
    name = "tg-ws-proxy";
    tag = "latest";
    copyToRoot = pkgs.buildEnv {
      name = "tg-ws-proxy-root";
      paths = [venv app startScript];
    };
    config = {
      Env = ["PYTHONUNBUFFERED=1"];
      ExposedPorts = {"1443/tcp" = {};};
      Cmd = ["/bin/tg-ws-proxy-start"];
    };
  };
in {
  options.services.tg-ws-proxy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the tg-ws-proxy MTProto WebSocket proxy (built from Flowseal/tg-ws-proxy).";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address the proxy listens on inside the container";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 1443;
      description = "Port the proxy listens on";
    };

    dcIps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "1:149.154.175.53"
        "2:149.154.167.220"
        "3:149.154.175.100"
        "4:149.154.167.220"
        "5:91.108.56.130"
        "203:149.154.167.220"
      ];
      description = "Telegram DC -> IP overrides passed as --dc-ip";
    };

    secretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Sops secret path containing TG_WS_PROXY_SECRET=... (stable MTProto secret, 32 hex chars)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tg-ws-proxy.secretFile = lib.mkDefault "/run/secrets/tg-ws-proxy-secret";
    networking.firewall.allowedTCPPorts = [cfg.port];

    systemd.services."podman-tg-ws-proxy" = {
      after = ["sops-install-secrets.service"];
      requires = ["sops-install-secrets.service"];
      restartTriggers = [image];
      serviceConfig.ExecStartPre = "${pkgs.podman}/bin/podman load -i ${image}";
    };

    virtualisation.oci-containers.containers.tg-ws-proxy = {
      image = "tg-ws-proxy:latest";
      # Host networking: the proxy must resolve Telegram DC hostnames through
      # the host's DNS and route through the host's tunnel (fake-IP routes live
      # in the host's netns; a private container netns can't reach 198.18.x.x).
      extraOptions =
        ["--pull=never" "--network=host"]
        ++ lib.optional (cfg.secretFile != null) "--env-file=${cfg.secretFile}";
    };

    systemd.services.tg-ws-proxy-update = {
      description = "tg-ws-proxy auto-update: refetch source and rebuild system";
      # systemd gives units a minimal PATH (no /run/current-system/sw/bin),
      # so bare `nix` / `nixos-rebuild` would fail. Same pattern as
      # nixos-maintenance (maintenance.nix).
      path = [
        nix
        pkgs.nixos-rebuild
        pkgs.util-linux
        pkgs.coreutils
      ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        TimeoutStartSec = "30min";
      };
      script = ''
        set -euo pipefail
        cd ${flakeDir}
        # flake.lock is owned by the user; run the update as them so the lock
        # file keeps the right ownership (see maintenance.nix).
        runuser -u ${user} -- ${nix}/bin/nix flake update tg-ws-proxy
        ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${flakeDir}#desktop
      '';
    };

    systemd.timers.tg-ws-proxy-update = {
      description = "Biweekly tg-ws-proxy auto-update";
      wantedBy = ["multi-user.target"];
      timerConfig = {
      # 1st and 15th of each month, off-peak hours (instead of a full
      # flake-update + nixos-rebuild switch every week)
      OnCalendar = "*-*-1,15 03:00:00";
        Persistent = true;
        RandomizedDelaySec = "6h";
      };
    };
  };
}
