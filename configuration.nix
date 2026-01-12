{ pkgs, ... }:
{
  imports = [
    ./modules/nixvim.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    nodejs
    git
    typescript
    sops
    docker
    cachix
    qmk
    postgresql
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
    "microsoft-teams"
    #"affinity"
    "google-chrome"
    "battle-net"
    "steam"
    # "parallels"  # needs manual install

    # Open Source
    "alacritty"
    #"eqmac"
    "vscodium"
    "ferdium"
    "anki"
    "pgadmin4"
    "claude"
    "docker-desktop"
    #"wipr"
    "yubico-authenticator"
  ];

  users.users.chelsea.name = "chelsea";
  users.users.chelsea.home = "/Users/chelsea";

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

      # Auto-activate Python venvs
      auto_venv() {
        if [[ -f ".venv/bin/activate" ]]; then
          [[ "$VIRTUAL_ENV" != "$PWD/.venv" ]] && source .venv/bin/activate
        elif [[ -n "$VIRTUAL_ENV" ]]; then
          deactivate
        fi
      }
      add-zsh-hook chpwd auto_venv
      auto_venv  # run on shell start
    '';

    programs.zsh.syntaxHighlighting.enable = true;
    programs.zsh.shellAliases = {
      edit = "nvim";
      Ec = "nvim ~/.config/nix-darwin/configuration.nix";
      EC = "Ec && switch";
      ECC = "Ec && nix-full";
      Ef = "nvim ~/.config/nix-darwin/flake.nix";
      En = "nvim ~/.config/nix-darwin/modules/nixvim.nix";
      switch = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin/";
      nix-update = "nix flake update --flake ~/.config/nix-darwin/";
      nix-clean = "nix-collect-garbage -d && nix-store --optimise";
      nix-deepclean = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system && sudo nix-clean";
      nix-verify = "sudo nix-store --verify --check-contents --repair";
      nix-full = "nix-update && switch && nix-clean && nix-verify";
      nix-fix = "sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin && sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin && sudo darwin-rebuild switch --flake ~/.config/nix-darwin/";
      z = "zellij";

      pydev = "${pkgs.uv}/bin/uv venv && source .venv/bin/activate && ${pkgs.uv}/bin/uv pip install -r requirements.txt";
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
    # Non-default: show hidden files (default is false)
    NSGlobalDomain.AppleShowAllFiles = true;

    # Non-default: fast key repeat (default is 6)
    NSGlobalDomain.KeyRepeat = 2;

    # Non-default: faster initial key repeat delay (default is 68)
    NSGlobalDomain.InitialKeyRepeat = 30;

    # Non-default: auto switch between dark/light mode (default is false)
    NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;

    # Non-default: disable swipe navigation with scrolls (default is true)
    NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;

    # Non-default: trackpad sensitivity (default is 1.0)
    NSGlobalDomain."com.apple.trackpad.scaling" = 2.0;

    # Non-default: firm click (default is 1 = medium)
    trackpad.FirstClickThreshold = 2;

    # Non-default: auto hide dock (default is false)
    dock.autohide = true;

    # Non-default: hide desktop icons (default is false)
    WindowManager.StandardHideDesktopIcons = true;

    # Non-default: hide AirDrop/Bluetooth from control center
    controlcenter.AirDrop = false;
    controlcenter.Bluetooth = false;

    # Non-default: show battery percentage (default is false)
    controlcenter.BatteryShowPercentage = true;

    # Non-default: auto-install macOS updates
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

    # Non-default: show path bar (default is false)
    finder.ShowPathbar = true;

    # Non-default: allow quitting Finder (default is false)
    finder.QuitMenuItem = true;

    # Non-default: column view (default is icnv = icon view)
    finder.FXPreferredViewStyle = "clmv";

    # Non-default: auto-remove old trash items
    finder.FXRemoveOldTrashItems = true;

    # Non-default: hide recent apps in dock (default is true)
    dock.show-recents = false;

    # Non-default: larger dock icons (default is 48)
    dock.tilesize = 64;

    # Non-default: bottom-right hot corner = Quick Note (14)
    dock.wvous-br-corner = 14;

    dock.persistent-apps = [
      "/Applications/Safari.app"
      "/System/Applications/Notes.app"
      "/Applications/Ferdium.app"
      "/Applications/Alacritty.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Mail.app"
    ];

  };

  # Chinese Pinyin input source
  system.defaults.CustomUserPreferences = {
    "com.apple.HIToolbox" = {
      AppleEnabledInputSources = [
        {
          InputSourceKind = "Keyboard Layout";
          "KeyboardLayout ID" = 0;
          "KeyboardLayout Name" = "U.S.";
        }
        {
          "Bundle ID" = "com.apple.inputmethod.SCIM";
          InputSourceKind = "Input Mode";
          "Input Mode" = "com.apple.inputmethod.SCIM.Pinyin";
        }
      ];
      # Use Caps Lock to switch input sources
      AppleFnUsageType = 3;  # 3 = Change Input Source
    };
  };

  # Non-default: custom DNS (Cloudflare instead of DHCP)
  networking.knownNetworkServices = [
    "Wi-Fi"
    "USB 10/100/1000 LAN"
    "Display Ethernet"
    "USB 10/100/1G/2.5G LAN"
    "Thunderbolt Bridge"
    "iPhone USB"
  ];
  networking.dns = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

}
