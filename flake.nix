{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixpkgs-stable.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";
    nixpkgs-opencode.url = "https://github.com/nixos/nixpkgs/archive/d0fcbf27c60bc66cf1f6236cfc3c5e9ac782786d.tar.gz";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    freesm = {
      url = "github:FreesmTeam/FreesmLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    combox = {
      url = "path:/home/d7tun6/files/mounts/TS480SSD/services/prod/ComBox";
      flake = false;
    };
    d7tun6-radio = {
      url = "path:/home/d7tun6/files/mounts/TS480SSD/services/site/d7tun6/radio";
      flake = false;
    };
    dvigunchik-bot = {
      url = "git+file:///home/d7tun6/files/mounts/TS480SSD/services/bot-dvigunchik";
      flake = false;
    };
    shakalizator-bot = {
      url = "path:/home/d7tun6/files/mounts/TS480SSD/services/bot-shakalizator";
      flake = false;
    };
    pidorbot = {
      url = "path:/home/d7tun6/files/mounts/TS480SSD/services/pidorbot";
      flake = false;
    };
    pivometr-bot = {
      url = "path:/home/d7tun6/files/mounts/TS480SSD/services/pivometr";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tg-ws-proxy = {
      url = "github:Flowseal/tg-ws-proxy";
      flake = false;
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-bun = {
      url = "github:ryoppippi/nix-bun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-opencode,
    home-manager,
    chaotic,
    freesm,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = ["dcraw-9.28.0"];
      };
    };
  in {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};

      modules = [
        ./hosts/desktop/configuration.nix
        ./hosts/desktop/containers.nix
        inputs.sops-nix.nixosModules.sops
        chaotic.nixosModules.default
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {
          environment.systemPackages = [
            nixpkgs-opencode.legacyPackages.${pkgs.system}.opencode
          ];
        })
        {
          nixpkgs.overlays = [
            (final: prev: {
              telegram-bot-api = prev.telegram-bot-api.overrideAttrs (old: {
                patches = (old.patches or []) ++ [./hosts/desktop/modules/production/telegram-bot-api-proxy.patch];
              });
            })
          ];
        }
        ({
          pkgs,
          lib,
          inputs,
          ...
        }: {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs;};
            users.d7tun6.imports = [./hosts/desktop/home.nix];
          };
          sops.package = let
            pkg = pkgs.buildGoModule {
              pname = "sops-install-secrets";
              version = "0.0.1";
              src = lib.sourceByRegex inputs.sops-nix [
                "go\\.(mod|sum)"
                "pkgs"
                "pkgs/sops-install-secrets.*"
              ];
              vendorHash = "sha256-SXOd+0yh0DQr3uLVQBdw07J9j5HNuFJSOajDul1B1qo=";
              subPackages = ["pkgs/sops-install-secrets"];
              doCheck = false;
            };
          in
            pkg;
          sops = {
            age.keyFile = "/home/d7tun6/.config/sops/age/keys.txt";
            gnupg.sshKeyPaths = [];
            useSystemdActivation = true;
            secrets = {
              markov-bot-token = {
                sopsFile = ./secrets/markov-bot-token.enc;
                format = "binary";
              };
              shakalizator-bot-token = {
                sopsFile = ./secrets/shakalizator-bot-token.enc;
                format = "binary";
              };
              pidorbot-token = {
                sopsFile = ./secrets/pidorbot-token.enc;
                format = "binary";
              };
              pivometr-bot-token = {
                sopsFile = ./secrets/pivometr-bot-token.enc;
                format = "binary";
              };
              blurt-bot-token = {
                sopsFile = ./secrets/blurt-bot-token.enc;
                format = "binary";
              };
              blogbot-token = {
                sopsFile = ./secrets/blogbot-token.enc;
                format = "binary";
              };
              minecraft-rcon-password = {
                sopsFile = ./secrets/minecraft-rcon-password.enc;
                format = "binary";
                owner = "d7tun6";
                group = "users";
                mode = "0440";
              };
              cloudflare-origin-cert = {
                sopsFile = ./secrets/cloudflare-origin-cert.enc;
                format = "binary";
                owner = "caddy";
                group = "caddy";
                mode = "0440";
              };
              cloudflare-origin-key = {
                sopsFile = ./secrets/cloudflare-origin-key.enc;
                format = "binary";
                owner = "caddy";
                group = "caddy";
                mode = "0440";
              };
              qbitwebui-encryption-key = {
                sopsFile = ./secrets/qbitwebui-encryption-key.enc;
                format = "binary";
                owner = "d7tun6";
                group = "users";
                mode = "0640";
              };
              tailscale-key = {
                sopsFile = ./secrets/tailscale-key.enc;
                format = "binary";
              };
              tg-ws-proxy-secret = {
                sopsFile = ./secrets/tg-ws-proxy-secret.enc;
                format = "binary";
              };
              telegram-bot-api-id = {
                sopsFile = ./secrets/telegram-bot-api-id.enc;
                format = "binary";
              };
              telegram-bot-api-hash = {
                sopsFile = ./secrets/telegram-bot-api-hash.enc;
                format = "binary";
              };
              xray-reality-private-key = {
                sopsFile = ./secrets/xray-reality-private-key.enc;
                format = "binary";
              };
              xray-client-uuid = {
                sopsFile = ./secrets/xray-client-uuid.enc;
                format = "binary";
              };
              user-password-hash = {
                sopsFile = ./secrets/user-password-hash.enc;
                format = "binary";
              };

              root-password-hash = {
                sopsFile = ./secrets/root-password-hash.enc;
                format = "binary";
              };
            };
          };
        })
      ];
    };
    nixosConfigurations.desktop-wdc = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/desktop-wdc/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs;};
            users.d7tun6.imports = [./hosts/desktop-wdc/home.nix];
          };
        }
      ];
    };

    homeConfigurations."d7tun6" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules = [./hosts/desktop/home.nix];
    };
    homeConfigurations."desktop-wdc" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules = [./hosts/desktop-wdc/home.nix];
    };
  };
}
