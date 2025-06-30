{ pkgs, self, ... }: {
  environment.systemPackages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts-emoji
    nodejs
    git
    typescript
    typescript-language-server
  ];

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
      nix-update = "cd ~/.config/nix-darwin/ && nix flake update";
      nix-clean = "nix-collect-garbage -d && nix-store --optimise";
      nix-verify = "nix-store --verify --check-contents";
      nix-full = "nix-update && switch && nix-clean && nix-verify";
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
    image = "/Users/chelsea/Downloads/test.jpg";
    base16Scheme =
      "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

    fonts = {
      sizes.terminal = 14;

      serif.package = pkgs.open-sans;
      serif.name = "Open Sans";
      sansSerif.package = pkgs.open-sans;
      sansSerif.name = "Open Sans";
      monospace.package = pkgs.nerd-fonts.fira-code;
      monospace.name = "FiraCode Nerd Font Mono";
      emoji.package = pkgs.noto-fonts-emoji;
      emoji.name = "Noto Color Emoji";
    };
  };

  homebrew = {
    enable = true;

    onActivation.autoUpdate = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;

    casks = [
      "google-chrome"
      "discord"
      "alacritty"
      "utm"
      "telegram"
      "messenger"
      "github"
      "eqmac"
      "spotify"
      "microsoft-office"
      "steam"
      "battle-net"
      "signal"
      "moonlight"
    ];
  };

  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 7d";

    settings.max-jobs = 8;
    settings.experimental-features = "nix-command flakes";
  };

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
      "/Applications/GitHub Desktop.app"
      "/Applications/Alacritty.app"
      "/Applications/Telegram.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Mail.app"
    ];

  };

  security.pam.services.sudo_local.touchIdAuth = true;
  services = {
    aerospace.enable = true;
    aerospace.settings.gaps.inner.horizontal = 8;
    aerospace.settings.gaps.outer.left = 8;
    aerospace.settings.gaps.outer.bottom = 8;
    aerospace.settings.gaps.outer.top = 8;
    aerospace.settings.gaps.outer.right = 8;

    jankyborders.enable = true;
    jankyborders.active_color = "0xFFFFFFFF";
    jankyborders.inactive_color = "0x88FFFFFF";
    jankyborders.width = 2.0;
  };

}
