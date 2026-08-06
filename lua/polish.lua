-- Git signs setup
require("gitsigns").setup {
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 0,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "      <author>, <author_time:%R> (<summary>)",
}
require("ibl").setup {
  scope = { enabled = false },
  indent = {
    char = "",
  },
}
-- Telescope ignore large fileslocal previewers = require('telescope.previewers')
local previewers = require "telescope.previewers"
local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.fnamemodify(filepath, ":p")
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end
require("telescope").setup {
  defaults = {
    buffer_previewer_maker = new_maker,
    path_display = function(_, path)
      -- Convert absolute paths to relative
      local cwd = vim.fn.getcwd() .. "/"
      if path:sub(1, #cwd) == cwd then path = path:sub(#cwd + 1) end
      local cols = vim.o.columns
      local n
      if cols < 120 then
        n = 2
      elseif cols < 180 then
        n = 3
      else
        n = 4
      end
      local parts = {}
      for part in string.gmatch(path, "[^/]+") do
        table.insert(parts, part)
      end
      if #parts <= n * 2 then return path end
      local head = table.concat(parts, "/", 1, n)
      local tail = table.concat(parts, "/", #parts - n + 1)
      return head .. "/.../" .. tail
    end,
  },
}

-- Remove notify notifications
vim.notify = function(_, _, _) end
local notify = require "notify"
local currNot = vim.notify
if currNot == notify then vim.notify = function(_, _, _) end end

vim.opt.relativenumber = false
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.cmd.colorscheme "tokyonight-night"
