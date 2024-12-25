{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nix-darwin, nixpkgs, stylix, home-manager, nixvim }: {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Chelseas-MacBook-Air
      darwinConfigurations."Chelseas-MacBook-Air" =
        nix-darwin.lib.darwinSystem {
          modules = [
            home-manager.darwinModules.home-manager
            ./configuration.nix
            stylix.darwinModules.stylix
            nixvim.nixDarwinModules.nixvim
            {
              system.configurationRevision = self.rev or self.dirtyRev or null;
            }
          ];
        };
    };
}
