{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix/release-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, stylix, home-manager, nixvim
    , nix-homebrew }: {
      darwinConfigurations."Chelseas-MacBook-Pro" =
        nix-darwin.lib.darwinSystem {
          inherit inputs;
          modules = [
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                # Install Homebrew under the default prefix
                enable = true;

                # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                enableRosetta = false;

                # User owning the Homebrew prefix
                user = "chelsea";
              };
            }
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
