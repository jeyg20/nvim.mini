return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		require("mason").setup()
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- LSPs
				"lua_ls",
				"basedpyright",
				"ruff",
				"marksman",
				"stylua",
				"prettier",
				"shfmt",
				"markdownlint",
				"ts_ls",
				"html-lsp",
				"css-lsp",
				"eslint_d",
				"emmet-ls",
			},
			auto_update = true,
			run_on_start = true,
			start_delay = 1000,
		})
	end,
}
