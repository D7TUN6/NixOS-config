{
  description = "D7TUN6's personal flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    freesm.url = "github:FreesmTeam/FreesmLauncher";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      chaotic,
      ...
    } @inputs: {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        chaotic.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            # Pass inputs to Home-manager.
            extraSpecialArgs = {inherit inputs;};

            # User-specific configuration.
            users.d7tun6.imports = [./home.nix];
          };
        }
      ];
    };
  };
}
