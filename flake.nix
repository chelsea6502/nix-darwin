{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix/release-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nix-darwin, nixpkgs, stylix, home-manager, nixvim }: {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Chelseas-MacBook-Air
      darwinConfigurations."Chelseas-MacBook-Air" =
        nix-darwin.lib.darwinSystem {
          inherit inputs;
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
