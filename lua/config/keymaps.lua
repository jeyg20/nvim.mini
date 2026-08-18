local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>pv", vim.cmd.Ex)

-- 'Black hole register' Delete text whitout storing it in the register or clipboard
map({ "n", "v" }, "<leader>d", [["_d]])
-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Open File Explorer (MiniFiles)
map("n", "<leader>e", function()
	require("mini.files").open()
end, { desc = "Open File Explorer" })

-- Fuzzy Finding (MiniPick)
map("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Pick grep_live<cr>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "Find Buffers" })
map("n", "<leader>fr", "<cmd>Pick resume<cr>", { desc = "Resume picker" })

-- LSP Keymaps
map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
-- Rename symbol across the whole project via LSP.
-- Semantic: renames real references only, never a string or comment that happens to match.
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol (LSP)" })

-- Fallback for when no LSP is attached: rename word under cursor in the current buffer.
-- The old word is prefilled as the replacement with the cursor at its end, so tweaking
-- an existing name is just typing; <C-w> clears it for a completely different one.
map("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
	desc = "Rename word in buffer",
})

-- Fallback project-wide rename: ripgrep every whole-word hit into the quickfix list,
-- then substitute across those files in one shot. No confirmation, no format-on-save.
map("n", "<leader>rp", function()
	local word = vim.fn.expand("<cword>")
	if word == "" then
		return
	end
	vim.ui.input({ prompt = "Rename '" .. word .. "' project-wide to: ", default = word }, function(new_name)
		if not new_name or new_name == "" or new_name == word then
			return
		end
		vim.cmd("silent grep! " .. vim.fn.shellescape("\\b" .. word .. "\\b"))
		if vim.tbl_isempty(vim.fn.getqflist()) then
			vim.notify("No matches for " .. word, vim.log.levels.WARN)
			return
		end
		local hits = #vim.fn.getqflist()
		-- noautocmd on the write skips BufWritePre, so conform's format_on_save
		-- does not run once per file (500ms each) during the rename.
		vim.cmd("silent! cfdo %s/\\<" .. word .. "\\>/" .. new_name .. "/ge | noautocmd update")
		vim.notify("Renamed " .. word .. " -> " .. new_name .. " (" .. hits .. " hits)")
	end)
end, { desc = "Rename word project-wide (grep + cfdo)" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
map("n", "<c-l>", "<c-w><c-l>", { desc = "move focus to the right window" })
map("n", "<c-j>", "<c-w><c-j>", { desc = "move focus to the lower window" })

map("n", "<leader><Left>", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })
map("n", "<leader><Right>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<leader><Up>", "<cmd>resize +5<cr>", { desc = "Increase window height" })
map("n", "<leader><Down>", "<cmd>resize -5<cr>", { desc = "Decrease window height" })

-- Create splits
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split window horizontally" })
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
map("n", "<leader>sc", "<C-w>c", { desc = "Close current split" })

-- Press 'gl' (Go Line) to see the error floating window
map("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic error" })

map("n", "<leader>fm", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- Move selected lines up & down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Join lines but keep cursor in place with J
map("n", "J", "mzJ`z")

-- Next/previous search result and center cursor
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Restart LSP server with <leader>zig
map("n", "<leader>lsp", "<cmd>LspRestart<cr>")

-- "Greatest remap ever": paste over selection without yanking it
map("x", "<leader>p", [["_dP]])

-- Map <leader>xh to view buffer as hex with xxd
map("n", "<Leader>xh", ":%!xxd<CR>", {
	noremap = true, -- Non-recursive mapping
	silent = true, -- Don't echo the command
	desc = "View buffer as hex (xxd)", -- Description for which-key etc.
})

-- Map <leader>xr to revert buffer from hex with xxd -r
map("n", "<Leader>xr", ":%!xxd -r<CR>", {
	noremap = true,
	silent = true,
	desc = "Revert buffer from hex (xxd -r)",
})

map("n", "<leader>bd", function()
	require("mini.bufremove").delete(0, false)
end, { desc = "Delete Buffer" })

-- Force delete (discard changes)
map("n", "<leader>bD", function()
	require("mini.bufremove").delete(0, true)
end, { desc = "Delete Buffer (Force)" })

-- Open a terminal in a split
map("n", "<leader>th", "<cmd>split | terminal<cr>", { desc = "Open terminal in horizontal split" })
map("n", "<leader>tv", "<cmd>vsplit | terminal<cr>", { desc = "Open terminal in vertical split" })

map(
	{ "n", "v" },
	"<C-a>",
	"<cmd>CodeCompanionActions<cr>",
	{ noremap = true, silent = true, desc = "CodeCompanion actions" }
)
map(
	{ "n", "v" },
	"<LocalLeader>a",
	"<cmd>CodeCompanionChat Toggle<cr>",
	{ noremap = true, silent = true, desc = "Toggle CodeCompanion chat" }
)
map(
	"v",
	"ag",
	"<cmd>CodeCompanionChat Add<cr>",
	{ noremap = true, silent = true, desc = "Add selection to CodeCompanion chat" }
)
map("n", "<LocalLeader>cl", function()
	require("codecompanion").toggle_cli()
end, { noremap = true, silent = true, desc = "Toggle CodeCompanion CLI" })
-- NOTE: do not bind <C-i> here. Terminals send the same byte for <C-i> and <Tab>,
-- so mapping it also remaps normal-mode <Tab> and kills the <C-o>/<C-i> jumplist.

-- Normal mode: runs on the whole buffer (no range)
map("n", "<LocalLeader>i", "<cmd>CodeCompanion<cr>", {
	noremap = true,
	silent = true,
	desc = "CodeCompanion inline",
})

-- Visual mode only ("x"): runs on the highlighted selection
map("x", "<LocalLeader>i", ":<C-u>'<,'>CodeCompanion<cr>", {
	noremap = true,
	silent = true,
	desc = "CodeCompanion inline",
})

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
