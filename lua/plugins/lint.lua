return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			markdown = { "markdownlint" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
		}
		-- InsertLeave fires constantly; running eslint_d on every exit from insert
		-- mode is a lot of churn on a large file for no extra signal.
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			desc = "Run linters",
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
