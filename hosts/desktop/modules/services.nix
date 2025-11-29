{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services = {
    # lact.enable = true;
    thermald.enable = true;
    # cloudflared.enable = true;
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv4_servers = true;
        ipv6_servers = true;
        dnscrypt_servers = true;
        doh_servers = true;
        require_nofilter = true;
        require_dnssec = true;
        query_log.file = "/var/log/dnscrypt-proxy/query.log";
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        # server_names = [ ... ];
      };
    };
    xray = {
      enable = true;
      settings = {
        log = {
          loglevel = "warning";
        };
        inbounds = [
          {
            listen = "0.0.0.0";
            port = 443;
            protocol = "vless";
            settings = {
              clients = [
                {
                  id = "c5609e76-e4b4-4a98-adc9-e788cc0727ed";
                  flow = "xtls-rprx-vision";
                  # level = 0;
                }
              ];
              decryption = "none";
            };
            streamSettings = {
              network = "tcp";
              security = "reality";
              realitySettings = {
                  show = false;
                  dest = "www.google.com:443";
                  xver = 0;
                  serverNames = [
                    "www.google.com"
                  ];
                  privateKey = "eIUNF3d0HNfGMX7KLTj3dKrg2qk-BBxpvw-QA5hn0EA";
                  shortIds = ["a1b2c3d4"];
              };
            };
            sniffing = {
              enabled = true;
              destOverride = [ "http" "tls" ];
            };
          }
        ];
        outbounds = [
          {
            protocol = "freedom";
            tag = "direct";
          }
          {
            protocol = "blackhole";
            tag = "block";
          }
        ];
      };
    };
    openssh = {
      enable = true;
      ports = [ 21435 ];
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
        AllowUsers = [ "d7tun6" ];
      };
    };
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
      autoLogin = {
        user = "d7tun6";
        enable = true;
      };
      defaultSession = "niri";
    };
    dbus.implementation = "broker";
    blueman.enable = true;
    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      displayManager = {
        lightdm.enable = lib.mkForce false;
      };
      xkb = {
        layout = "us,ru";
        options = "grp:caps_toggle";
      };
    };
    btrfs = {
      autoScrub = {
        enable = true;
        fileSystems = [
          "/"
          "/nix"
          "/home"
          "/etc/nixos"
        ];
        interval = "monthly";
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    irqbalance.enable = true;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    udev = {
      extraRules = ''
        ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 41 /dev/%k"
        ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
      '';
    };
  };
}
