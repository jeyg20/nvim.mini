return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "1.*",
	opts = {
		keymap = {
			preset = "default",
			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = { nerd_font_variant = "mono" },
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 200 },
			ghost_text = { enabled = true },
		},
		snippets = {
			preset = "default",
		},
		sources = {
			default = { "lsp", "snippets", "path", "buffer" },
			providers = {
				snippets = {
					score_offset = 5, -- boost custom snippets above LSP
					opts = {
						search_paths = {
							vim.fn.stdpath("config") .. "/snippets",
						},
					},
				},
				buffer = { score_offset = -3 },
			},
		},
		signature = { enabled = true },
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
