return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<leader>fw"] = { function() require("telescope").extensions.live_grep_args.live_grep_args() end },
          ["<S-l>"] = { function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end },
          ["<S-h>"] = { function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end },
          ["<leader>x"] = {
            function() require("astrocore.buffer").close() end,
            desc = "Close buffer",
            noremap = true,
            nowait = true, -- This is the key setting to remove delay
          },

          -- Remove the conflicting mappings
          ["<leader>xl"] = false,
          ["<leader>xq"] = false,

          ["<leader>ap"] = { function() require("harpoon.mark").add_file() end },
          ["<leader>am"] = { function() require("harpoon.ui").toggle_quick_menu() end },
          ["<leader>1"] = function() require("harpoon.ui").nav_file(1) end,
          ["<leader>2"] = function() require("harpoon.ui").nav_file(2) end,
          ["<leader>3"] = function() require("harpoon.ui").nav_file(3) end,
          ["<leader>4"] = function() require("harpoon.ui").nav_file(4) end,
          ["K"] = "<cmd>Lspsaga hover_doc<CR>",
          ["gd"] = "<cmd>Lspsaga goto_definition<CR>",
          ["gi"] = "<cmd>Lspsaga finder<CR>",

          ["<leader>y"] = {
            function()
              -- local path = vim.fn.expand "%:p"
              local path = vim.fn.expand "%:~:."
              vim.fn.setreg("+", path)
            end,
          },
          ["<leader>r"] = "<cmd>Lspsaga rename<CR>",
          ["<leader>gn"] = "<cmd>Lspsaga diagnostic_jump_next<CR>",
          ["<leader><S-k>"] = "<cmd>Lspsaga show_cursor_diagnostics<CR>",
          ["<C-j>"] = "<down>",
          ["<C-k>"] = "<up>",
          ["<leader>c"] = "",
          ["-"] = function() require("oil").open_float() end,
        },
        -- v = {
        --   ["J"] = { ":m '>+1<CR>gv=gv" },
        --   ["K"] = { ":m '<-2<CR>gv=gv" },
        --   ["D"] = { "_D" },
        -- },
        t = {
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          K = "<cmd>Lspsaga hover_doc<CR>",
          gd = "<cmd>Lspsaga goto_definition<CR>",
          ["<leader>r"] = "<cmd>Lspsaga rename<CR>",
          ["<leader>fw"] = { function() require("telescope").extensions.live_grep_args.live_grep_args() end },
          ["<leader>gc"] = {
            function()
              local previewers = require "telescope.previewers"
              local builtin = require "telescope.builtin"
              local M = {}

              local delta = previewers.new_termopen_previewer {
                get_command = function(entry)
                  return {
                    "git",
                    "-c",
                    "core.pager=delta",
                    "-c",
                    "delta.side-by-side=false",
                    "-c",
                    "delta.line-numbers=true",
                    "diff",
                    entry.value .. "^!",
                    "--",
                    entry.current_file,
                  }
                end,
              }

              M.my_git_bcommits = function(opts)
                opts = opts or {}
                opts.previewer = {
                  delta,
                  previewers.git_commit_message.new(opts),
                  previewers.git_commit_diff_as_was.new(opts),
                }

                builtin.git_bcommits(opts)
              end

              return M.my_git_bcommits()
            end,
            desc = "Git commits",
          },
          ["<leader>gC"] = {
            function() require("telescope.builtin").git_bcommits { use_file_path = true } end,
            desc = "Git commits (current file)",
          },
          ["<leader>gt"] = {
            function()
              local previewers = require "telescope.previewers"
              local builtin = require "telescope.builtin"
              local M = {}
              local delta = previewers.new_termopen_previewer {
                get_command = function(entry)
                  if entry.status == "??" or entry.status == "A " then
                    return {
                      "git",
                      "-c",
                      "core.pager=delta",
                      "-c",
                      "delta.side-by-side=false",
                      "-c",
                      "delta.line-numbers=true",
                      "diff",
                      -- "HEAD",
                      "--",
                      "/dev/null",
                      entry.path,
                    }
                  end

                  return {
                    "git",
                    "-c",
                    "core.pager=delta",
                    "-c",
                    "delta.side-by-side=false",
                    "-c",
                    "delta.line-numbers=true",
                    "diff",
                    "HEAD",
                    "--",
                    entry.path,
                  }
                end,
              }
              M.delta_git_status = function(opts)
                opts = opts or {}
                opts.previewer = delta

                builtin.git_status(opts)
              end

              return M.delta_git_status()
            end,
            desc = "Git status",
          },
        },
      },
    },
  },
}
