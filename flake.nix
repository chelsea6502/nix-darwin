{
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

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      stylix,
      home-manager,
      nixvim,
      nix-homebrew,
    }:
    {
      darwinConfigurations."Chelseas-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit inputs;
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew.enable = true;
            nix-homebrew.enableRosetta = false;
            nix-homebrew.user = "chelsea";
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
          home-manager.darwinModules.home-manager
          stylix.darwinModules.stylix
          nixvim.nixDarwinModules.nixvim
          ./configuration.nix
        ];
      };
    };
}
