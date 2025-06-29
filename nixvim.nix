{ pkgs, ... }: {
  enable = true;

  globals.mapleader = " ";

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
    fillchars = { vert = "\\"; };
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
  ];

  clipboard.providers.wl-copy.enable = true;
  plugins = {
    lsp-format.enable = true;
    nvim-autopairs.enable = true;

    indent-blankline.enable = true;
    indent-blankline.settings.indent.char = "▏";

    typescript-tools.enable = true;

    gitsigns.enable = true;
    gitsigns.settings.signs = {
      add.text = "▎";
      change.text = "▎";
      delete.text = "";
      topdelete.text = "";
      changedelete.text = "▎";
      untracked.text = "▎";
    };

    none-ls.enable = true;
    none-ls.enableLspFormat = true;
    none-ls.sources.formatting.nixfmt.enable = true;
    none-ls.sources.formatting.stylua.enable = true;
    none-ls.sources.formatting.clang_format.enable = true;

    treesitter.enable = true;
    treesitter.settings.auto_install = true;
    treesitter.settings.highlight.enable = true;

    lsp.enable = true;
    lsp.servers.nil_ls.enable = true;
    lsp.servers.nil_ls.settings.nix.maxMemoryMB = 15000;
    lsp.servers.nil_ls.settings.nix.flake.autoArchive = true;
    lsp.servers.nil_ls.settings.nix.flake.autoEvalInputs = true;

    telescope.enable = true;
    telescope.extensions.project.enable = true;

    noice.enable = true;

    web-devicons.enable = true;
  };

  extraPlugins = with pkgs; [
    vimPlugins.no-neck-pain-nvim
    vimPlugins.gruvbox-material
  ];

  extraConfigLua = ''
    vim.cmd("colorscheme gruvbox-material")
    require("no-neck-pain").setup({
    	autocmds = { enableOnVimEnter = true, skipEnteringNoNeckPainBuffer = true },
    	options = { width = 100, minSideBufferWidth = 100 },
    	buffers = { right = { enabled = false }, wo = { fillchars = "vert: ,eob: " } },
    })
  '';
}
