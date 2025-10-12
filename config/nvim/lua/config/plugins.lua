-- lua/config/plugins.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup {
        style = 'darker',
        transparent = true
      }
      -- Enable theme
      vim.cmd.colorscheme("onedark")
    end
  },
  -- Status line
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true
  },
  { 
    "nvim-lualine/lualine.nvim", config = function()
      require("lualine").setup({ options = { theme = "onedark" } })
    end
  },

  -- File explorer
  { 
    "nvim-tree/nvim-tree.lua", config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          highlight_opened_files = "name",
        },
      })      
    end
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      -- Basic configuration
      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.8,
            height = 0.8,
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
          prompt_prefix = "🔍 ",
          selection_caret = "  ",
          entry_prefix = "  ",
          path_display = { "smart" },            color_devicons = true,
          file_ignore_patterns = { "node_modules", ".git/", "dist" },
        },
      })



      -- Optional: Load fzf-native if installed
      local ok, _ = pcall(telescope.load_extension, "fzf")
      if ok then
        print("Telescope FZF extension loaded")
      end
    end
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = vim.fn.executable("make") == 1, -- only build if 'make' exists
    config = function()
      require("telescope").load_extension("fzf")
    end
  },

  -- Treesitter for syntax highlighting
  { 
    "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "html", "css" },
        highlight = { enable = true }
      })
    end
  },

  -- LSP and autocompletion
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Misc tools
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup() end },
  { 'numToStr/Comment.nvim', opts = {} },
  {
    "akinsho/toggleterm.nvim",
    version = "*", -- always keep it updated
    config = function()
      require("toggleterm").setup({
        -- Basic config
        size = 15,
        --open_mapping = [[<C-\>]], -- Ctrl + \
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "tab", -- options: "horizontal", "vertical", "tab", "float"
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 10,
        },
      })
    end,
  }

})

