{config, pkgs, lib, ...}: let
  # All Telegram CIDR ranges from core.telegram.org/resources/cidr.txt
  telegramCidrs = [
    "91.108.4.0/22"    # DC2/DC4 (AS62041)
    "91.108.8.0/22"    # DC2/DC4
    "91.108.12.0/22"   # DC1/DC3 (AS59930)
    "91.108.16.0/22"   # DC5 (AS62014)
    "91.108.20.0/22"   # DC5
    "91.108.56.0/22"   # DC5 (91.108.56.130)
    "91.105.192.0/23"  # DC203 / extra DCs (91.105.192.100)
    "149.154.160.0/20" # DC1-5 primary range
    "185.76.151.0/24"  # Telegram infra
  ];

  googleCidrs = [
    "64.233.160.0/19"  # Google (ytimg/ggpht)
    "66.102.0.0/20"    # Google
    "72.14.192.0/18"   # Google
    "74.125.0.0/16"    # Google (i.ytimg.com, yt3.ggpht.com)
    "108.177.0.0/16"   # Google (i.ytimg.com)
    "142.250.0.0/15"   # YouTube / Google
    "172.217.0.0/16"   # Google
    "172.253.0.0/16"   # Google (yt3.ggpht.com)
    "173.194.0.0/16"   # Google (yt3.ggpht.com)
    "209.85.128.0/17"  # Google (i.ytimg.com, gmail)
    "216.58.0.0/16"    # Google
    "216.239.32.0/19"  # Google (fonts/gstatic)
  ];

  fastlyCidrs = [
    "151.101.0.0/16"   # Bandcamp / Fastly
  ];

  cloudfrontCidrs = [
    "52.84.0.0/15"     # Soundcloud / CloudFront
    "108.156.0.0/15"   # sndcdn.com / CloudFront
    "52.222.0.0/17"    # CloudFront
    "13.32.0.0/15"     # CloudFront
    "99.84.0.0/16"     # CloudFront
  ];

  cloudflareCidrs = [
    "162.159.0.0/16"    # Discord (discord.com, cdn.discordapp.com, gateway), Twitter
    "172.64.0.0/13"     # Cloudflare anycast (x.com)
    "104.16.0.0/12"     # Cloudflare anycast (1.1.1.1, Warp)
    "141.101.64.0/18"   # Cloudflare anycast
    "173.245.48.0/20"   # Cloudflare anycast
    "198.41.128.0/17"   # Cloudflare anycast
  ];

  # WARP sinkhole IPs handled by the dedicated queue 201 (see NAT dnat rule below)
  warpIps = ["104.16.24.84" "162.159.192.1"];

  metaCidrs = [
    "157.240.0.0/16"   # Meta (instagram/fbcdn/facebook/whatsapp)
    "31.13.0.0/16"     # Meta
    "69.171.0.0/16"    # Meta
    "179.60.0.0/16"    # Meta
    "173.252.0.0/16"   # Meta
    "185.60.0.0/16"    # Meta
    "108.160.0.0/16"   # Meta
    "5.101.0.0/16"     # Meta
    "204.15.0.0/16"    # Meta
    "66.220.0.0/16"    # Meta
  ];
in {
  services.zapret = {
    enable = true;
    configureFirewall = false;

    # --- DPI bypass parameters ---
    # primary:  fake,multidisorder — inject fake packet + reorder split segments
    # split-pos: 1 (first byte after record layer) + midsld (middle of SLD)
    #            → forces DPI to reassemble across TCP segments
    # fooling:   badseq (bad TCP seq) + md5sig (MD5 signature) — TSPU ignores
    #            packets with invalid seq or bad MD5 pseudo-header
    # ttl=1:     fake packet TTL=1 dies before reaching destination (no pollution)
    # any-protocol=1: enable desync for non-HTTP/non-TLS (MTProto raw packets)
    # repeats=3: send fake 3× for higher chance DPI sees it before the real one
    # cutoff=d4: stop processing after ClientHello (d4 = after 4th data packet)
    #            — saves CPU; the handshake is what DPI fingerprints
    params = [
      "--dpi-desync=fake,multidisorder"
      "--dpi-desync-split-pos=1,midsld"
      "--dpi-desync-fooling=badseq,md5sig"
      "--dpi-desync-ttl=1"
      "--dpi-desync-any-protocol=1"
      "--dpi-desync-repeats=3"
      "--dpi-desync-cutoff=d4"
    ];

    whitelist = [
      # Telegram
      "api.telegram.org"
      "core.telegram.org"
      "my.telegram.org"
      "t.me"
      "telegram.me"
      "telegram.org"
      "td.telegram.org"
      "web.telegram.org"
      "telesco.pe"
      "*.telegram.org"
      # YouTube / Google
      "youtube.com"
      "googlevideo.com"
      "ytimg.com"
      "ggpht.com"
      "youtu.be"
      "studio.youtube.com"
      "accounts.youtube.com"
      "googleusercontent.com"
      "gstatic.com"
      "googleapis.com"
      # Bandcamp
      "bandcamp.com"
      "*.bandcamp.com"
      "bcbits.com"
      "*.bcbits.com"
    ];
  };

  boot.kernelModules = ["nfnetlink_queue"];

  # --- nftables rules ---
  # Three queues, each handled by its own nfqws instance (exclusive via goto):
  #   queue 200 — zapret.service: Telegram + YouTube/Google + Bandcamp (proven params)
  #   queue 201 — zapret-cf.service: Cloudflare WARP (SNI spoofing)
  #   queue 202 — zapret-hard.service: Discord + Soundcloud + Meta/X (Cloudflare/CloudFront, aggressive)
  #
  # Telegram CIDRs are split into two groups for better matching:
  #   - 91.108.x.x — DC1-DC5 (ports 80, 443, 5222)
  #   - 149.154.160.0/20 — DC1-5 primary
  #   - 91.105.192.0/23, 185.76.151.0/24 — DC203 / extra
  #
  # Ports 80, 443, 5222 — MTProto uses all three (443 primary, 80/5222 fallback)
  networking.nftables.tables.zapret = {
    family = "ip";
    content = ''
      chain post {
        type filter hook postrouting priority mangle; policy accept;

        # --- Cloudflare WARP (queue 201) — must precede the Cloudflare rule below ---
        ip daddr { ${lib.concatStringsSep ", " warpIps} } tcp dport 443 goto warp

        # --- Telegram: 91.108.x.x (DC1-DC5) ---
        ip daddr { ${lib.concatStringsSep ", " (lib.filter (x: lib.hasPrefix "91.108." x) telegramCidrs)} } tcp dport { 80, 443, 5222 } goto main

        # --- Telegram: 149.154.x.x (DC1-5 primary) ---
        ip daddr { 149.154.160.0/20 } tcp dport { 80, 443, 5222 } goto main

        # --- Telegram: 91.105.192.x / 185.76.151.x (DC203 / extra) ---
        ip daddr { 91.105.192.0/23, 185.76.151.0/24 } tcp dport { 80, 443, 5222 } goto main

        # --- YouTube / Google ---
        ip daddr { ${lib.concatStringsSep ", " googleCidrs} } tcp dport 443 goto main

        # --- Bandcamp / Fastly ---
        ip daddr { ${lib.concatStringsSep ", " fastlyCidrs} } tcp dport 443 goto main

        # --- Soundcloud / CloudFront (queue 202) ---
        ip daddr { ${lib.concatStringsSep ", " cloudfrontCidrs} } tcp dport 443 goto hard

        # --- Cloudflare / Discord / X (queue 202); Warp IPs are handled by queue 201 above ---
        ip daddr { ${lib.concatStringsSep ", " cloudflareCidrs} } ip daddr != { ${lib.concatStringsSep ", " warpIps} } tcp dport 443 goto hard

        # --- Meta / Instagram / Facebook / WhatsApp (queue 202) ---
        ip daddr { ${lib.concatStringsSep ", " metaCidrs} } tcp dport 443 goto hard
      }

      chain main {
        queue num 200 bypass
      }
      chain warp {
        queue num 201 bypass
      }
      chain hard {
        queue num 202 bypass
      }
    '';
  };

  # TSPU DNS poisoning maps api.cloudflareclient.com (WARP registration API)
  # to sinkhole IPs (8.47.69.0, 8.6.112.0) where TLS stalls. The WARP daemon
  # resolves through its own DoH (1.1.1.1/1.0.0.1) which returns those poisoned
  # answers, bypassing dnsmasq pins. Redirect the sinkhole IPs to the real
  # Cloudflare edge instead. Update these if TSPU rotates them.
  networking.nftables.tables.nat = {
    family = "ip";
    content = ''
      chain output {
        type nat hook output priority dstnat; policy accept;
        ip daddr { 8.47.69.0, 8.6.112.0 } tcp dport 443 dnat to 104.16.24.84:443
      }
    '';
  };

  systemd.services.zapret-hard = {
    description = "DPI bypass for Discord + Soundcloud + Meta/X (Cloudflare/CloudFront)";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = let
        hardHostlist = pkgs.writeText "zapret-hard-whitelist" ''
          # Discord
          discord.com
          discord.gg
          discordapp.com
          discordapp.net
          discord.media
          discord.new
          discordstatus.com
          # Soundcloud
          soundcloud.com
          sndcdn.com
          soundcloud.app.goo.gl
          # X / Twitter
          x.com
          twitter.com
          t.co
          twimg.com
          # Instagram / Facebook / Meta
          instagram.com
          facebook.com
          whatsapp.com
          fbcdn.net
          cdninstagram.com
          # Personal site behind Cloudflare (SNI-blocked)
          d7tun6.neome.uk
          www.d7tun6.neome.uk
        '';
      in "${pkgs.zapret}/bin/nfqws --pidfile=/run/zapret-hard.pid --dpi-desync=fake,multidisorder --dpi-desync-fake-tls-mod=sni=www.cloudflare.com --dpi-desync-fooling=md5sig,badseq --dpi-desync-split-pos=1,midsld --dpi-desync-ttl=1 --dpi-desync-repeats=11 --dpi-desync-cutoff=d4 --hostlist ${hardHostlist} --qnum=202";
      Type = "simple";
      PIDFile = "/run/zapret-hard.pid";
      Restart = "always";
      RuntimeMaxSec = "1h";
      DevicePolicy = "closed";
      KeyringMode = "private";
      PrivateTmp = true;
      PrivateMounts = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      ProtectProc = "invisible";
      RemoveIPC = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
    };
  };

  systemd.services.zapret-cf = {
    description = "DPI bypass for Cloudflare (WARP)";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = let
        cfHostlist = pkgs.writeText "zapret-cf-whitelist" "cloudflareclient.com\n*.cloudflareclient.com";
      in "${pkgs.zapret}/bin/nfqws --pidfile=/run/zapret-cf.pid --dpi-desync=fake --dpi-desync-fake-tls-mod=sni=www.cloudflare.com --dpi-desync-fooling=badseq --dpi-desync-repeats=11 --hostlist ${cfHostlist} --qnum=201";
      Type = "simple";
      PIDFile = "/run/zapret-cf.pid";
      Restart = "always";
      RuntimeMaxSec = "1h";
      DevicePolicy = "closed";
      KeyringMode = "private";
      PrivateTmp = true;
      PrivateMounts = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      ProtectProc = "invisible";
      RemoveIPC = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
    };
  };
}