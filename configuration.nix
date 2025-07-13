{ pkgs, nix-modules, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts-emoji
    nodejs
    git
    typescript
    zjstatus
    sops
    age
  ];

  homebrew = {
    enable = true;

    onActivation.autoUpdate = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;

    casks = [
      # Pr*prietary software
      #"battle-net"
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

  users.users.chelsea.name = "chelsea";
  users.users.chelsea.home = "/Users/chelsea";

  programs.nixvim = import "${nix-modules}/nixvim.nix" { inherit pkgs; };

  home-manager.backupFileExtension = ".backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.chelsea = {
    programs.home-manager.enable = true;
    home.stateVersion = "25.05";

    # SOPS configuration
    sops.defaultSopsFile = ./secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/Users/chelsea/.config/sops/age/keys.txt";
    sops.secrets.anthropic_api_key.mode = "0400";

    # Alacritty
    programs.alacritty.enable = true;
    programs.alacritty.settings = {
      cursor.style.shape = "Beam";
      cursor.style.blinking = "On";
      window.startup_mode = "Fullscreen";
      window.decorations = "buttonless";
      window.padding.x = 14;
      window.padding.y = 14;
      window.option_as_alt = "Both";
    };

    programs.lazygit.enable = true;

    programs.zellij.enable = true;
    programs.zellij.settings.pane_frames = false;
    programs.zellij.settings.show_startup_tips = false;

    xdg.configFile."zellij/layouts/default.kdl" = import "${nix-modules}/zellij.nix" {
      inherit pkgs;
    };

    programs.zsh.enable = true;
    programs.zsh.initContent = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PROMPT="%F{green}%F{blue}%~%f $ "
      export ANTHROPIC_API_KEY="$(cat ~/.config/sops-nix/secrets/anthropic_api_key 2>/dev/null || echo "")"
      export SOPS_AGE_KEY_FILE="/Users/chelsea/.config/sops/age/keys.txt"
      export EDITOR="nvim"
    '';

    programs.zsh.syntaxHighlighting.enable = true;
    programs.zsh.shellAliases = {
      edit = "nvim";
      Ec = "nvim ~/.config/nix-darwin/configuration.nix";
      EC = "Ec && switch";
      ECC = "Ec && nix-full";
      Ef = "nvim ~/.config/nix-darwin/flake.nix";
      En = "nvim ~/modules/nixvim.nix";
      Ez = "nvim ~/modules/zellij.nix";
      Es = "nvim ~/.config/nix-darwin/secrets.yaml";
      switch = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin/";
      nix-update = "nix flake update --flake ~/.config/nix-darwin/";
      nix-clean = "nix-collect-garbage -d && nix-store --optimise";
      nix-deepclean = "sudo nix-env --delete-generations old --profile
			/nix/var/nix/profiles/system && sudo nix-clean";
      nix-verify = "sudo nix-store --verify --check-contents --repair";
      nix-full = "nix-update && switch && nix-clean && nix-verify";
      z = "zellij";
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
    image = "/";
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

}
