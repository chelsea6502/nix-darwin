{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nix-modules.url = "github:chelsea6502/nix-modules";
    nix-modules.flake = false;

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    darwinConfigurations."Chelseas-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
      specialArgs = { inherit (inputs) nix-modules; };
      modules = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.home-manager.darwinModules.home-manager
        inputs.stylix.darwinModules.stylix
        inputs.nixvim.nixDarwinModules.nixvim
        {
          system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModules.sops
          ];
        }
        ./configuration.nix
      ];
    };
  };
}
