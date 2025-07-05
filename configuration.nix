{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts-emoji
    nodejs
    git
    typescript
  ];

  # install claude code imperatively. not ideal for many reasons
  # system.activationScripts.npmPackages.text = ''
  #   ${pkgs.nodejs}/bin/npm install -g claude-code
  # '';

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.chelsea.name = "chelsea";
  users.users.chelsea.home = "/Users/chelsea";

  programs.nixvim = import ./nixvim.nix { inherit pkgs; };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.chelsea = {
    programs.home-manager.enable = true;
    home.stateVersion = "25.05";

    # Alacritty
    programs.alacritty.enable = true;
    programs.alacritty.settings = {
      cursor.style.shape = "Beam";
      cursor.style.blinking = "On";
      window.startup_mode = "Fullscreen";
      window.decorations = "buttonless";
      window.padding.x = 14;
      window.padding.y = 14;
    };

    programs.lazygit.enable = true;

    # zsh
    programs.zsh.enable = true;
    programs.zsh.initContent = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PROMPT="%F{green}%F{blue}%~%f $ "
    '';
    programs.zsh.syntaxHighlighting.enable = true;
    programs.zsh.shellAliases = {
      edit = "nvim";
      Ec = "nvim ~/.config/nix-darwin/configuration.nix";
      EC = "Ec && switch";
      ECC = "Ec && nix-full";
      Ef = "nvim ~/.config/nix-darwin/flake.nix";
      En = "nvim ~/.config/nix-darwin/nixvim.nix";
      switch = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin/";
      nix-update = "nix flake update --flake ~/.config/nix-darwin/";
      nix-clean = "nix-collect-garbage -d && nix-store --optimise";
      nix-deepclean = "sudo nix-env --delete-generations old --profile
			/nix/var/nix/profiles/system && nix-clean";
      nix-verify = "nix-store --verify --check-contents --repair";
      nix-full = "nix-update && switch && nix-clean && nix-verify";
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
    image = "/Users/chelsea/Downloads/test.jpg";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

    fonts.sizes.terminal = 14;

    fonts.serif.package = pkgs.open-sans;
    fonts.serif.name = "Open Sans";
    fonts.sansSerif.package = pkgs.open-sans;
    fonts.sansSerif.name = "Open Sans";
    fonts.monospace.package = pkgs.nerd-fonts.fira-code;
    fonts.monospace.name = "FiraCode Nerd Font Mono";
    fonts.emoji.package = pkgs.noto-fonts-emoji;
    fonts.emoji.name = "Noto Color Emoji";
  };

  homebrew = {
    enable = true;

    onActivation.autoUpdate = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;

    casks = [
      # Pr*prietary software
      "battle-net"
      "discord"
      "google-chrome"
      "messenger"
      "microsoft-office"
      "spotify"
      "steam"

      # Open Source
      "alacritty"
      "eqmac"
      "signal"
      "telegram"
      "utm"
      "visual-studio-code"
      "transmission"
    ];
  };

  nix.optimise.automatic = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  nix.settings.max-jobs = 8;
  nix.settings.experimental-features = "nix-command flakes";

  system.primaryUser = "chelsea";
  system.stateVersion = 5;
  system.startup.chime = false;

  system.defaults = {
    # show hidden files
    NSGlobalDomain.AppleShowAllFiles = true;

    # trackpad sensitivity
    NSGlobalDomain."com.apple.trackpad.scaling" = 2.0;

    # firm trackpad click
    trackpad.FirstClickThreshold = 2;

    # auto hide dock
    dock.autohide = true;

    # hide files on desktop
    WindowManager.StandardHideDesktopIcons = true;

    # control
    controlcenter.AirDrop = false;
    controlcenter.Bluetooth = false;
    controlcenter.BatteryShowPercentage = true;

    # auto-install updates
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

    finder.ShowPathbar = true;
    finder.QuitMenuItem = true;
    finder.FXPreferredViewStyle = "clmv";
    finder.FXRemoveOldTrashItems = true;

    dock.show-recents = false;
    dock.persistent-apps = [
      "/Applications/Spotify.app"
      "/Applications/Safari.app"
      "/System/Applications/Notes.app"
      "/Applications/Google Chrome.app"
      "/Applications/UTM.app"
      "/Applications/Discord.app"
      "/Applications/Messenger.app"
      "/Applications/Alacritty.app"
      "/Applications/Telegram.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Mail.app"
    ];

  };

  security.pam.services.sudo_local.touchIdAuth = true;

  services.aerospace.enable = true;
  services.aerospace.settings.gaps.inner.horizontal = 8;
  services.aerospace.settings.gaps.outer.left = 8;
  services.aerospace.settings.gaps.outer.bottom = 8;
  services.aerospace.settings.gaps.outer.top = 8;
  services.aerospace.settings.gaps.outer.right = 8;

  services.jankyborders.enable = true;
  services.jankyborders.active_color = "0xFFFFFFFF";
  services.jankyborders.inactive_color = "0x88FFFFFF";
  services.jankyborders.width = 2.0;

}
