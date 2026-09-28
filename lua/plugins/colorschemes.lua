return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "moon",
			transparent = true,

			on_highlights = function(highlights, colors)
				highlights.WinSeparator = { fg = colors.dark5 }
				highlights.CursorLineNr = { fg = colors.blue0 }
				highlights.DiagnosticUnnecessary = { fg = colors.dark5, italic = true }
			end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight-moon")
		end,
	},
	-- Alternates: kept installed but not loaded at startup. lazy.nvim hooks
	-- ColorSchemePre and pulls the right one in when you `:colorscheme <name>`.
	{ "catppuccin/nvim", name = "catppuccin", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
	{ "rebelot/kanagawa.nvim", lazy = true },
}
