{
  description = "Scaf's NixOS and nix-darwin systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nixpkgs-darwin,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      workSystem = "aarch64-darwin";
      workPkgs = import nixpkgs-darwin {
        system = workSystem;
        config.allowUnfreePredicate = pkg: nixpkgs-darwin.lib.getName pkg == "terraform";
      };
      workUnstablePkgs = import nixpkgs-unstable {
        system = workSystem;
      };
    in
    {
      nixosConfigurations.x220 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/x220/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.scaf = import ./hosts/x220/home.nix;
          }
        ];
      };

      darwinConfigurations.macbook-pro = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/macbook-pro
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.scaf = import ./hosts/macbook-pro/home.nix;
          }
        ];
      };

      homeConfigurations."endra.rahman@work" = home-manager.lib.homeManagerConfiguration {
        pkgs = workPkgs;
        extraSpecialArgs = {
          inherit inputs;
          unstablePkgs = workUnstablePkgs;
        };
        modules = [ ./hosts/work/home.nix ];
      };
    };
}
