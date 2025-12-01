{ pkgs, nix-modules, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts-color-emoji
    nodejs
    git
    typescript
    sops
    docker
    cachix
    qmk
    yarn
  ];

  nix-homebrew.enable = true;
  nix-homebrew.enableRosetta = false;
  nix-homebrew.user = "chelsea";

  homebrew.enable = true;

  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.cleanup = "uninstall";
  homebrew.onActivation.upgrade = true;

  homebrew.casks = [
    # Pr*prietary software
    "microsoft-office"
    "google-chrome"
    "microsoft-teams"
    "wifi-explorer"
    # "parallels"  # Install manually from parallels.com - Homebrew installation fails due to macOS permission restrictions

    # Open Source
    "alacritty"
    "eqmac"
    "vscodium"
    "ferdium"
    # "qutebrowser"
    "anki"
    # "gopeed"
  ];

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
    sops.secrets.github_api_key.mode = "0400";

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

    programs.qutebrowser.enable = true;
    programs.qutebrowser.settings.tabs.show = "multiple";
    programs.qutebrowser.settings.statusbar.show = "in-mode";
    programs.qutebrowser.settings.content.javascript.clipboard = "access-paste";

    programs.lazygit.enable = true;

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
      switch = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin/";
      nix-update = "nix flake update --flake ~/.config/nix-darwin/";
      nix-clean = "nix-collect-garbage -d && nix-store --optimise";
      nix-deepclean = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system && sudo nix-clean";
      nix-verify = "sudo nix-store --verify --check-contents --repair";
      nix-full = "nix-update && switch && nix-clean && nix-verify";
      nix-fix = "sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin && sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin && sudo darwin-rebuild switch --flake ~/.config/nix-darwin/";
      z = "zellij";

      pydev = "${pkgs.writeShellScriptBin "pydev" ''
        export PATH="${pkgs.python3}/bin:${pkgs.python3Packages.pip}/bin:${pkgs.python3Packages.virtualenv}/bin:$PATH"
        [ ! -f "requirements.txt" ] && exec ${pkgs.zsh}/bin/zsh
        if [ ! -d ".venv" ]; then
          ${pkgs.python3Packages.virtualenv}/bin/virtualenv .venv
        fi
        source .venv/bin/activate
        pip install -q --upgrade pip
        pip install -q -r requirements.txt
        exec ${pkgs.zsh}/bin/zsh
      ''}/bin/pydev";
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
    fonts.emoji.package = pkgs.noto-fonts-color-emoji;
    fonts.emoji.name = "Noto Color Emoji";
  };

  nix.optimise.automatic = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  nix.settings.max-jobs = 8;
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.substituters = [
    "https://cache.nixos.org/"
    "https://nix-community.cachix.org"
    "https://nixpkgs-unfree.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
  ];

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
      "/Applications/Safari.app"
      "/System/Applications/Notes.app"
      "/Applications/Ferdium.app"
      "/Applications/Alacritty.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Mail.app"
    ];

  };

  security.pam.services.sudo_local.touchIdAuth = true;

}
