{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/release-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    #nixvim.url = "github:chelsea6502/nixvim"; # dev mode
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    zjstatus.url = "github:dj95/zjstatus";

    nix-modules.url = "github:chelsea6502/nix-modules";
    #nix-modules.url = "path:/Users/chelsea/modules"; # dev mode
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
          nixpkgs.overlays = [
            (final: prev: {
              zjstatus = inputs.zjstatus.packages.${prev.system}.default;
              # Fix for missing dockerfile-language-server
              dockerfile-language-server = prev.docker-language-server;
            })
          ];
          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModules.sops
          ];
        }
        ./configuration.nix
      ];
    };
  };
}
