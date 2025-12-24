{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  containers = {
    webserver-d7tun6-site = {
      autoStart = true;
      privateNetwork = false;
      bindMounts = {
        "/var/www/d7tun6.site" = {
          hostPath = "/home/d7tun6/files/data/server/data/d7tun6-space/site";
          isReadOnly = true;
        };
      };
      config = { config, pkgs, lib, ... }: {
        networking = {
          nameservers = lib.mkForce [
            "127.0.0.1"
            "::1"
          ];
          firewall = {
            allowedTCPPorts = [
              443
              80
            ];
            allowedUDPPorts = [
              443
              80
            ];
          };
        };
        services = {
          nginx = {
            enable = true;
            virtualHosts = {
              "d7tun6.site" = {
                addSSL = true;
                enableACME = true;
                root = "/var/www/d7tun6.site";
              };
            };
          };
        };
        security = {
          acme = {
            acceptTerms = true;
            defaults.email = "d7tun6@gmail.com";
            certs = {
              "d7tun6.site".email = "d7tun6@gmail.com";
            };
          };
        };
        system = {
          stateVersion = "24.11";
        };
      };
    };
    "mc-private-vanilla-main-combox" = {
      autoStart = true;
      privateNetwork = false;
      bindMounts = {
        "/home/minecraft/data" = {
          hostPath = "/home/d7tun6/files/data/server/data/combox-space/game-servers/mc-private-vanilla-main";
          isReadOnly = false;
        };
      };
      config = { pkgs, ... }: {
        networking = {
          nameservers = lib.mkForce [
            "127.0.0.1"
            "::1"
          ];
          firewall = {
            allowedTCPPorts = [
              25565
            ];
            allowedUDPPorts = [
              25565
            ];
          };
        };
        systemd.services.minecraft-server-thecomboxmc = {
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            WorkingDirectory = "/home/minecraft/data/mc";
            ExecStart = "${pkgs.bash}/bin/bash -c 'cd /home/minecraft/data/mc && ${pkgs.javaPackages.compiler.temurin-bin.jdk-25}/bin/java -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar --nogui'";
            Restart = "on-failure";
            User = "root";
          };
        };
        users.users.minecraft = {
          isSystemUser = true;
          group = "minecraft";
          home = "/home/minecraft";
          createHome = true;
        };
        users.groups.minecraft = {};
        system = {
          stateVersion = "24.11";
        };
      };
    };
    "xray-vpn-tb-303" = {
      autoStart = true;
      privateNetwork = false;
      bindMounts = {
        "/var/www/d7tun6.site" = {
          hostPath = "/home/d7tun6/files/data/server/data/d7tun6-space/site";
          isReadOnly = true;
        };
      };
      config = { config, pkgs, lib, ... }: {
        networking = {
          nameservers = lib.mkForce [
            "127.0.0.1"
            "::1"
          ];
          firewall = {
            allowedTCPPorts = [
              444
            ];
            allowedUDPPorts = [
              444
            ];
          };
        };
        services = {
          xray = {
            enable = true;
            settings = {
              inbounds = [
                {
                  listen = "0.0.0.0";
                  port = 444;
                  protocol = "vless";
                  settings = {
                    clients = [
                      {
                        id = "c5609e76-e4b4-4a98-adc9-e788cc0727ed";
                        flow = "xtls-rprx-vision";
                        level = 0;
                      }
                    ];
                    decryption = "none";
                  };
                  streamSettings = {
                    network = "tcp";
                    security = "reality";
                    realitySettings = {
                        show = false;
                        dest = "www.microsoft.com:443";
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
        };
        system = {
          stateVersion = "24.11";
        };
      };
    };
  };
}
