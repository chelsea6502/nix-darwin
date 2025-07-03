{ pkgs, ... }: {
  enable = true;

  globals.mapleader = " ";
  clipboard.providers.wl-copy.enable = true;

  opts = {
    background = "dark";
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;
    number = true;
    colorcolumn = "80";
    cursorline = true;
    termguicolors = true;
    virtualedit = "onemore";
    textwidth = 80;
    relativenumber = true;
    clipboard = "unnamedplus";
    fillchars.vert = "\\";
    updatetime = 50;
    ruler = false;
    showcmd = false;
    laststatus = 0;
    cmdheight = 0;
    incsearch = true;
    ignorecase = true;
    smartcase = true;
    scrolloff = 10;
    autoread = true;
    undofile = true;
    undodir = "/tmp/.vim-undo-dir";
    backupdir = ".nvim-history";
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
      mode = "n";
      action = "<cmd>lua vim.lsp.buf.hover()<CR>";
      key = "<leader>a";
    }
    {
      mode = "n";
      action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
      key = "<leader>s";
    }
    {
      mode = "n";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      key = "<leader>d";
    }
    {
      mode = "n";
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
      key = "<leader>f";
    }
    {
      mode = "n";
      action = "<cmd>Telescope project<CR>";
      key = "FF";
    }
    {
      mode = "n";
      action = "<cmd>Telescope current_buffer_fuzzy_find theme=dropdown<CR>";
      key = "/";
    }
    {
      mode = "n";
      action = "<cmd>AvanteChat<CR>";
      key = "<leader>ac";
    }
    {
      mode = "n";
      action = "<cmd>AvanteChatNew<CR>";
      key = "<leader>aC";
    }
  ];

  plugins = {
    nvim-autopairs.enable = true;

    indent-blankline.enable = true;
    indent-blankline.settings.indent.char = "▏";
    indent-blankline.settings.scope.enabled = false;
    mini.enable = true;
    mini.modules.indentscope.symbol = "▏";
    mini.modules.indentscope.options.try_as_border = true;
    mini.modules.indentscope.draw.delay = 0;

    gitsigns.enable = true;
    gitsigns.settings.signs.add.text = "▎";
    gitsigns.settings.signs.change.text = "▎";
    gitsigns.settings.signs.delete.text = "";
    gitsigns.settings.signs.topdelete.text = "";
    gitsigns.settings.signs.changedelete.text = "▎";
    gitsigns.settings.signs.untracked.text = "▎";

    blink-cmp.settings.keymap.preset = "enter";
    blink-cmp.settings.completion.documentation.auto_show = true;
    blink-cmp.settings.signature.enabled = true;

    luasnip.enable = true;
    blink-copilot.enable = true;

    blink-cmp.enable = true;
    blink-cmp.settings.sources = {
      default = [ "lsp" "path" "buffer" "snippets" "copilot" ];

      providers.copilot = {
        async = true;
        module = "blink-copilot";
        name = "copilot";
        score_offset = 100;
      };
    };

    avante.enable = true;
    avante.settings.hints.enable = false;
    avante.settings.providers.claude.model = "claude-3-7-sonnet-20250219";

    lsp.onAttach = ''
      -- Enable formatting on save for all LSP clients
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    '';

    typescript-tools.enable = true;

    treesitter.enable = true;
    treesitter.settings.auto_install = true;
    treesitter.settings.highlight.enable = true;

    lsp.enable = true;
    lsp.servers.nil_ls.enable = true;
    lsp.servers.nil_ls.settings.nix.maxMemoryMB = 15000;
    lsp.servers.nil_ls.settings.nix.flake.autoArchive = true;
    lsp.servers.nil_ls.settings.nix.flake.autoEvalInputs = true;
    lsp.servers.nil_ls.settings.formatting.command =
      [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];

    lsp.servers.clangd.enable = true;
    lsp.servers.clangd.settings.fallbackFlags = [ "-std=c++17" ];

    telescope.enable = true;
    telescope.extensions.project.enable = true;

    noice.enable = true;
    web-devicons.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [ no-neck-pain-nvim gruvbox-material ];

  extraConfigLua = ''
    vim.cmd("colorscheme gruvbox-material")
    require("no-neck-pain").setup({
    	autocmds = { enableOnVimEnter = true, skipEnteringNoNeckPainBuffer = true },
    	options = { width = 100, minSideBufferWidth = 100 },
    	buffers = { right = { enabled = false }, wo = { fillchars = "vert: ,eob: " } },
    })
  '';
}
