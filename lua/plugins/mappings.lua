return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<leader>fw"] = { function() require("fff").live_grep() end, desc = "Find words" },
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
          ["K"] = { function() vim.lsp.buf.hover() end, desc = "LSP hover" },
          ["gd"] = { function() vim.lsp.buf.definition() end, desc = "Go to definition" },
          ["gi"] = {
            function() require("telescope.builtin").lsp_references { path_display = { "relative" } } end,
            desc = "Find references",
          },
          ["<leader>r"] = { function() vim.lsp.buf.rename() end, desc = "LSP rename" },
          ["<leader>gn"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" },
          ["<leader><S-k>"] = { function() vim.diagnostic.open_float() end, desc = "Show cursor diagnostics" },
          ["<leader>y"] = {
            function()
              -- local path = vim.fn.expand "%:p"
              local path = vim.fn.expand "%:~:."
              vim.fn.setreg("+", path)
            end,
          },
          ["<C-j>"] = "<down>",
          ["<C-k>"] = "<up>",
          ["<leader>c"] = "",
          ["-"] = function() require("oil").open_float() end,
          ["<leader>fl"] = {
            function() vim.cmd("!biome check --write --unsafe " .. vim.fn.shellescape(vim.fn.expand "%:p")) end,
            desc = "Biome format current file",
          },
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
          K = { function() vim.lsp.buf.hover() end, desc = "LSP hover" },
          gd = { function() vim.lsp.buf.definition() end, desc = "Go to definition" },
          ["<leader>r"] = { function() vim.lsp.buf.rename() end, desc = "LSP rename" },
          ["<leader>fw"] = { function() require("fff").live_grep() end, desc = "Find words" },
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
