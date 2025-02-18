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
			require("telescope").setup({
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

			require("telescope").load_extension("zf-native")
		end
	},

	-- File tabs
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons"
		},
	},

	-- Completion
	{
		"ms-jpq/coq_nvim"
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

	-- Git blame
	{
		"f-person/git-blame.nvim"
	}
}
