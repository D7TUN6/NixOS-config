{
  description = "D7TUN6's personal flake";

  inputs = {
    # Stable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # Beta
    nixpkgs-beta.url = "github:nixos/nixpkgs/nixos-25.11";
    # Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Master
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    
    freesm.url = "github:FreesmTeam/FreesmLauncher";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-beta,
      nixpkgs-unstable,
      nixpkgs-master,
      home-manager,
      ...
    } @inputs:
      let
      args = {
        pkgsStable = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        pkgsMaster = import nixpkgs-master {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        pkgsBeta = import nixpkgs-beta {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        pkgsUnstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        inherit inputs;
      };
      in
    {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
              users.d7tun6.imports = [ ./hosts/desktop/home.nix ];
            };
          }
        ];
      };

      server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/server/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
              users.d7tun6.imports = [ ./hosts/server/home.nix ];
            };
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
              users.user.imports = [ ./hosts/laptop/home.nix ];
            };
          }
        ];
      };
    };
  };
}
