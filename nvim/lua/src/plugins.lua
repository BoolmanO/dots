-- Плагины которые загружаются Lazy

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      local status_ok, _ = pcall(vim.cmd.colorscheme, "catppuccin")
      if not status_ok then
        return
      end
      require "src.configs.catppuccin"
      -- setup must be called before loading
      vim.cmd.colorscheme "catppuccin"
    end
  },
  {
    'freddiehaddad/feline.nvim',
    opts = {},
    config = function(_, opts)
      local ctp_feline = require('catppuccin.groups.integrations.feline')

      ctp_feline.setup()

      require("feline").setup({
        components = ctp_feline.get(),
      })
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = require("src.mappings.trouble")
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash", "c", "diff", "html", "lua", "luadoc",
        "markdown", "vim", "vimdoc", "python", "rust", "haskell", "javascript"
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim"
    },
    lazy = false, -- потому что всегда использую лол
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          local dflt = require "src.configs.neotree"
          dflt["filesystem"]["hijack_netrw_behavior"] = "open_current"
          require("neo-tree").setup(dflt)
        end
      end
    end,
    config = function()
      require("neo-tree").setup(require("src.configs.neotree"))
    end
  },
  {
    "famiu/bufdelete.nvim"
  },
  {
    "andweeb/presence.nvim",
    lazy = false,
    config = function()
      require "src.configs.discord_rps"
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require "src.configs.indent"
    end
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua_language_server",
        "flake8",
        "black",
        "pyright",
        "mypy",
      }
    },
    config = function()
      require "src.configs.mason"
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require "src.configs.mason-lspconfig"
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "src.configs.lspconfig"
    end
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      require("src.configs.luasnip")
      require("src.configs.cmp")
    end,
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = "InsertEnter",
  --   dependencies = {
  --     {"hrsh7th/cmp-nvim-lsp"},
  --     {
  --       "L3MON4D3/LuaSnip",
  --       dependencies = "rafamadriz/friendly-snippets",
  --       opts = { history = true, updateevents = "TextChanged,TextChangedI" },
  --       config = function(_, opts)
  --         require("luasnip").config.set_config(opts)
  --         require "src.configs.luasnip"
  --       end,
  --     },
  --     -- autopairing of (){}[] etc
  --     {
  --       "windwp/nvim-autopairs",
  --       opts = {
  --         fast_wrap = {},
  --         disable_filetype = { "TelescopePrompt", "vim" },
  --       },
  --       config = function(_, opts)
  --         require("nvim-autopairs").setup(opts)
  --
  --         -- setup cmp for autopairs
  --         local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  --         require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  --       end,
  --     },
  --
  --     -- cmp sources plugins
  --     {
  --       "saadparwaiz1/cmp_luasnip",
  --       "hrsh7th/cmp-nvim-lua",
  --       "hrsh7th/cmp-nvim-lsp",
  --       "hrsh7th/cmp-buffer",
  --       "hrsh7th/cmp-path",
  --     },
  --   },
  --   opts = function()
  --     return require "src.configs.cmp"
  --   end,
  --   config = function(_, opts)
  --     require("cmp").setup(opts)
  --   end,
  -- },
  {
    "stevearc/aerial.nvim",
    config = function()
      require "src.configs.aerial"
    end
  },
  { "lewis6991/gitsigns.nvim" },
  { 'wakatime/vim-wakatime', lazy = false },
  {
    "akinsho/bufferline.nvim",
    after = "catppuccin",
    config = function()
      require "src.configs.bufferline"
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"python"},
    opts = function()
      return require "src.configs.null-ls"
    end,
  },
  {
    "akinsho/toggleterm.nvim", version = "*",
    opts = function()
      return require "src.configs.toggleterm"
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },
  {"xiyaowong/transparent.nvim",
  config = function() return require "src.configs.transparent" end
  },
  {"https://github.com/onsails/lspkind.nvim"}
}
