{
  config,
  pkgs,
  ...
}: {
  networking = {
    nameservers = ["127.0.0.1" "::1"];

    networkmanager.dns = "none";

    resolvconf.extraConfig = ''
      name_servers='127.0.0.1 ::1'
    '';

    hostName = "desktop";
    enableIPv6 = true;

    hosts = {
      "149.154.167.220" = [
        "api.telegram.org"
        "my.telegram.org"
        "web.telegram.org"
      ];
    };

    networkmanager = {
      enable = true;
      dhcp = "internal";
      settings.main.ignore-carrier = "no";
    };

    nat = {
      enable = true;
      internalInterfaces = ["ve-*" "podman1"];
      externalInterface = "eth0";
      forwardPorts = [
        {
          sourcePort = 8443;
          destination = "10.233.1.2:8443";
          proto = "tcp";
          loopbackIPs = ["213.142.51.113"];
        }
      ];
    };
    interfaces.eth0 = {
      mtu = 1500;
      # useDHCP = lib.mkDefault true;
    };

    nftables.enable = true;

    nftables.tables.rkn-block = {
      family = "ip6";
      content = ''
        chain output {
          type filter hook output priority filter; policy accept;
          ip6 daddr { 2001:67c:4e8::/48, 2001:4860::/32, 2a00:1450::/32, 2a04:4e42::/32 } tcp dport 443 reject with tcp reset
        }
      '';
    };

    firewall = {
      enable = true;
      allowPing = false;
      rejectPackets = true;
      checkReversePath = "loose";
      logRefusedConnections = false;
      allowedTCPPorts = [
        21435
        80
        443
        3000
        3001
        3010
        6881
        25565
        1443
        8443
      ];
      allowedUDPPorts = [
        21435
        80
        443
        3000
        3001
        3010
        6881
        25565
        1443
        8443
        config.services.tailscale.port
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
        {
          from = 47994;
          to = 48010;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
        {
          from = 47998;
          to = 48010;
        }
      ];
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "50-tailscale-optimizations" ''
        case "$2" in
          up)
            ${pkgs.ethtool}/bin/ethtool -K eth0 rx-udp-gro-forwarding on rx-gro-list off || true
            ;;
        esac
      '';
    }
  ];

  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      listen_addresses = ["127.0.0.1:5453" "[::1]:5453"];

      server_names = ["cloudflare" "cloudflare-ipv6"];

      ipv4_servers = true;
      ipv6_servers = true;
      dnscrypt_servers = false;
      doh_servers = true;

      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;

      lb_strategy = "p2";
      lb_estimator = true;

      fallback_resolvers = ["1.1.1.1:53" "8.8.8.8:53"];
    };
  };

  systemd.services.dnscrypt-proxy = {
    after = ["network-online.target"];
    wants = ["network-online.target"];
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      listen-address = ["127.0.0.1" "::1"];
      bind-interfaces = true;
      port = 53;
      no-resolv = true;
      server = ["127.0.0.1#5453"];
      address = [
        "/bandcamp.com/151.101.65.91"
        "/bcbits.com/151.101.65.91"
        "/cache.nixos.org/151.101.65.91"
        "/pkg.cloudflareclient.com/104.16.24.84"
        "/pkg.cloudflareclient.com/::"
        "/api.cloudflareclient.com/104.16.24.84"
        "/api.cloudflareclient.com/::"
      ];
    };
  };

  systemd.services.dnsmasq = {
    after = ["dnscrypt-proxy.service"];
    requires = ["dnscrypt-proxy.service"];
  };
}
