{
  description = "Unified System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # "x220" is the hostname we are defining
      x220 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # We will move your existing files here in the next step
          ./hosts/x220/configuration.nix
          
          # Integrate Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.scaf = import ./hosts/x220/home.nix; # <-- CHANGE THIS
          }
        ];
      };
    };
  };
}
