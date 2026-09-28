return {
	"stevearc/conform.nvim",
	init = function()
		-- Escape hatch for buffers/sessions where format-on-save is unwanted
		-- (bulk edits, someone else's repo, generated files).
		vim.api.nvim_create_user_command("FormatToggle", function(args)
			if args.bang then
				vim.b.disable_autoformat = not vim.b.disable_autoformat
				vim.notify("format on save (buffer): " .. (vim.b.disable_autoformat and "off" or "on"))
			else
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				vim.notify("format on save (global): " .. (vim.g.disable_autoformat and "off" or "on"))
			end
		end, { bang = true, desc = "Toggle format on save (! for current buffer only)" })
	end,
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			markdown = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			sh = { "shfmt" },
		},
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
	},
}
