return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format" },
			javascript = { "prettier" },
			markdown = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			sh = { "shfmt" },
		},
		format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
	},
}
