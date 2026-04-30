-- ========================================================================== --
-- 1. SETTINGS & OPTIONS
-- ========================================================================== --
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
require("options")
-- ========================================================================== --
-- 2. BOOTSTRAP LAZY.NVIM
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
-- 3. PLUGIN SPECIFICATIONS
-- ========================================================================== --
require("lazy").setup({
	{ "nvim-mini/mini.nvim", version = false },

	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = {
			keymap = { preset = "default" },
			appearance = { nerd_font_variant = "mono" },
			completion = { documentation = { auto_show = false } },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},

	{
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
	},

	{
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
							typeCheckingMode = "off",
							diagnosticMode = "openFilesOnly",
						},
					},
				},
			})

			-- Ruff for the 120-character logic and linting
			vim.lsp.config("ruff", {
				init_options = {
					settings = {
						lineLength = 120,
						lint = { ignore = { "E501" } },
					},
				},
			})

			-- 3. ENABLE THE SERVERS
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("basedpyright")
			vim.lsp.enable("ruff")
			vim.lsp.enable("marksman")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = { "lua", "python", "javascript", "bash" },
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				javascript = { "prettier" },
				markdown = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				sh = { "shfmt" },
			},
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
		},
	},

	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = { markdown = { "markdownlint" } }
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "moon",
			transparent = true,

			on_highlights = function(highlights, colors)
				highlights.WinSeparator = { fg = colors.dark5 }
				highlights.CursorLineNr = { fg = colors.blue0 }
				highlights.DiagnosticUnnecessary = { fg = colors.dark5, italic = true }
			end,
		},
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "rebelot/kanagawa.nvim" },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
})

-- ========================================================================== --
-- 4. MINI MODULE CONFIGURATION
-- ========================================================================== --
-- Text Editing
require("mini.ai").setup()
require("mini.align").setup()
require("mini.comment").setup()

require("mini.keymap").setup()
require("mini.move").setup()
require("mini.pairs").setup()
-- require("mini.snippets").setup()
require("mini.splitjoin").setup()
require("mini.surround").setup()

-- UI & Aesthetics
require("mini.basics").setup()
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
require("render-markdown").setup({
	completions = { lsp = { enabled = true } },
})

-- ========================================================================== --
-- 5. DIAGNOSTICS & KEYMAPS
-- ========================================================================== --

vim.cmd.colorscheme("tokyonight-moon")

require("keymaps")
