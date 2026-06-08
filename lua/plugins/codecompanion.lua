return {
	"olimorris/codecompanion.nvim",
	version = "^19.14.0",
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
	},
	config = function()
		require("codecompanion").setup({
			adapters = {
				acp = {
					claude_code = function()
						return require("codecompanion.adapters").extend("claude_code", {
							env = {
								ANTHROPIC_API_KEY = "ANTHROPIC_KEY",
							},
						})
					end,
				},
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
							args = { "--model", "claude-sonnet-4-6" },
							description = "Claude Code CLI",
							provider = "terminal",
						},
						-- codex = {
						-- 	cmd = "codex",
						-- 	args = {},
						-- 	description = "OpenAI Codex CLI",
						-- 	provider = "terminal",
						-- },
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
