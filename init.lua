vim.o.modifiable = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.nvim_tree_follow = 1

require("config.lazy")
require("keybinds")

-- ** Regular settings ** --

-- Enable mouse support
vim.opt.mouse = "a"

-- Enable line numbers
vim.opt.number = true

-- Disable relative line numbers, they confuse me
vim.opt.relativenumber = false

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Enable true colors for a richer color palette (important for many themes)
vim.opt.termguicolors = true

-- Highlight the current line
vim.opt.cursorline = true

-- Ensure encoding is set
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Hide command line by default
vim.opt.cmdheight = 0

-- Wrap to next line when navigating
vim.opt.whichwrap:append "<,>,h,l"
