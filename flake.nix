{
  description = "D7TUN6's personal flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    freesm.url = "github:FreesmTeam/FreesmLauncher";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      ...
    } @inputs: {

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/desktop/configuration.nix
        inputs.home-manager.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            # Pass inputs to Home-manager.
            extraSpecialArgs = {inherit inputs;};

            # User-specific configuration.
            users.d7tun6.imports = [./hosts/desktop/home.nix];
          };
        }
      ];
    };
    nixosConfigurations.server = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/server/configuration.nix
        inputs.home-manager.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            # Pass inputs to Home-manager.
            extraSpecialArgs = {inherit inputs;};

            # User-specific configuration.
            users.d7tun6.imports = [./hosts/server/home.nix];
          };
        }
      ];
    };
  };
}
