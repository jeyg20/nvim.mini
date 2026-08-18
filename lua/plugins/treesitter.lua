return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		-- The main branch rewrite only accepts `install_dir` here. Highlighting and
		-- indent are no longer options: they are started per-buffer, below.
		require("nvim-treesitter").setup()

		local ensure_installed = {
			"lua",
			"luadoc",
			"python",
			"javascript",
			"typescript",
			"tsx",
			"jsdoc",
			"html",
			"css",
			"json",
			"yaml",
			"toml",
			"bash",
			"markdown",
			"markdown_inline",
			"diff",
			"query",
			"vim",
			"vimdoc",
		}
		-- install() is async and skips parsers that are already present.
		require("nvim-treesitter").install(ensure_installed)

		vim.api.nvim_create_autocmd("FileType", {
			desc = "Start treesitter highlighting and indent when a parser exists",
			group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
				if not pcall(vim.treesitter.language.add, lang) then
					return
				end
				vim.treesitter.start(ev.buf, lang)
				vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
