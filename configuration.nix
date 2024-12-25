{ pkgs, self, ... }: {
  environment.systemPackages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts-emoji
  ];

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.image = "/Users/chelsea/Downloads/test.jpg";

  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

  stylix.fonts = {
    serif = {
      package = pkgs.open-sans;
      name = "Open Sans";
    };
    sansSerif = {
      package = pkgs.open-sans;
      name = "Open Sans";
    };
    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font Mono";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
    sizes.terminal = 14;
  };

  users.users.chelsea = {
    name = "chelsea";
    home = "/Users/chelsea";
  };

  home-manager.users.chelsea = {
    stylix.enable = true;
    stylix.autoEnable = true;
    programs.home-manager.enable = true;
    home.stateVersion = "24.11";
    programs.alacritty.enable = true;
    programs.alacritty.settings = {
      cursor.style.shape = "Beam";
      cursor.style.blinking = "On";
      window = {
        startup_mode = "Fullscreen";
        decorations = "None";
        padding.x = 14;
        padding.y = 14;
      };
    };
  };

  nix.optimise.automatic = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  nix.settings.max-jobs = 8;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  programs.nixvim = ./nixvim.nix;
}