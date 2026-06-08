return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- mason-lspconfig now just bridges the gap, no need for ensure_installed here
	},
	config = function()
		require("mason-lspconfig").setup()

		-- 1. SET GLOBAL DEFAULTS
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
			root_markers = { ".git" },
		})

		-- 2. CONFIGURE SPECIFIC SERVERS
		vim.lsp.config("lua_ls", {
			settings = { Lua = { diagnostics = { globals = { "vim" } } } },
		})

		vim.lsp.config("basedpyright", {
			settings = {
				basedpyright = {
					analysis = {
						typeCheckingMode = "basic",
						diagnosticMode = "openFilesOnly",
					},
				},
			},
			-- Disable snippet support in capabilities for this server only
			capabilities = vim.tbl_deep_extend("force", require("blink.cmp").get_lsp_capabilities(), {
				textDocument = {
					completion = {
						completionItem = {
							snippetSupport = false,
						},
					},
				},
			}),
		})

		-- Ruff for the 120-character logic and linting
		vim.lsp.config("ruff", {
			init_options = {
				settings = {
					lineLength = 120,
					lint = {
						select = { "E", "F", "I", "UP", "B", "SIM" },
						ignore = { "E501" },
					},
					format = {
						preview = true,
					},
				},
			},
		})

		vim.lsp.config("ts_ls", {
			on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
		})

		-- 3. ENABLE THE SERVERS
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("basedpyright")
		vim.lsp.enable("ruff")
		vim.lsp.enable("marksman")
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("html")
		vim.lsp.enable("cssls")
		vim.lsp.enable("emmet_ls")
	end,
}
