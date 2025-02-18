local function sttusline_time()
	local Time = require("sttusline.component").new()

    Time.set_config {
        style = "default"
    }

    Time.set_timing(true)

    Time.set_update(function()
        return os.date("%I:%M %p")
    end)

	return Time
end

local function tree_single_click()
	vim.defer_fn(function ()
        if vim.bo.filetype ~= "NvimTree" then
            return
        end

		local api = require("nvim-tree.api")
		local node = api.tree.get_node_under_cursor()

		if node and (node.nodes ~= nil or node.type == "file") then
			api.node.open.edit()
		end
	end, 10)
end

local function close_buffer(bufnum)
    local buffers = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted
    end, vim.api.nvim_list_bufs())

    if #buffers == 1 then
        vim.cmd("bw! " .. bufnum)
		vim.cmd("enew")

        return
    end

    local current_index = nil

    for i, buf in ipairs(buffers) do
        if buf == bufnum then
            current_index = i

            break
        end
    end

	local next_buf = nil

    if current_index then
        if current_index < #buffers then
            next_buf = buffers[current_index + 1] -- Pick next buffer
        elseif current_index > 1 then
            next_buf = buffers[current_index - 1] -- Pick previous buffer if at end
        end
    end

    if next_buf and vim.api.nvim_buf_is_valid(next_buf) then
        vim.api.nvim_set_current_buf(next_buf)
    end

    vim.cmd("bw! " .. bufnum)
end

local function mason_bin_path(bin)
	return vim.fn.stdpath("data") .. "/mason/bin/" .. bin
end

-- Automatically open file manager on startup
--[[
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("nvim-tree.api").tree.open()

		vim.cmd("wincmd p")
	end
})
--]]

return {
	-- Catppuccin
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				transparent_background = false,
				term_colors = true,
				integrations = {
					nvimtree = true,
					telescope = true,
					bufferline = true
				},
			})

			vim.cmd("colorscheme catppuccin-macchiato")
		end
	},

	-- Status bar
	{
		"sontungexpt/sttusline",
		dependencies = {
			"nvim-tree/nvim-web-devicons"
		},
		event = { "BufEnter" },
        config = function()
            require("sttusline").setup({
                statusline_color = "StatusLine",

                laststatus = 3,
                disabled = {
                    filetypes = {
                        -- "NvimTree",
                        -- "lazy"
                    },
                    buftypes = {
                        -- "terminal"
                    }
                },
                components = {
                    "mode",
                    "filename",
                    "git-branch",
                    "git-diff",
                    "%=",
                    "diagnostics",
                    "lsps-formatters",
                    "indent",
                    "encoding",
                    "pos-cursor",
					sttusline_time()
                }
            })
        end
	},

	-- Telescope fuzzy file finder
	-- https://github.com/sharkdp/fd?tab=readme-ov-file#on-windows
	-- https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"natecraddock/telescope-zf-native.nvim"
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					vimgrep_arguments = {
						"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case"
					},
					prompt_prefix = "🔍 ",
					file_ignore_patterns = {
						"node_modules",
						".git",
						"vendor",
						"__pycache__",
						"%.png", "%.jpg", "%.jpeg", "%.gif", "%.bmp", "%.svg", "%.webp", -- Images
						"%.mp4", "%.mkv", "%.webm", "%.avi", "%.mov", "%.flv", "%.wmv", -- Videos
						"%.mp3", "%.wav", "%.flac", "%.ogg", "%.m4a", -- Audio
						"%.exe", "%.dll", "%.bin", "%.so", "%.dylib", "%.app", -- Executables & binaries
						"%.zip", "%.tar", "%.gz", "%.bz2", "%.rar", "%.7z", -- Archives
						"%.pdf", "%.docx", "%.xlsx", "%.pptx", "%.odt", "%.odp" -- Documents
					},
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close
						},
					}
				},
				extensions = {
					["zf-native"] = {
						file = {
							enable = true,
							highlight_results = true,
							match_filename = true,
							smart_case = true
						},
						generic = {
							enable = true,
							highlight_results = true,
							match_filename = false,
							smart_case = true
						}
					}
				},
			})

			telescope.load_extension("zf-native")
		end
	},

	-- File tabs
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons"
		},
		config = function()
			vim.keymap.set("i", "<MiddleMouse>", "<Esc><MiddleMouse>", { silent = true })

			require("bufferline").setup({
				options = {
					style_preset = require("bufferline").style_preset.minimal,
					middle_mouse_command = close_buffer,
					right_mouse_command = close_buffer,
					left_mouse_command = "buffer %d",
					separator_style = "thick",
					show_buffer_close_icons = false,
					show_close_icon = false,
					offsets = {
						{
							filetype = "NvimTree",
							text = function()
								return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							end,
							text_align = "left",
							separator = true
						}
					}
				}
			})
		end
	},

	-- Completion
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets"
		},
		version = "0.12.x",
		opts = {
		 	keymap = {
				preset = "super-tab"
			},
		  	appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono"
		  	},
		  	sources = {
				default = {
					"lsp", "path", "snippets", "buffer"
				}
		  	}
		}
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate"
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
  		dependencies = {
			"nvim-lua/plenary.nvim"
		}
	},

	-- Project management
	{
		"LintaoAmons/cd-project.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim"
		},
		config = function()
			require("cd-project").setup({
				projects_config_filepath = vim.fs.normalize(vim.fn.stdpath("config") .. "/projects.json"),
				project_dir_pattern = {
					".git", ".gitignore", "Cargo.toml", "package.json", "go.mod"
				},
				choice_format = "both",
				projects_picker = "telescope",
				auto_register_project = false,
				hooks = {
					{
						callback = function(_)
							vim.api.nvim_command("bufdo bd!")
						end
					}
				}
			})
		end
	},

	-- Git blame
	{
		"f-person/git-blame.nvim"
	},

	-- Tailwind tools
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim"
		}
	},

	-- File manager
	{
		"nvim-tree/nvim-tree.lua",
		cmd = {
			"NvimTreeToggle", "NvimTreeFocus"
		},
		config = function()
			require("nvim-tree").setup({
				filters = {
					dotfiles = false
				},
				disable_netrw = true,
				hijack_cursor = true,
				sync_root_with_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = false
				},
				view = {
					width = 40,
					preserve_window_proportions = true
				},
				git = {
					enable = false
				},
				renderer = {
					root_folder_label = false,
					highlight_git = true,
					indent_markers = {
						enable = true
					},
					icons = {
						glyphs = {
							default = "󰈚",
							folder = {
								default = "",
								empty = "",
								empty_open = "",
								open = "",
								symlink = ""
							},
							git = {
								unmerged = ""
							}
						}
					}
				},
				on_attach = function(bufnr)
					vim.keymap.set("i", "<LeftRelease>", tree_single_click, {})
					vim.keymap.set("n", "<LeftRelease>", tree_single_click, {})
					vim.keymap.set("v", "<LeftRelease>", tree_single_click, {})
				end
			})

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function()
					local wins = vim.api.nvim_list_wins()

					if #wins == 1 then
						local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(wins[1]))

						if bufname:match("NvimTree") then
							vim.cmd("quit")
						end
					end
				end
			})
		end
	},

	-- LSP support
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			lspconfig.gopls.setup({})
			lspconfig.html.setup({})

			lspconfig.ts_ls.setup({
				cmd = {
					mason_bin_path("typescript-language-server"), "--stdio"
				},
			})

			lspconfig.intelephense.setup({
				cmd = {
					mason_bin_path("intelephense"), "--stdio"
				},
				filetypes = {
					"php", "blade"
				},
				root_dir = function ()
					return vim.loop.cwd()
				end
			})

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = {
								"vim"
							}
						}
					}
				}
			})

			lspconfig.emmet_ls.setup({
				filetypes = {
					"html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte"
				}
			})
		end
	},

	-- Auto-install LSP servers
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim"
		},
		config = function()
			require("mason").setup()

			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls", "gopls", "lua_ls", "emmet_ls", "intelephense"
				},
				automatic_installation = true
			})
		end
	}
}
