-- ** Regular settings ** --

-- lazy.nvim pkg manager
require("config.lazy")

-- Enable mouse support
vim.opt.mouse = "a"

-- Enable line numbers
vim.opt.number = true

-- Disable relative line numbers, they confuse me
vim.opt.relativenumber = false

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Catpuccin my beloved
vim.cmd.colorscheme "catppuccin"

-- ** Various eclipse style keybinds (can't get rid of my muscle memory) **--

-- Ctrl+Alt+Up → Duplicate above (yank current line then paste before)
vim.keymap.set("n", "<C-A-Up>", "yyP", { desc = "Duplicate line above" })
vim.keymap.set("i", "<C-A-Up>", "<C-o>yy<C-o>P", { desc = "Duplicate line above" })

-- Ctrl+Alt+Down → Duplicate below (yank current line then paste below)
vim.keymap.set("n", "<C-A-Down>", "yyp", { desc = "Duplicate line below" })
vim.keymap.set("i", "<C-A-Down>", "<C-o>yy<C-o>p", { desc = "Duplicate line below (insert mode)" })

-- Alt+Up → Move line up: delete line, move cursor up one, paste above
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>", { desc = "Move line up" })
vim.keymap.set("i", "<A-Up>", "<C-o>:m .-2<CR>", { desc = "Move line up (insert mode)" })

-- Alt+Down → Move line down: delete line, paste below
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>", { desc = "Move line down" })
vim.keymap.set("i", "<A-Down>", "<C-o>:m .+1<CR>", { desc = "Move line down (insert mode)" })

-- Ctrl+D → Delete current line
vim.keymap.set("n", "<C-d>", "dd", { desc = "Delete current line" })
vim.keymap.set("i", "<C-d>", "<C-o>dd", { desc = "Delete current line (insert mode)" })

-- Ctrl+F → Enter search mode
vim.keymap.set("n", "<C-f>", "/", { desc = "Search in current file" })
vim.keymap.set("i", "<C-f>", "<C-o>/", { desc = "Search in current file (insert mode)" })

-- Ctrl+Shift+F → Enter search & replace mode
vim.keymap.set("n", "<C-S-f>", ":%s/", { desc = "Search and replace in current file" })
vim.keymap.set("i", "<C-S-f>", "<C-o>:%s/", { desc = "Search and replace (insert mode)" })

-- Ctrl+Z → Undo
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo (insert mode)" })

-- Ctrl+Y → Redo
vim.keymap.set("n", "<C-y>", "<C-r>", { desc = "Redo" })
vim.keymap.set("i", "<C-y>", "<C-o><C-r>", { desc = "Redo (insert mode)" })

-- Ctrl+Backspace → Delete the previous word
vim.keymap.set("n", "<C-BS>", "db", { desc = "Delete word before cursor" })
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word before cursor (insert mode)" })

-- Ctrl+L → Prompt for a line number and jump there
function goto_line()
	local lnum = vim.fn.input("Goto line: ")

	if lnum ~= "" then
		vim.cmd(lnum)
	end
end

vim.keymap.set("n", "<C-l>", goto_line, { desc = "Goto line" })
vim.keymap.set("i", "<C-l>", goto_line, { desc = "Goto line" })

-- Ctrl+C → Copies the current line or selected text
vim.keymap.set("n", "<C-c>", '"+yy', { desc = "Copy current line to clipboard" })
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy selection to clipboard (visual mode)" })
vim.keymap.set("i", "<C-c>", '<C-o>"+yy', { desc = "Copy current line to clipboard (insert mode)" })

-- Ctrl+X → Cut current line/selection to clipboard
vim.keymap.set("n", "<C-x>", '"+dd', { desc = "Cut current line to clipboard" })
vim.keymap.set("v", "<C-x>", '"+d', { desc = "Cut selection to clipboard (visual mode)" })
vim.keymap.set("i", "<C-x>", '<C-o>"+dd', { desc = "Cut current line to clipboard (insert mode)" })

-- Ctrl+P → Go to file using fuzzy finding
local telescope = require('telescope.builtin')

vim.keymap.set("n", "<C-p>", telescope.find_files, { desc = "Goto file fuzzy find" })
vim.keymap.set("i", "<C-p>", telescope.find_files, { desc = "Goto file fuzzy find (insert mode)" })

-- Ctrl+H → Launch a workspace search
vim.keymap.set("n", "<C-h>", telescope.live_grep, { desc = "Search workspace" })
vim.keymap.set("i", "<C-h>", telescope.live_grep, { desc = "Search workspace (insert mode)" })

-- Ctrl+O → Open file directly
local function open_file()
	local file = vim.fn.input("Open file: ")

	if file == "" then
		return
	end

	vim.cmd("edit " .. vim.fn.fnameescape(file))
end

vim.keymap.set("n", "<C-o>", open_file, { desc = "Open file fuzzy find" })
vim.keymap.set("i", "<C-o>", open_file, { desc = "Open file fuzzy find (insert mode)" })

-- Ctrl+N → Create a new file
vim.keymap.set("n", "<C-n>", ":enew<CR>", { desc = "Create new file" })
vim.keymap.set("i", "<C-n>", "<C-o>:enew<CR>", { desc = "Create new file (insert mode)" })

-- Ctrl+W → Close the current buffer (similar to closing a tab/file)
vim.keymap.set("n", "<C-w>", ":confirm bd<CR>", { desc = "Close current buffer (confirm if unsaved)" })
vim.keymap.set("i", "<C-w>", "<C-o>:confirm bd<CR>", { desc = "Close current buffer (insert mode)" })

-- Ctrl+S → Save the current buffer (ask for filename if new)
local function save_buffer()
	local bufname = vim.api.nvim_buf_get_name(0)

	if bufname ~= "" then
		vim.cmd("!write")

		return
	end

	local newname = vim.fn.input("Save as: ")

	if newname ~= "" then
		vim.cmd("!write " .. newname)
	else
		vim.notify("Save cancelled", vim.log.levels.INFO)
	end
end

vim.keymap.set("n", "<C-s>", save_buffer, { desc = "Save current buffer" })
vim.keymap.set("i", "<C-s>", save_buffer, { desc = "Save current buffer" })