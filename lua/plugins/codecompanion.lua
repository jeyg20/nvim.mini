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
					gemini_flash_lite = function()
						return require("codecompanion.adapters").extend("gemini", {
							env = {
								api_key = "GEMINI_API_KEY",
							},
							schema = {
								model = {
									default = "gemini-3.1-flash-lite",
								},
							},
						})
					end,
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
					gemini_cli = function()
						return require("codecompanion.adapters").extend("gemini_cli", {
							defaults = {
								auth_method = "gemini-api-key", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
							},
							env = {
								GEMINI_API_KEY = "cmd:op read op://personal/Gemini_API/credential --no-newline",
							},
						})
					end,
				},
			},
			interactions = {
				chat = {
					adapter = "gemini_flash_lite",
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
