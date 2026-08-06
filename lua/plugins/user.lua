---@type LazySpec
return {
  -- Disable satellite.nvim due to conflict with buffer close
  { "lewis6991/satellite.nvim", enabled = false },
  {
    "echasnovski/mini.move",
    keys = function(_, keys)
      local plugin = require("lazy.core.config").spec.plugins["mini.move"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false) -- resolve mini.clue options
      -- Populate the keys based on the user's options
      local mappings = {
        { opts.mappings.line_left, desc = "Move line left" },
        { opts.mappings.line_right, desc = "Move line right" },
        { opts.mappings.line_down, desc = "Move line down" },
        { opts.mappings.line_up, desc = "Move line up" },
        { opts.mappings.left, desc = "Move selection left", mode = "v" },
        { opts.mappings.right, desc = "Move selection right", mode = "v" },
        { opts.mappings.down, desc = "Move selection down", mode = "v" },
        { opts.mappings.up, desc = "Move selection up", mode = "v" },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        left = "<S-h>",
        right = "<S-l>",
        down = "<S-j>",
        up = "<S-k>",
        line_left = "<A-h>",
        line_right = "<A-l>",
        line_down = "<A-j>",
        line_up = "<A-k>",
      },
    },
    specs = {
      {
        "catppuccin",
        optional = true,
        ---@type CatppuccinOptions
        opts = { integrations = { mini = true } },
      },
    },
  },
  { "wakatime/vim-wakatime", lazy = false },
  -- {
  --   "fiqryq/wakastat.nvim",
  --   event = "VeryLazy",
  --   cmd = { "WakastatRefresh", "WakastatStatus" },
  --   opts = {
  --     args = { "--today" }, -- or "--week", "--month"
  --     format = "Today Coding Time: %s", -- %s replaced with time
  --     update_interval = 300, -- seconds between updates
  --     enable_timer = true,
  --   },
  --   config = function(_, opts) require("wakastat").setup(opts) end,
  --
  --   specs = {
  --     {
  --       "rebelot/heirline.nvim",
  --       optional = true,
  --       opts = function(_, opts)
  --         opts.statusline = opts.statusline or {}
  --         table.insert(opts.statusline, 5, { -- insert at position 5
  --           provider = function() return " " .. require("wakastat").status() .. " " end,
  --           hl = "Wakastat",
  --           update = { "User", pattern = "WakastatUpdated" },
  --         })
  --       end,
  --     },
  --   },
  -- },
  {
    "ruifm/gitlinker.nvim",
    event = "VeryLazy",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("gitlinker").setup {
        opts = {
          -- remote = 'github', -- force the use of a specific remote
          -- adds current line nr in the url for normal mode
          add_current_line_on_normal_mode = true,
          -- callback for what to do with the url
          action_callback = require("gitlinker.actions").copy_to_clipboard,
          -- print the url after performing the action
          print_url = true,
          -- mapping to call url generation
        },
        mappings = "<leader>gy",
        callbacks = {
          ["github.com"] = require("gitlinker.hosts").get_github_type_url,
          ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
        },
      }
    end,
  },
  {
    "theprimeagen/harpoon",
    opts = {},
    event = "VeryLazy",
  },

  -- { import = "nvchad.blink.lazyspec" },
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     keymaps = {
  --       accept_suggestion = "<C-y>",
  --       clear_suggestion = "<C-e>",
  --     },
  --     log_level = "warn",
  --     disable_inline_completion = false, -- disables inline completion for use with cmp
  --     disable_keymaps = false, -- disables built in keymaps for more manual control
  --   },
  -- },
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    enabled = true,
    cmd = "Oil",
    config = function()
      require("oil").setup {
        default_file_explorer = false,
        buf_options = {
          buflisted = false,
          bufhidden = "delete",
        },
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
        },

        float = {
          -- Padding around the floating window
          padding = 10,
          max_width = 100,
          max_height = 0,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          -- preview_split: Split direction: "auto", "left", "right", "above", "below".
          preview_split = "auto",
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          override = function(conf) return conf end,
        },
        -- Configuration for the actions floating preview window
        preview = {
          -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_width and max_width can be a single value or a list of mixed integer/float types.
          -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
          max_width = 0.9,
          -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
          min_width = { 40, 0.4 },
          -- optionally define an integer/float for the exact width of the preview window
          width = nil,
          -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_height and max_height can be a single value or a list of mixed integer/float types.
          -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
          max_height = 0.9,
          -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
          min_height = { 5, 0.1 },
          -- optionally define an integer/float for the exact height of the preview window
          height = nil,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          -- Whether the preview window is automatically updated when the cursor is moved
          update_on_cursor_moved = true,
        },
      }
    end,
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
  },
  {
    "kylechui/nvim-surround",
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
  },
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   lazy = false,
  --   build = ":AvanteBuild",
  --   cmd = {
  --     "AvanteAsk",
  --     "AvanteBuild",
  --     "AvanteEdit",
  --     "AvanteRefresh",
  --     "AvanteSwitchProvider",
  --     "AvanteChat",
  --     "AvanteToggle",
  --     "AvanteClear",
  --   },
  --   dependencies = {
  --     "stevearc/dressing.nvim", -- for input provider dressing
  --     "folke/snacks.nvim", -- for input provider snacks
  --
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     --- The below dependencies are optional,
  --     "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     { -- if copilot.lua is available, default to copilot provider
  --       "zbirenbaum/copilot.lua",
  --       optional = true,
  --       specs = {
  --         {
  --           "yetone/avante.nvim",
  --           opts = {
  --             provider = "copilot",
  --             auto_suggestions_provider = "copilot",
  --           },
  --         },
  --       },
  --     },
  --     {
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       optional = true,
  --       ft = { "markdown", "Avante" },
  --       opts = function(_, opts)
  --         if not opts.file_types then opts.file_types = { "markdown" } end
  --         opts.file_types = require("astrocore").list_insert_unique(opts.file_types, { "Avante" })
  --       end,
  --     },
  --     {
  --       -- make sure `Avante` is added as a filetype
  --       "OXY2DEV/markview.nvim",
  --       optional = true,
  --       opts = function(_, opts)
  --         if not opts.filetypes then opts.filetypes = { "markdown", "quarto", "rmd" } end
  --         opts.filetypes = require("astrocore").list_insert_unique(opts.filetypes, { "Avante" })
  --       end,
  --     },
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       "AstroNvim/astrocore",
  --       opts = function(_, opts)
  --         local maps = assert(opts.mappings)
  --         local prefix = "<Leader>a"
  --
  --         maps.n[prefix] = { desc = "Avante functionalities" }
  --
  --         maps.n[prefix .. "a"] = { function() require("avante.api").ask() end, desc = "Avante ask" }
  --
  --         maps.v[prefix .. "r"] = { function() require("avante.api").refresh() end, desc = "Avante refresh" }
  --
  --         maps.n[prefix .. "e"] = { function() require("avante.api").edit() end, desc = "Avante edit" }
  --       end,
  --     },
  --   },
  --   ---@module 'avante'
  --   ---@type avante.Config
  --   opts = {
  --     -- add any opts here
  --     -- for example
  --     provider = "claude",
  --     providers = {
  --       claude = {
  --         endpoint = "https://api.anthropic.com",
  --         -- claude-opus-4-20250514
  --         model = "claude-sonnet-4-20250514",
  --         extra_request_body = {
  --           temperature = 0.2,
  --           max_tokens = 20480,
  --         },
  --       },
  --     },
  --   },
  --   specs = { -- configure optional plugins
  --     { "AstroNvim/astroui", opts = { icons = { Avante = "" } } },
  --   },
  -- },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = {
      { "AstroNvim/astroui", opts = { icons = { Trouble = "󱍼" } } },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>d"
          maps.n[prefix .. "T"] = { "<Cmd>Trouble diagnostics toggle<CR>", desc = "Trouble Workspace Diagnostics" }
          maps.n[prefix .. "t"] =
            { "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble Document Diagnostics" }
        end,
      },
    },
    opts = function()
      local get_icon = require("astroui").get_icon
      local lspkind_avail, lspkind = pcall(require, "lspkind")
      return {
        keys = {
          ["<ESC>"] = "close",
          ["q"] = "close",
          ["<C-E>"] = "close",
        },
        icons = {
          indent = {
            fold_open = get_icon "FoldOpened",
            fold_closed = get_icon "FoldClosed",
          },
          folder_closed = get_icon "FolderClosed",
          folder_open = get_icon "FolderOpen",
          kinds = lspkind_avail and lspkind.symbol_map,
        },
      }
    end,
    specs = {
      { "lewis6991/gitsigns.nvim", optional = true, opts = { trouble = true } },
      {
        "folke/edgy.nvim",
        optional = true,
        opts = function(_, opts)
          if not opts.bottom then opts.bottom = {} end
          table.insert(opts.bottom, "Trouble")
        end,
      },
      {
        "catppuccin",
        optional = true,
        ---@type CatppuccinOptions
        opts = { integrations = { lsp_trouble = true } },
      },
    },
  },
  -- This is a change to the autocomplete to make it borderless
  -- {
  --   "hrsh7th/nvim-cmp",
  --   optional = true,
  --   opts = function(_, opts)
  --     -- local cmp = require "cmp"
  --     opts.window = {
  --       completion = { -- rounded border; thin-style scrollbar
  --         border = nil,
  --         scrollbar = "",
  --       },
  --       documentation = { -- no border; native-style scrollbar
  --         border = nil,
  --         scrollbar = "",
  --         -- other options
  --       },
  --     }
  --     -- opts.window = cmp.mapping.select_next_item()
  --   end,
  -- },
  {
    "azabiong/vim-highlighter",
    lazy = false, -- Not Lazy by default
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              [">n"] = { "<Cmd>Hi><CR>", desc = "Next Recently Set Highlight" },
              ["<n"] = { "<Cmd>Hi<<CR>", desc = "Previous Recently Set Highlight" },
            },
          },
        },
      },
    },
  },
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      -- this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      require("fff.download").download_or_build_binary()
    end,
    -- if you are using nixos
    -- build = "nix run .#release",
    opts = { -- (optional)
      debug = {
        enabled = true, -- we expect your collaboration at least during the beta
        show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
      },
    },
    -- No need to lazy-load with lazy.nvim.
    -- This plugin initializes itself lazily.
    lazy = false,
    keys = {
      {
        "<leader>ff",
        function() require("fff").find_files() end,
        desc = "Find files",
      },
      {
        "<leader>fw",
        function()
          require("fff").live_grep {
            grep = {
              modes = { "fuzzy", "plain", "regex" },
            },
          }
        end,
        desc = "Find words",
      },
    },
  },
}
