return {
	"nvim-mini/mini.nvim",
	version = false,
	config = function()
		-- ================================================================== --
		-- Text Editing
		-- ================================================================== --
		require("mini.ai").setup()
		require("mini.align").setup()
		require("mini.comment").setup()

		require("mini.keymap").setup()
		require("mini.move").setup()
		require("mini.pairs").setup()
		-- require("mini.snippets").setup()
		require("mini.splitjoin").setup()
		require("mini.surround").setup()

		-- ================================================================== --
		-- UI & Aesthetics
		-- ================================================================== --
		require("mini.basics").setup({
			mappings = {
				windows = true,
			},
		})
		require("mini.bufremove").setup()
		local miniclue = require("mini.clue")
		miniclue.setup({
			triggers = {
				-- Leader triggers
				{ mode = "n", keys = "<Leader>" },
				{ mode = "x", keys = "<Leader>" },

				-- Built-in completion
				{ mode = "i", keys = "<C-x>" },

				-- 'g' key (very common for "go to definition", comments, etc.)
				{ mode = "n", keys = "g" },
				{ mode = "x", keys = "g" },

				-- Marks
				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "x", keys = "'" },
				{ mode = "x", keys = "`" },

				-- Window commands (Ctrl-w)
				{ mode = "n", keys = "<C-w>" },

				-- 'z' key (folds, spelling)
				{ mode = "n", keys = "z" },
				{ mode = "x", keys = "z" },
			},

			clues = {
				-- This enhances the menu with better descriptions for built-in keys
				miniclue.gen_clues.builtin_completion(),
				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers(),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),
				-- Group labels
				{ mode = "n", keys = "<Leader>f", desc = "+find" },
				{ mode = "n", keys = "<Leader>b", desc = "+buffer" },
				{ mode = "n", keys = "<Leader>l", desc = "+lsp" },
				{ mode = "n", keys = "<Leader>x", desc = "+hex" },
			},

			-- Optional: delay before the window opens (in milliseconds)
			window = {
				delay = 500,
			},
		})
		require("mini.cmdline").setup()
		require("mini.diff").setup()
		require("mini.files").setup()
		require("mini.git").setup()
		require("mini.pick").setup()
		require("mini.sessions").setup()

		require("mini.animate").setup({
			cursor = { enable = true },
			scroll = { enable = false },
			resize = { enable = true },
			open = { enable = true },
			close = { enable = true },
		})

		require("mini.colors").setup()
		require("mini.cursorword").setup()
		require("mini.hipatterns").setup()
		require("mini.icons").setup()
		require("mini.indentscope").setup()
		require("mini.starter").setup()
		require("mini.statusline").setup()
		require("mini.tabline").setup()
		require("mini.trailspace").setup()
	end,
}
