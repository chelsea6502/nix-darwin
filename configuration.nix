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

  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";
    clipboard.providers.wl-copy.enable = true;

    dependencies.ripgrep.enable = true;

    opts = {
      tabstop = 2; # Number of spaces a tab counts for
      shiftwidth = 2; # Number of spaces for each indentation level
      softtabstop = 2; # Number of spaces a tab counts for when editing
      number = true; # Show line numbers
      colorcolumn = "80"; # Highlight the 80th column
      cursorline = true; # Highlight the current line
      termguicolors = true; # Use GUI colors in terminal
      virtualedit = "onemore"; # Allow cursor to move past the last character
      textwidth = 80; # Maximum width of text being inserted
      relativenumber = true; # Show relative line numbers
      clipboard = "unnamedplus"; # Use system clipboard
      updatetime = 50; # Time in ms before swap file is written
      laststatus = 0; # Never show status line
      cmdheight = 0; # Command line height (0 = hide when not in use)
      ignorecase = true; # Ignore case in search patterns
      smartcase = true; # Override ignorecase when pattern has uppercase
      scrolloff = 10; # Min number of lines to keep above/below cursor
      undofile = true; # Save undo history to a file
      undodir = "/tmp/.vim-undo-dir"; # Directory to store undo files
    };

    keymaps = [
      {
        action = "1<C-u>";
        key = "<ScrollWheelUp>";
      }
      {
        action = "1<C-d>";
        key = "<ScrollWheelDown>";
      }
      {
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        key = "<leader>a";
      }
      {
        action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
        key = "<leader>s";
      }
      {
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        key = "<leader>d";
      }
      {
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        key = "<leader>f";
      }
      {
        action = "<cmd>Telescope file_browser<CR>";
        key = "ft";
      }
      {
        action = "<cmd>Telescope find_files<CR>";
        key = "ff";
      }
      {
        action = "<cmd>Telescope project<CR>";
        key = "FF";
      }
      {
        action = "<cmd>Telescope current_buffer_fuzzy_find theme=dropdown<CR>";
        key = "/";
      }
      {
        action = "<cmd>AvanteChat<CR>";
        key = "<leader>ac";
      }
      {
        action = "<cmd>AvanteChatNew<CR>";
        key = "<leader>aC";
      }
      {
        action = "<cmd>Gitsigns reset_hunk<CR>";
        key = "<leader>gr";
      }
      {
        action = "<cmd>Gitsigns reset_buffer<CR>";
        key = "<leader>gR";
      }
      {
        action = "<cmd>LazyGit<CR>";
        key = "<leader>gg";
      }
      {
        action = "<cmd>ToggleTerm<CR>";
        key = "t";
      }
      {
        action = "<cmd>WhichKey<CR>";
        key = "<leader>w";
      }
    ];

    plugins = {
      which-key.enable = true;

      indent-blankline.enable = true;
      indent-blankline.settings.indent.char = "▏";
      indent-blankline.settings.scope.enabled = false;
      mini.enable = true;
      mini.modules.indentscope.symbol = "▏";
      mini.modules.indentscope.options.try_as_border = true;
      mini.modules.indentscope.draw.delay = 0;

      mini.modules.pairs.enable = true;

      gitsigns.enable = true;

      blink-cmp.enable = true;
      blink-cmp.settings.keymap = {
        "<Tab>" = [
          "select_next"
          "fallback"
        ];
        "<S-Tab>" = [
          "select_prev"
          "fallback"
        ];
        "<Enter>" = [
          "accept"
          "fallback"
        ];
      };
      blink-cmp.settings.signature.enabled = true;
      blink-cmp.settings.completion.documentation.auto_show = true;
      blink-cmp.settings.completion.list.selection.preselect = false;
      blink-cmp.settings.sources.default = [
        "lsp"
        "path"
        "buffer"
        "snippets"
        # "copilot"
      ];
      # blink-cmp.settings.sources.providers.copilot = {
      # async = true;
      # module = "blink-copilot";
      # name = "copilot";
      # score_offset = 100;
      # };

      # blink-copilot.enable = true;

      # aider-nvim.enable = true;
      avante.enable = true;
      avante.settings.hints.enabled = false;
      avante.settings.providers.claude.model = "claude-sonnet-4-20250514";

      typescript-tools.enable = true;

      treesitter.enable = true;
      treesitter.settings.auto_install = true;
      treesitter.settings.highlight.enable = true;

      lsp.enable = true;
      lsp-format.enable = true;
      lsp.servers.nil_ls.enable = true;
      lsp.servers.nil_ls.settings.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
      lsp.servers.nil_ls.settings.nix.flake.autoArchive = true;
      lsp.servers.nil_ls.settings.nix.flake.autoEvalInputs = true;

      telescope.enable = true;
      telescope.extensions.file-browser.enable = true;

      noice.enable = true;
      web-devicons.enable = true;

      toggleterm.enable = true;
      toggleterm.settings.direction = "float";

      lazygit.enable = true;

      no-neck-pain.enable = true;
      no-neck-pain.settings.autocmds.enableOnVimEnter = true;
      no-neck-pain.settings.autocmds.skipEnteringNoNeckPainBuffer = true;
      no-neck-pain.settings.options.width = 100;
      no-neck-pain.settings.options.minSideBufferWidth = 100;
      no-neck-pain.settings.buffers.right.enabled = false;
      no-neck-pain.settings.buffers.wo.fillchars = "vert: ,eob: ";
    };

    # colorschemes.gruvbox-material.enable = true;

    extraPlugins = with pkgs.vimPlugins; [ gruvbox-material ];

    # Nui and Avante are old versions
    extraConfigLua = ''
      vim.deprecate = function() end
      vim.cmd("colorscheme gruvbox-material")
    '';
  };

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
