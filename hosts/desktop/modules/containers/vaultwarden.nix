{
  config,
  pkgs,
  ...
}: let
  vaultwardenDataPath = "/home/d7tun6/files/mounts/TS480SSD/services/vaultwarden-data";
  tlsDir = "/home/d7tun6/files/system/hosts/desktop/smth/vaultwarden-tls";
  vwLocalhostProxy = pkgs.writeShellScript "vaultwarden-localhost-proxy" ''"${
      pkgs.socat
    }/bin/socat" -4 OPENSSL-LISTEN:8912,bind=127.0.0.1,fork,reuseaddr,cert=${tlsDir}/vaultwarden.crt,key=${tlsDir}/vaultwarden.key,verify=0 TCP:192.168.100.25:8912 &
    exec "${pkgs.socat}/bin/socat" -6 OPENSSL-LISTEN:8912,bind=[::1],fork,reuseaddr,cert=${tlsDir}/vaultwarden.crt,key=${tlsDir}/vaultwarden.key,verify=0 TCP:192.168.100.25:8912
  '';
  vwCaCert = pkgs.writeText "vaultwarden-ca.crt" ''
    -----BEGIN CERTIFICATE-----
    MIIELzCCApegAwIBAgIUX4uDvdzpMTFzNGaOgG6/tKj9hSkwDQYJKoZIhvcNAQEL
    BQAwHzEdMBsGA1UEAwwUVmF1bHR3YXJkZW4gTG9jYWwgQ0EwHhcNMjYwOTA5MTgy
    NTA0WhcNMzYwOTA2MTgyNTA0WjAfMR0wGwYDVQQDDBRWYXVsdHdhcmRlbiBMb2Nh
    bCBDQTCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBAJuyBOiFtmg8yHvG
    ewZC1hpLmgUEkENU9ZhmzEwe5ms4pRRZfs8ja9CKv8UI6FrHRdeqc9n5yCz/CPTW
    xHJ+2YKzp7EM5hBNvhmVCTp3DOEq3/CZsqUl16ac3b8LZg92s9hirzRccwJN3wF0
    xyvA9KphS2bTlbbQshZjvePYvrb5tuguEJdcMJD8/TOohuMgz1JX5mM5nfangxVG
    NBNH5OSB8a2hGiqlltU0wrSYFHwmJjkxZFNAKiqTwrkolLcaU3XkxEyb43sS7Ykr
    YmPghB1KoY0lUmXG3bsjmnrohDokVTbwISY3HFWfMpaSKlVtU8dTKIJdodi1CbYw
    S0eluBtIy6UKLmJDYlBbsyKY2XnC6uQz8+3cjME2nKJsgfNQdRtrfm7NY11TdVC0
    wnfH1o5e0x9HsPff54XL7ShX9bHgoR7ZJCT2VLKdRA1/Kr/WwyR3Fs8n3udUYTA2
    FX2Rfj/zRy42jTxY6oOxgixqz434omgTgBQ6BPx+PSCFMvJZOQIDAQABo2MwYTAd
    BgNVHQ4EFgQUjt1Lj3Cv9QgvssRT56bQr+Kd4sMwHwYDVR0jBBgwFoAUjt1Lj3Cv
    9QgvssRT56bQr+Kd4sMwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYw
    DQYJKoZIhvcNAQELBQADggGBAC1E1cLMuWv9D8zgygRFvzjf5kKtf6DyubzqIQAS
    diItt6TV7rtiZdAJY2snvNbPGKm3vEl6HG57ogbO4F7U/RqbR9LrLztzZVsa5jyc
    ZIkEx+2mqC2ee14YlmD+KCJwX6pUwquhfe1NmdhVQGfD+X6eS1EjAbAToTnLILZO
    6MBE+Y9apCWqllAt8vlXiUG1HO70dbd1dITpdVYsQ01NiVaqZy3U11pC3YOFD2Av
    ZR1DqPVYuoFYz3+kED8o/bTIfDaj6da+G13rQvJgfXvEoCTJjL9qzc8clDTpLkY+
    RPPvIA++A+BD+nkpMJ0LPqor8ztuoSfWljwFUxEc1D9QkxcihkqKwhuErFRWUdBZ
    tBYlN5S9Nj0vc3z344WoIaeW2ddLIX6O7tVYo/Y54Vk/wEbPScYgDMD4aepdwuKM
    ZUa5iDyFzWNY59SPdT9PdbFKHrqcdBE92jORpRErrTmU5XXB5xCCAaTVxjXPTNnC
    t+H0dOfs5w4szmNEZ2ZjE+ynbw==
    -----END CERTIFICATE-----
  '';
in {
  systemd.tmpfiles.rules = [
    "d ${vaultwardenDataPath} 0755 1000 1000 -"
    "Z ${vaultwardenDataPath} 0755 1000 1000 -"
  ];
  security.pki.certificateFiles = [vwCaCert];
  networking.firewall.allowedTCPPorts = [8912];
  systemd.services.vaultwarden-localhost = {
    description = "socat TLS proxy exposing containerized vaultwarden on https://localhost:8912";
    after = ["container@vaultwarden.service"];
    requires = ["container@vaultwarden.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = vwLocalhostProxy;
      Restart = "on-failure";
      RestartSec = "2s";
    };
  };
  containers.vaultwarden = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.24";
    localAddress = "192.168.100.25";

    forwardPorts = [
      {
        containerPort = 8912;
        hostPort = 8912;
        protocol = "tcp";
      }
    ];

    bindMounts = {
      "/var/lib/vaultwarden" = {
        hostPath = vaultwardenDataPath;
        isReadOnly = false;
      };
    };

    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      systemd.tmpfiles.rules = [
        "d /var/lib/vaultwarden 0755 root root -"
      ];

      systemd.services.vaultwarden-data-perms = {
        before = ["vaultwarden.service"];
        requiredBy = ["vaultwarden.service"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.coreutils}/bin/chown -R vaultwarden:vaultwarden /var/lib/vaultwarden";
        };
      };

      system.stateVersion = "24.11";
      time.timeZone = "Asia/Yekaterinburg";

      users.users.d7tun6 = {
        isNormalUser = true;
        group = "users";
      };
      users.groups.d7tun6 = {};

      networking = {
        nameservers = lib.mkForce ["8.8.8.8" "1.1.1.1"];
        firewall.allowedTCPPorts = [8912];
      };

      services.vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "https://localhost:8912";
          ROCKET_PORT = 8912;
          ROCKET_ADDRESS = "0.0.0.0";
          SIGNUPS_ALLOWED = false; # false
          SIGNUPS_VERIFY = true;
          INVITATIONS_ALLOWED = true;
        };
      };
    };
  };
}