return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "mason-org/mason.nvim" },
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
			-- Updating on every startup means a network round-trip each launch.
			-- Run :MasonToolsUpdate when you actually want new versions.
			auto_update = false,
			run_on_start = true,
			start_delay = 1000,
		})
	end,
}
