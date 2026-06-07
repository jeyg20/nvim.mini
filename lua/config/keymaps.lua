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

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
map("n", "<c-l>", "<c-w><c-l>", { desc = "move focus to the right window" })
map("n", "<c-j>", "<c-w><c-j>", { desc = "move focus to the lower window" })

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

map("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle Chat" })
map("v", "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to Chat" })
