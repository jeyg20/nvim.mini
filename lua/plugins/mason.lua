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
				-- Formatters / Linters (Now valid here!)
				"stylua",
				"prettier",
				"shfmt",
				"markdownlint",
			},
			auto_update = true,
			run_on_start = true,
			start_delay = 1000,
		})
	end,
}
