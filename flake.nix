{
  description = "D7TUN6's personal flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-gaming.url = "github:fufexan/nix-gaming";
    chaotic.url = "https://flakehub.com/f/chaotic-cx/nyx/*.tar.gz";
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
      nixpkgs-master,
      nixpkgs-stable,
      chaotic,
      ...
    } @inputs:
    let
      args = {
        pkgsStable = import nixpkgs-stable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        pkgsMaster = import nixpkgs-master {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        inherit inputs;
      };
    in
    {

    system = [
      "x86_64-linux"
    ];
  
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      #specialArgs = { inherit inputs; };
      specialArgs = args; 
      modules = [
        ./configuration.nix
        chaotic.nixosModules.default
        inputs.home-manager.nixosModules.default
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
