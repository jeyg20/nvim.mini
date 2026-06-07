-- ========================================================================== --
-- AUTOCOMMANDS, DIAGNOSTICS & HIGHLIGHT OVERRIDES
-- ========================================================================== --

-- Custom highlight overrides
vim.api.nvim_set_hl(0, "LineNr", { fg = "#9ca3af" })

-- Diagnostics display
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded" },
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-ighlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
