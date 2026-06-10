return {
	"olimorris/codecompanion.nvim",
	version = "^19.14.0",
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			display = {
				action_palette = {
					width = 95,
					height = 10,
					prompt = "Prompt ",
					provider = "mini_pick",
					opts = {
						show_preset_actions = true,
						show_preset_prompts = true,
						title = "CodeCompanion actions",
					},
				},
			},
			adapters = {
				http = {
					gemini_flash_lite = function()
						return require("codecompanion.adapters").extend("gemini", {
							env = {
								api_key = "GEMINI_API_KEY",
							},
							parameters = {
								service_tier = "flex",
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
								auth_method = "gemini-api-key",
							},
							env = {
								GEMINI_API_KEY = "GEMINI_API_KEY",
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
					agent = "gemini_cli",
					agents = {
						gemini_cli = {
							cmd = "gemini",
							args = {},
							description = "Gemini CLI",
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
