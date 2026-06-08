return {
	"olimorris/codecompanion.nvim",
	version = "^19.14.0",
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
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
							schema = {
								model = {
									default = "claude-sonnet-4-6",
								},
							},
						})
					end,
					anthropic_haiku = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key = "ANTHROPIC_KEY",
							},
							schema = {
								model = {
									default = "claude-haiku-4-5",
								},
							},
						})
					end,
				},
				acp = {
					claude_code = function()
						return require("codecompanion.adapters").extend("claude_code", {
							env = {
								ANTHROPIC_API_KEY = "ANTHROPIC_KEY",
							},
						})
					end,
				},
			},
			interactions = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic_haiku",
				},
				cmd = {
					adapter = "anthropic_haiku",
				},
				-- This is what controls :CodeCompanionCLI
				cli = {
					agent = "claude_code",
					agents = {
						claude_code = {
							cmd = "claude",
							args = { "--model", "claude-sonnet-4-6" },
							description = "Claude Code CLI",
							provider = "terminal",
						},
					},
				},
			},
			opts = {
				log_level = "DEBUG",
			},
		})
	end,
}
