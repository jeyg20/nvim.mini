-- ========================================================================== --
-- ENTRY POINT
-- ========================================================================== --
-- Leader keys must be set before plugins are loaded.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Core configuration (eager).
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Plugin manager: bootstraps lazy.nvim and auto-imports lua/plugins/*.
require("config.lazy")
