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
				-- The CLI window inherits display.chat.window, so this moves both.
				chat = {
					window = {
						position = "left",
						-- Values below 1 are a fraction of the editor width.
						width = 3 / 8,
					},
					-- Keep long /file and #buffer attachments from pushing the prompt
					-- off screen.
					fold_context = true,
					show_settings = false,
					show_token_count = true,
					start_in_insert_mode = true,
				},
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
			-- Env keys used below (exported in ~/.zshrc): GEMINI_API_KEY, GPT_KEY and
			-- ANTHROPIC_OAUTH_TOKEN (`claude setup-token`, bills the Claude Pro
			-- subscription). Inline/cmd only accept HTTP adapters and the Anthropic
			-- API rejects subscription tokens, so Claude is used via ACP/CLI only.
			-- Never export ANTHROPIC_API_KEY: Claude Code would prefer it over the
			-- subscription and bill the API.
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
					-- Responses API rather than chat completions: gpt-5.6-luna is the
					-- openai_responses adapter's own default and reasoning-capable there.
					gpt_luna = function()
						return require("codecompanion.adapters").extend("openai_responses", {
							env = {
								api_key = "GPT_KEY",
							},
							schema = {
								model = {
									default = "gpt-5.6-luna",
								},
							},
						})
					end,
				},
				acp = {
					claude_code = function()
						return require("codecompanion.adapters").extend("claude_code", {
							-- The adapter expects claude-agent-acp; fall back to the older,
							-- deprecated claude-code-acp until the new package is installed.
							commands = (function()
								local bin = vim.fn.executable("claude-agent-acp") == 1 and "claude-agent-acp"
									or "claude-code-acp"
								return { default = { bin }, yolo = { bin, "--yolo" } }
							end)(),
							env = {
								CLAUDE_CODE_OAUTH_TOKEN = "ANTHROPIC_OAUTH_TOKEN",
							},
						})
					end,
					gemini_cli = function()
						return require("codecompanion.adapters").extend("gemini_cli", {
							-- The adapter's --experimental-acp is deprecated in gemini >= 0.46.
							commands = {
								default = { "gemini", "--acp" },
								yolo = { "gemini", "--yolo", "--acp" },
							},
							defaults = {
								auth_method = "gemini-api-key",
							},
							env = {
								GEMINI_API_KEY = "GEMINI_API_KEY",
							},
						})
					end,
					codex = function()
						return require("codecompanion.adapters").extend("codex", {
							defaults = {
								-- "api-key"|"chat-gpt"; we authenticate with GPT_KEY.
								auth_method = "api-key",
							},
							env = {
								OPENAI_API_KEY = "GPT_KEY",
							},
						})
					end,
				},
			},
			interactions = {
				-- Chat runs Claude Code over ACP: the same agent as the CLI, but its
				-- edits come back as diffs in Neovim. `\` completes the agent's own
				-- slash commands, `/` CodeCompanion's; `/resume` picks up an ACP session.
				chat = {
					adapter = "claude_code",
					-- Save every chat to disk once answered and keep it updated
					-- (plugin default is autosave = false). Restore with /resume.
					sessions = {
						enabled = true,
						autosave = true,
						continuous_save = true,
					},
					roles = {
						llm = function(adapter)
							return adapter.formatted_name
						end,
						user = "Me",
					},
					opts = {
						completion_provider = "blink",
						-- ACP agents compact their own context; only manage it for the
						-- HTTP adapters (e.g. after switching with `ga`).
						context_management = {
							enabled = function(adapter)
								return adapter.type == "http"
							end,
						},
					},
				},
				-- Titles chats via a cheap model; the default background adapter is
				-- copilot, which isn't configured here.
				background = {
					adapter = "gemini_flash_lite",
					chat = {
						opts = {
							enabled = true,
						},
					},
				},
				inline = {
					adapter = "gpt_luna",
				},
				cmd = {
					adapter = "gpt_luna",
				},
				cli = {
					agent = "claude_code",
					agents = {
						gemini_cli = {
							cmd = "gemini",
							args = {},
							description = "Gemini CLI",
							provider = "terminal",
						},
						codex = {
							cmd = "codex",
							args = {},
							description = "Codex",
							provider = "terminal",
						},
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
				log_level = "ERROR",
			},
		})
	end,
}
