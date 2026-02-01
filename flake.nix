{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/a9105aa2ce962f1df7125d036163969ba1b52835";
    # nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/release-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-25.11";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nix-modules.url = "github:chelsea6502/nix-modules";
    nix-modules.flake = false;

    sops-nix.url = "github:Mic92/sops-nix";
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
        ({ pkgs, ... }: {
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

              # GitHub token for nix flake updates (avoids API rate limits)
              export NIX_CONFIG="access-tokens = github.com=$(cat ~/.config/sops-nix/secrets/github_api_key 2>/dev/null)"

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

          programs.nixvim = {
            enable = true;

            globals.mapleader = " ";

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
                action = "<cmd>lua vim.lsp.buf./type_definition()<CR>";
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
              ];

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

            colorschemes.gruvbox-material.enable = true;
            extraConfigLua = ''vim.cmd("colorscheme gruvbox-material") '';

          };

          stylix = {
            enable = true;
            autoEnable = true;
            image = null;
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
              AppleFnUsageType = 3; # 3 = Change Input Source
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

        })
      ];
    };
  };
}
