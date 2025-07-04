{ pkgs, ... }:
{
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
      action = "<cmd>Telescope file_browser<CR>";
      key = "t";
    }
    {
      mode = "n";
      action = "<cmd>Telescope find_files<CR>";
      key = "ff";
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
    {
      mode = "n";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      key = "<leader>gr";
    }
    {
      mode = "n";
      action = "<cmd>Gitsigns reset_buffer<CR>";
      key = "<leader>gR";
    }
  ];

  plugins = {

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
    blink-cmp.settings.sources = {
      default = [
        "lsp"
        "path"
        "buffer"
        "snippets"
        "copilot"
      ];

      providers.copilot = {
        async = true;
        module = "blink-copilot";
        name = "copilot";
        score_offset = 100;
      };
    };

    blink-copilot.enable = true;

    avante.enable = true;
    avante.settings.hints.enable = false;
    avante.settings.providers.claude.model = "claude-3-7-sonnet-20250219";

    typescript-tools.enable = true;

    treesitter.enable = true;
    treesitter.settings.auto_install = true;
    treesitter.settings.highlight.enable = true;

    lsp.enable = true;
    lsp.onAttach = ''
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    '';

    lsp.servers.nil_ls.enable = true;
    lsp.servers.nil_ls.settings.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];

    lsp.servers.clangd.enable = true;

    telescope.enable = true;
    telescope.extensions.project.enable = true;
    telescope.extensions.file-browser.enable = true;

    noice.enable = true;
    web-devicons.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    no-neck-pain-nvim
    gruvbox-material
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
