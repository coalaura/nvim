local telescope = require("telescope")
local builtin = require("telescope.builtin")
local adapter = require("cd-project.adapter")
local api = require("cd-project.api")

function goto_line()
	local lnum = vim.fn.input("Goto line: ")

	if lnum ~= "" then
		vim.cmd(lnum)
	end
end

local function save_buffer()
	local bufname = vim.api.nvim_buf_get_name(0)

	if bufname ~= "" then
		vim.cmd("w!")

		return
	end

	local newname = vim.fn.input("Save as: ")

	if newname ~= "" then
		vim.cmd("w! " .. newname)
	else
		vim.notify("Save cancelled", vim.log.levels.INFO)
	end
end

function add_current_project()
	api.add_current_project({
		show_duplicate_hints = true
	})
end

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

-- Ctrl+Alt+F → Enter search & replace mode
vim.keymap.set("n", "<C-M-f>", ":%s/", { desc = "Search and replace in current file" })
vim.keymap.set("i", "<C-M-f>", "<C-o>:%s/", { desc = "Search and replace (insert mode)" })

-- Ctrl+Z → Undo
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo (insert mode)" })

-- Ctrl+Y → Redo
vim.keymap.set("n", "<C-y>", "<C-r>", { desc = "Redo" })
vim.keymap.set("i", "<C-y>", "<C-o><C-r>", { desc = "Redo (insert mode)" })

-- Ctrl+Backspace → Delete the previous word
vim.keymap.set("n", "<C-BS>", "db", { desc = "Delete word before cursor" })
vim.keymap.set("i", "<C-BS>", "<C-o>db", { desc = "Delete word before cursor (insert mode)" })

-- Ctrl+L → Prompt for a line number and jump there
vim.keymap.set("n", "<C-l>", goto_line, { desc = "Goto line" })
vim.keymap.set("i", "<C-l>", goto_line, { desc = "Goto line" })

-- Ctrl+C → Copies the current line or selected text
vim.keymap.set("n", "<C-c>", 'yy', { desc = "Copy selection to clipboard" })
vim.keymap.set("v", "<C-c>", 'y', { desc = "Copy selection to clipboard (visual mode)" })
vim.keymap.set("i", "<C-c>", '<C-o>yy', { desc = "Copy selection to clipboard (insert mode)" })

-- Ctrl+X → Cut current line/selection to clipboard
vim.keymap.set("n", "<C-x>", 'dd', { desc = "Cut selection to clipboard" })
vim.keymap.set("v", "<C-x>", 'd', { desc = "Cut selection to clipboard (visual mode)" })
vim.keymap.set("i", "<C-x>", '<C-o>dd', { desc = "Cut selection to clipboard (insert mode)" })

-- Ctrl+C → Copies the current line or selected text
vim.keymap.set("n", "<C-v>", 'p', { desc = "Paste clipboard" })
vim.keymap.set("v", "<C-v>", 'p', { desc = "Paste clipboard (visual mode)" })
vim.keymap.set("i", "<C-v>", '<C-o>p', { desc = "Paste clipboard (insert mode)" })

-- Ctrl+P → Go to file using fuzzy finding
vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Goto file fuzzy find" })
vim.keymap.set("v", "<C-p>", builtin.find_files, { desc = "Goto file fuzzy find (visual mode)" })
vim.keymap.set("i", "<C-p>", builtin.find_files, { desc = "Goto file fuzzy find (insert mode)" })

-- Ctrl+H → Launch a workspace search
vim.keymap.set("n", "<C-h>", builtin.live_grep, { desc = "Search workspace" })
vim.keymap.set("v", "<C-h>", builtin.live_grep, { desc = "Search workspace (visual mode)" })
vim.keymap.set("i", "<C-h>", builtin.live_grep, { desc = "Search workspace (insert mode)" })

-- Ctrl+R → Open recent projects
vim.keymap.set("n", "<C-r>", adapter.cd_project, { desc = "Open recent projects" })
vim.keymap.set("v", "<C-r>", adapter.cd_project, { desc = "Open recent projects (visual mode)" })
vim.keymap.set("i", "<C-r>", adapter.cd_project, { desc = "Open recent projects (insert mode)" })

-- Alt+R → Add current project
vim.keymap.set("n", "<M-r>", add_current_project, { desc = "Add current project" })
vim.keymap.set("v", "<M-r>", add_current_project, { desc = "Add current project (visual mode)" })
vim.keymap.set("i", "<M-r>", add_current_project, { desc = "Add current project (insert mode)" })

-- Ctrl+Alt+R → Add project
vim.keymap.set("n", "<C-M-r>", adapter.manual_cd_project, { desc = "Add project" })
vim.keymap.set("v", "<C-M-r>", adapter.manual_cd_project, { desc = "Add project (visual mode)" })
vim.keymap.set("i", "<C-M-r>", adapter.manual_cd_project, { desc = "Add project (insert mode)" })

-- Ctrl+N → Create a new file
vim.keymap.set("n", "<C-n>", ":enew<CR>", { desc = "Create new file" })
vim.keymap.set("v", "<C-n>", "<C-o>:enew<CR>", { desc = "Create new file (visual mode)" })
vim.keymap.set("i", "<C-n>", "<C-o>:enew<CR>", { desc = "Create new file (insert mode)" })

-- Ctrl+W → Close the current buffer
vim.keymap.set("n", "<C-w>", ":confirm bd!<CR>", { desc = "Close current buffer" })
vim.keymap.set("v", "<C-w>", "<C-o>:confirm bd!<CR>", { desc = "Close current buffer (visual mode)" })
vim.keymap.set("i", "<C-w>", "<C-o>:confirm bd!<CR>", { desc = "Close current buffer (insert mode)" })

-- These slow ctrl+w down :(
vim.keymap.del("n", "<C-w>d")
vim.keymap.del("n", "<C-w><C-d>")

-- Ctrl+S → Save the current buffer (ask for filename if new)
vim.keymap.set("n", "<C-s>", save_buffer, { desc = "Save current buffer" })
vim.keymap.set("v", "<C-s>", save_buffer, { desc = "Save current buffer" })
vim.keymap.set("i", "<C-s>", save_buffer, { desc = "Save current buffer" })

-- Ctrl+B → Toggle file manager
vim.api.nvim_set_keymap("n", "<C-b>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("v", "<C-b>", "<C-o>:NvimTreeToggle<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("i", "<C-b>", "<C-o>:NvimTreeToggle<cr>", {silent = true, noremap = true})

-- Shift+Tab → Unindent line
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Unindent current line" })
vim.keymap.set("v", "<S-Tab>", "<C-o><<", { desc = "Unindent current line (visual mode)" })
vim.keymap.set("i", "<S-Tab>", "<C-o><<", { desc = "Unindent current line (insert mode)" })

-- Ctrl+T → Open terminal
vim.keymap.set("n", "<C-t>", ":terminal<CR>:startinsert<CR>", { desc = "Open terminal in current directory" })
vim.keymap.set("v", "<C-t>", "<C-o>:terminal<CR>:startinsert<CR>", { desc = "Open terminal in current directory (visual mode)" })
vim.keymap.set("i", "<C-t>", "<C-o>:terminal<CR>:startinsert<CR>", { desc = "Open terminal in current directory (insert mode)" })

-- Ctrl+PageDown → Scroll to bottom of buffer
vim.keymap.set("n", "<C-PageDown>", "G", { desc = "Go to bottom of buffer" })
vim.keymap.set("v", "<C-PageDown>", "<C-o>G", { desc = "Go to bottom of buffer (visual mode)" })
vim.keymap.set("i", "<C-PageDown>", "<C-o>G", { desc = "Go to bottom of buffer (insert mode)" })

-- Ctrl+PageUp → Scroll to top of buffer
vim.keymap.set("n", "<C-PageUp>", "gg", { desc = "Go to top of buffer" })
vim.keymap.set("v", "<C-PageUp>", "<C-o>gg", { desc = "Go to top of buffer (visual mode)" })
vim.keymap.set("i", "<C-PageUp>", "<C-o>gg", { desc = "Go to top of buffer (insert mode)" })

-- Ctrl+Shift+C → Toggle comment line/block
vim.keymap.set("n", "<C-S-c>", "gcc", { desc = "Toggle comment line" })
vim.keymap.set("v", "<C-S-c>", "gc", { desc = "Toggle comment block (visual mode)" })
vim.keymap.set("i", "<C-S-c>", "<C-o>gcc", { desc = "Toggle comment (insert mode)" })

-- Ctrl+Shift+F → Format file
vim.keymap.set("n", "<C-S-F>", "gg=G", { desc = "Format file" })
vim.keymap.set("i", "<C-S-F>", "<C-o>gg=G", { desc = "Format file (insert mode)" })

-- Ctrl+Tab → Move to next buffer
vim.keymap.set("n", "<C-Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("i", "<C-Tab>", "<C-o>:bnext<CR>", { desc = "Next buffer" })

-- Ctrl+Shift+Tab → Move to previous buffer
vim.keymap.set("n", "<C-S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("i", "<C-S-Tab>", "<C-o>:bprevious<CR>", { desc = "Previous buffer" })

-- Ctrl+Q → Run :quit!
vim.keymap.set("n", "<C-Q>", ":quit!<CR>", { desc = "Quit" })
vim.keymap.set("v", "<C-Q>", "<C-o>:quit!<CR>", { desc = "Quit (visual mode)" })
vim.keymap.set("i", "<C-Q>", "<C-o>:quit!<CR>", { desc = "Quit (insert mode)" })
