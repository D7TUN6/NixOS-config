{
  description = "D7TUN6's personal flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    chaotic.url = "https://flakehub.com/f/chaotic-cx/nyx/*.tar.gz";
    freesm.url = "github:FreesmTeam/FreesmLauncher";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    chaotic,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        chaotic.nixosModules.default
        inputs.home-manager.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # Pass inputs to Home-manager.
            extraSpecialArgs = {inherit inputs;};

            # User-specific configuration.
            users = {
              d7tun6 = {
                imports = [
                  # Home-manager configuration.
                  ./home.nix
                ];
              };
            };
          };
        }
      ];
    };
  };
}
