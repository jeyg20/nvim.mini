# Neovim Configuration Summary

Personal Neovim config (lazy.nvim-based, Lua). Kickstart-inspired but heavily
customized around the `mini.nvim` suite instead of individual plugins for most
editor UX. ~16 Lua files, no `after/`, no ftplugins — everything lives in
`lua/config/` (core) and `lua/plugins/` (one file per plugin/plugin-group,
auto-imported by lazy.nvim).

## Entry point & bootstrap
- `init.lua`: sets `<leader>`/`<localleader>` to `<Space>`, loads
  `config.options`, `config.keymaps`, `config.autocmds`,
  `config.timetracker.setup()`, then `config.lazy` (which bootstraps
  lazy.nvim and imports everything under `lua/plugins/`).
- `lua/config/lazy.lua`: clones lazy.nvim if missing, `spec = {{ import = "plugins" }}`.

## Core options (`lua/config/options.lua`)
- Line numbers + relative numbers, mouse on, `showmode=false`.
- WSL clipboard integration via `win32yank.exe` (scheduled after `UiEnter`).
- 4-space indent, `expandtab`, `breakindent`/`autoindent`.
- Persistent undo (`undofile`, `undodir=~/.vim/undodir`), no swap/backup.
- `ignorecase`+`smartcase`, `signcolumn=yes`, `updatetime=750`,
  `timeoutlen=300` (fast which-key popup).
- `scrolloff=15`, `sidescrolloff=8`, smooth scrolling.
- `wrap=true`, `textwidth=120`, `colorcolumn=+1`, `termguicolors=true`.
- `grepprg`/`grepformat` wired to ripgrep (vimgrep format) when `rg` exists —
  powers `:grep`/quickfix-based project search & rename.

## Keymaps (`lua/config/keymaps.lua`)
Notable ones beyond defaults:
- `<Esc>` clears search highlight; `<leader>d`/`<leader>p` use the black-hole
  register (delete/paste without clobbering the clipboard).
- `[d`/`]d` diagnostic jump (float), `<leader>q` diagnostic loclist,
  `gl` diagnostic float.
- `<leader>e` opens `mini.files`; `<leader>ff/fg/fb/fr` are `mini.pick`
  (files/live grep/buffers/resume).
- LSP: `gd` definition, `<leader>rn` LSP rename, `<leader>lr/li/ll`
  restart/info/log.
- Rename fallbacks for when no LSP is attached: `<leader>rw` (buffer-local
  word substitute) and `<leader>rp` (custom function — ripgrep whole-word
  matches into quickfix, then `cfdo` substitute across all files, with
  proper `/\.*$^~[]` escaping and a `noautocmd` write to skip
  format-on-save during the batch).
- Window/split management (`<C-hjkl>` focus, `<leader>sh/sv/sc`,
  arrow-key resize), terminal splits (`<leader>th/tv`), terminal-mode escape
  (`<Esc><Esc>`).
- Buffer delete via `mini.bufremove` (`<leader>bd`/`<leader>bD` force).
- Hex editing via `xxd` (`<leader>xh`/`<leader>xr`).
- CodeCompanion AI keymaps under a dedicated `<leader>a` "+ai" prefix
  (`aa` actions palette, `ac` toggle chat, visual `<leader>ag` add selection) plus
  `<localleader>i` inline AI edit (normal = whole buffer, visual = selection)
  and `<localleader>cl` toggle a CLI terminal. `cc` command-line abbreviation
  for `CodeCompanion` (only when it is the whole `:` command).
- Standard QoL: move lines in visual mode (`J`/`K`), join keeping cursor
  (`J`), centered search jumps (`n`/`N`).

## Autocommands (`lua/config/autocmds.lua`)
- Custom `LineNr` highlight override.
- `vim.diagnostic.config`: no virtual text, signs on, rounded float border,
  severity-sorted.
- Yank highlight via `vim.hl.on_yank()`.

## Custom feature: local time tracker (`lua/config/timetracker.lua`)
Self-written, no external service/API key. Tracks active seconds per project
(by git root basename) into `stdpath("data")/timetracker.json`:
- Heartbeat on `CursorHold(I)`/`InsertEnter`/`BufEnter`/`FocusGained`;
  gaps > 120s (`IDLE_SECONDS`) aren't counted as active time.
- Flushes accumulated-but-unwritten seconds to disk every 60s via a libuv
  timer, and again on `VimLeavePre`. Each instance only ever adds its own
  pending delta to whatever is currently on disk, so two concurrent nvim
  instances don't clobber each other's totals; a crash loses at most 60s.
- `:TimeTracker` user command prints totals per project, sorted descending.

## Plugin manager
`lazy.nvim`, bootstrapped manually (git clone into `stdpath("data")/lazy/lazy.nvim`
if absent), specs auto-imported from `lua/plugins/*.lua`.

## Plugins

### `mini.nvim` (`lua/plugins/mini.lua`) — the backbone
Single plugin, ~20 modules set up in one `config` function:
- **Editing**: `mini.ai` (textobjects), `mini.align`, `mini.comment`,
  `mini.move`, `mini.pairs`, `mini.splitjoin`, `mini.surround`.
  (`mini.snippets` present but commented out — blink.cmp's snippet source
  is used instead.)
- **UI/aesthetics**: `mini.basics` (with window mappings; re-asserts
  `wrap=true` because basics resets it and loads after `options.lua`),
  `mini.bufremove`, `mini.clue` (which-key-style popup — triggers on
  `<leader>`, `g`, marks, `<C-w>`, `z`, built-in completion; custom group
  labels for `+find/+ai/+buffer/+lsp/+hex/+rename/+split/+terminal`;
  500ms delay), `mini.cmdline`, `mini.diff`, `mini.files` (file explorer),
  `mini.git`, `mini.pick` (fuzzy finder — files/grep_live/buffers/resume),
  `mini.sessions`, `mini.animate` (cursor animation disabled for latency,
  scroll disabled, resize/open/close enabled), `mini.colors`,
  `mini.cursorword`, `mini.hipatterns`, `mini.icons`, `mini.indentscope`,
  `mini.starter` (dashboard), `mini.statusline`, `mini.tabline`,
  `mini.trailspace`.

### LSP stack
- `lua/plugins/lsp.lua` (`neovim/nvim-lspconfig`): uses the new
  `vim.lsp.config`/`vim.lsp.enable` API (not `lspconfig.setup{}`).
  `mason-lspconfig` set up with `automatic_enable = false` deliberately, to
  avoid auto-starting formatter-only Mason packages that happen to expose an
  lspconfig spec. Global capabilities come from `blink.cmp`. Per-server
  config: `lua_ls` (vim global), `basedpyright` (basic type checking,
  open-files-only, snippets disabled), `ruff` (120-char line length, specific
  lint rule selection, E501 ignored since textwidth/colorcolumn handle it,
  format preview on), `ts_ls` (formatting capabilities turned off — prettier
  owns formatting instead). Enabled servers: `lua_ls`, `basedpyright`,
  `ruff`, `marksman`, `ts_ls`, `html`, `cssls`, `emmet_ls`.
- `lua/plugins/mason.lua`: `mason.nvim` + `mason-tool-installer` ensures LSPs
  and CLI formatters/linters (`stylua`, `prettier`, `shfmt`, `markdownlint`,
  `eslint_d`) are installed; `auto_update = false` to avoid a network
  round-trip on every startup — updates are manual via `:MasonToolsUpdate`.

### Completion
`lua/plugins/blink.lua` (`saghen/blink.cmp`, v1.x): default keymap preset
plus `<Tab>`/`<S-Tab>` for snippet nav, `<CR>` accept. Ghost text and
auto-shown docs (200ms delay). Sources: `lsp`, `snippets`, `path`, `buffer`
(snippets boosted, buffer results deprioritized). Rust fuzzy matcher
preferred. Signature help enabled.

### Formatting & linting
- `lua/plugins/conform.lua` (`stevearc/conform.nvim`): format-on-save
  (500ms timeout, LSP fallback) per-filetype — `stylua` (Lua),
  `ruff_organize_imports`+`ruff_format` (Python), `prettier`
  (JS/TS/JSX/TSX/HTML/CSS/Markdown/JSON/JSONC), `shfmt` (sh). Custom
  `:FormatToggle[!]` command to disable format-on-save globally or
  buffer-locally (escape hatch for bulk edits / vendored files).
- `lua/plugins/lint.lua` (`mfussenegger/nvim-lint`): `markdownlint` for
  markdown, `eslint_d` for JS/TS family, run on `BufWritePost`/`BufReadPost`
  (deliberately not `InsertLeave`, to avoid re-linting large files on every
  insert-mode exit).

### Treesitter (`lua/plugins/treesitter.lua`)
`main` branch (new Lua-driven rewrite), `install()` for a curated parser
list (lua, python, js/ts/tsx, html/css/json/yaml/toml, bash, markdown(+inline),
diff, query, vim/vimdoc). Highlighting/indent are started manually per
buffer on `FileType`, skipping non-file buftypes (pickers, mini.files,
starter) and buffers with no parser available.

### AI: CodeCompanion (`lua/plugins/codecompanion.lua`)
`olimorris/codecompanion.nvim`, pinned `^19.14.0`. Multiple adapters wired to
different env vars and roles:
- HTTP adapters: `gemini_flash_lite` (Gemini, flex service tier,
  `GEMINI_API_KEY`) used for background chat titles; `gpt_luna` (OpenAI
  Responses API, `GPT_KEY`) used for **inline edits** and **cmd** generation.
- ACP adapters: `claude_code` (via `ANTHROPIC_OAUTH_TOKEN`, the Claude Pro
  subscription) used for **chat**; `gemini_cli` and `codex` as alternates.
- **CLI** interaction runs `claude` in a terminal (also `gemini`, `codex`).
- No Anthropic API key: the HTTP API rejects subscription tokens, so Claude
  is only used through ACP/CLI. Never export `ANTHROPIC_API_KEY`.
- Action palette rendered through `mini.pick`.

### Colorscheme (`lua/plugins/colorschemes.lua`)
`tokyonight.nvim` (style "moon", transparent background) is the eager,
priority-1000 default, with custom highlight tweaks (`WinSeparator`,
`CursorLineNr`, dimmed/italic `DiagnosticUnnecessary`). `catppuccin`,
`rose-pine`, `kanagawa` are installed but lazy — lazy.nvim lazy-loads them
on `:colorscheme <name>` via its `ColorSchemePre` hook.

### Markdown rendering (`lua/plugins/render-markdown.lua`)
`render-markdown.nvim`, active for `markdown` and `codecompanion` filetypes
(so AI chat buffers get rendered too), LSP-based completions enabled.

## Documentation
- `CHEATSHEET.md`: full keymap reference covering every binding (not just
  hand-written ones — mini.nvim defaults are documented too), organized by
  topic (Finding & Files, Editing, LSP, Git/diff, Surround, Text objects,
  AI, completion, macros, clue trigger keys, automatic tooling).
- `graphify-out/`: a generated knowledge graph of this repo (nodes/edges,
  community detection) used for codebase Q&A via the `graphify` CLI.

## Design conventions worth knowing
- Prefer `mini.nvim` modules over standalone plugins wherever one exists.
- New-style `vim.lsp.config`/`vim.lsp.enable` API, not classic
  `lspconfig.setup{}` per server.
- Formatting is owned by conform.nvim/LSP-fallback, not by individual LSP
  servers (e.g. `ts_ls` formatting capabilities explicitly disabled).
- Heavy inline comments explaining *why*, especially around non-obvious
  ordering/timing issues (mini.basics resetting `wrap`, format-on-save
  interfering with batch rename, treesitter skipping scratch buffers).
- WSL is the target platform (win32yank clipboard bridge).
