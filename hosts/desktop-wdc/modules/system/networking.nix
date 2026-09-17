{lib, ...}: {
  networking = {
    # System DNS -> dnscrypt-proxy (DoH to Cloudflare). resolvconf is enabled so
    # /etc/resolv.conf is generated from networking.nameservers; NetworkManager
    # with dns = "none" does not overwrite it.
    nameservers = ["127.0.0.1" "::1"];

    networkmanager.dns = "none";

    resolvconf.extraConfig = ''
      override_nameservers="127.0.0.1 ::1"
      options timeout:1 attempts:1
    '';

    hostName = "desktop";
    enableIPv6 = true;

    networkmanager = {
      enable = true;
      dhcp = "internal";
      settings.main.ignore-carrier = "no";
    };

    nat = {
      enable = true;
      internalInterfaces = ["ve-+" "podman1"];
      externalInterface = "eth0";
    };
    interfaces.eth0 = {
      mtu = 1500;
      # useDHCP = lib.mkDefault true;
    };

    firewall = {
      enable = true;
      allowPing = false;
      rejectPackets = true;
      checkReversePath = "loose";
      logRefusedConnections = false;
      allowedTCPPorts = [21435 80 443 3000 3001 6881 25565 9051 8118];
      allowedUDPPorts = [21435 80 443 3000 3001 6881 25565 9051 8118];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      interfaces."podman+".allowedTCPPorts = [18080];
    };
  };

  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      listen_addresses = ["127.0.0.1:53" "[::1]:53"];

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

      fallback_resolvers = [];
    };
  };

  systemd.services.dnscrypt-proxy.after = ["network.target"];
}
