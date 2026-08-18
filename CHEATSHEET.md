# Neovim Cheat-Sheet

> Leader = **Space** · LocalLeader = **Space** (same key) · `n`=normal `v`=visual `x`=visual-only `i`=insert `t`=terminal
> Forgot a mapping? Press **Space** (or `g` / `z` / `<C-w>`) and wait — **mini.clue** shows a menu after 500ms.

---

## Finding & Files
| Keys | Action |
|------|--------|
| `<leader>e`  | File explorer (MiniFiles) |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Resume last picker |
| `<leader>pv` | Netrw (`:Ex`) |

## Windows & Splits
| Keys | Action |
|------|--------|
| `<C-h/j/k/l>` | Move focus between windows |
| `<leader>sh` / `<leader>sv` | New split horizontal / vertical |
| `<leader>sc` | Close current split |
| `<leader>←` / `→` | Shrink / grow width (∓5) |
| `<leader>↑` / `↓` | Grow / shrink height (±5) |
| `<leader>th` / `<leader>tv` | Terminal in horizontal / vertical split |
| `<Esc><Esc>` | Exit terminal mode |

## LSP & Diagnostics
| Keys | Action |
|------|--------|
| `gd` | Go to definition |
| `gl` | Show diagnostic float |
| `[d` / `]d` | Prev / next diagnostic |
| `<leader>q` | Diagnostics → loclist |
| `<leader>lsp` | `:LspRestart` |
| `<leader>fm` | Format buffer (conform) |

## Renaming
| Keys | Action |
|------|--------|
| `<leader>rn` | **Rename symbol project-wide (LSP)** — semantic, skips strings/comments |
| `<leader>rw` | Rename word in buffer — old name prefilled, `<C-w>` clears it |
| `<leader>rp` | Rename word project-wide (ripgrep + `cfdo`), writes files directly |
| `grn` / `grr` / `gra` | Built-in 0.11 rename / references / code action |

> `rw` and `rp` are plain text substitution for filetypes with no LSP — they *will* hit
> strings and comments. `u` undoes `rw`; `rp` has no undo, it saves as it goes.

## Editing
| Keys | Action |
|------|--------|
| `<leader>d` (n/v) | Delete into black hole (no yank) |
| `<leader>p` (x) | Paste over selection, keep yank |
| `J` / `K` (v) | Move selection down / up |
| `J` (n) | Join lines, keep cursor |
| `n` / `N` | Next / prev search, centered |
| `<Esc>` | Clear search highlight |
| `<leader>bd` / `<leader>bD` | Delete buffer / force |
| `<leader>xh` / `<leader>xr` | Buffer → hex / hex → buffer (xxd) |

## AI — CodeCompanion
| Keys | Action |
|------|--------|
| `<C-a>` (n/v) | Action palette |
| `<localleader>a` (`Space a`) | Toggle chat |
| `ag` (v) | Add selection to chat |
| `<localleader>cl` (`Space cl`) | Toggle CodeCompanion CLI |
| `<localleader>i` (`Space i`) (n) | Inline on whole buffer |
| `<localleader>i` (`Space i`) (v) | Inline on selection |
| `:cc` | Command abbrev → `CodeCompanion` |

## Completion (blink.cmp)
| Keys | Action |
|------|--------|
| `<Tab>` / `<S-Tab>` | Snippet jump forward / back |
| `<CR>` | Accept completion |

Sources: LSP · snippets (`~/.config/nvim/snippets`, boosted) · path · buffer

---

## mini.clue trigger keys
`<Leader>` · `g` · `z` · `'` · `` ` `` · `<C-w>` · `<C-x>`
Groups: `<leader>f`=find · `<leader>b`=buffer · `<leader>l`=lsp · `<leader>x`=hex · `<leader>r`=rename · `<leader>s`=split · `<leader>t`=terminal

## Tooling (automatic)
- **Format on save** — stylua (lua) · ruff (python) · prettier (js/ts/html/css/md/json) · shfmt (sh)
- **Lint on save/read** — markdownlint (md) · eslint_d (js/ts)
- **LSP servers** — lua_ls · basedpyright · ruff · marksman · ts_ls · html · cssls · emmet_ls
- **AI routing** — chat → Gemini Flash Lite · inline/cmd → Claude Haiku · CLI → claude (also gemini, codex)
- **Treesitter** — highlight + indent started per-buffer (nvim-treesitter `main` branch)
- **Colorscheme** — tokyonight-moon (transparent)
