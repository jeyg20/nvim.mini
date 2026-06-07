return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
	},
	config = function()
		require("codecompanion").setup({
			adapters = {
				http = {
					anthropic = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key = "ANTHROPIC_KEY",
							},
						})
					end,
				},
			},
			interactions = {
				chat = {
					adapter = "anthropic",
					model = "claude-sonnet-4-20250514",
				},
				inline = {
					adapter = "anthropic",
					model = "claude-sonnet-4-20250514",
				},
				cmd = {
					adapter = "anthropic",
					model = "claude-sonnet-4-20250514",
				},
				cli = {
					agent = "claude_code",
					agents = {
						claude_code = {
							cmd = "claude",
							args = {},
							description = "Claude Code CLI",
							provider = "terminal",
						},
					},
				},
			},
			opts = {
				log_level = "DEBUG",
			},
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						make_vars = true,
						make_slash_commands = true,
						show_result_in_chat = true,
					},
				},
			},
		})
	end,
}
