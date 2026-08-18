# Neovim Cheat-Sheet

> Leader = **Space** · LocalLeader = **Space** (same key) · `n`=normal `v`=visual `x`=visual-only `o`=operator-pending `i`=insert `c`=cmdline `t`=terminal
> Forgot a mapping? Press **Space** (or `g` / `z` / `[` / `]` / `\` / `<C-w>`) and wait — **mini.clue** shows a menu after 500ms.
>
> Source column: **you** = `lua/config/keymaps.lua` · **nvim** = Neovim 0.11 built-in default · everything else is the plugin that sets it.

---

## Gotchas — read once

| What | Why it matters |
|------|----------------|
| `s` is **not** substitute-char | `mini.surround` owns the whole `s` prefix in `n`/`x`/`o`. Use `cl` for the old `s`. |
| `]t` / `[t` is **tags**, not tabs | From Neovim defaults (`:tnext`). To change *tab* use `gt`/`gT`; to change *buffer* use `]b`/`[b`. |
| Your tabline shows **buffers** | `mini.tabline` lists buffers and only shows tabpages when >1 exists. So `]b`/`[b` walks what you see. |
| Never map `<C-i>` | Terminals send one byte for `<C-i>` and `<Tab>`; mapping it breaks normal-mode `<Tab>` and the `<C-o>`/`<C-i>` jumplist. |
| `ag` in visual | Bound to CodeCompanion, so it shadows an `a`+`g` textobject and adds a small delay after `a`. |

---

## Finding & Files
| Keys | Action | Source |
|------|--------|--------|
| `<leader>e`  | File explorer (MiniFiles) | you |
| `<leader>ff` | Find files | you |
| `<leader>fg` | Live grep | you |
| `<leader>fb` | Find buffers | you |
| `<leader>fr` | Resume last picker | you |
| `<leader>pv` | Netrw (`:Ex`) | you |
| `gx` | Open file/URI under cursor in system handler | nvim |

### Inside MiniFiles
`l` go in · `L` go in + close · `h` go out · `H` go out + close · `=` **synchronize (apply changes)** · `q` close
`m` set mark · `'` go to mark · `@` reveal cwd · `<BS>` reset · `<` / `>` trim left/right · `g?` help

### Inside MiniPick
`<CR>` choose · `<C-s>` / `<C-v>` / `<C-t>` choose in split / vsplit / tab · `<Esc>` stop
`<C-n>` / `<C-p>` next / prev · `<C-g>` to start · `<C-f>` / `<C-b>` scroll down / up · `<C-h>` / `<C-l>` scroll left / right
`<C-x>` mark · `<C-a>` mark all · `<M-CR>` choose marked · `<C-Space>` refine · `<M-Space>` refine marked
`<Tab>` toggle preview · `<S-Tab>` toggle info · `<C-r>` paste register
`<BS>` / `<Del>` delete char · `<C-u>` delete left · `<C-w>` delete word · `<Left>` / `<Right>` move caret

## Buffers, Windows & Splits
| Keys | Action | Source |
|------|--------|--------|
| `]b` / `[b` | Next / previous **buffer** | nvim |
| `]B` / `[B` | Last / first buffer | nvim |
| `<leader>bd` / `<leader>bD` | Delete buffer / force | you |
| `gt` / `gT` | Next / previous **tabpage** | nvim (built-in cmd) |
| `<C-h/j/k/l>` | Move focus between windows | you |
| `<leader>sh` / `<leader>sv` | New split horizontal / vertical | you |
| `<leader>sc` | Close current split | you |
| `<leader>←` / `→` | Shrink / grow width (∓5) | you |
| `<leader>↑` / `↓` | Grow / shrink height (±5) | you |
| `<C-Left>` / `<C-Right>` / `<C-Up>` / `<C-Down>` | Same resizing, alternate keys | mini.basics |
| `<leader>th` / `<leader>tv` | Terminal in horizontal / vertical split | you |
| `<Esc><Esc>` | Exit terminal mode | you |
| `<C-s>` | Save (also from insert/visual) | mini.basics |

## Motion & Navigation
| Keys | Action | Source |
|------|--------|--------|
| `j` / `k` | Move by *screen* line when no count (wrap-aware) | mini.basics |
| `n` / `N` | Next / prev search, centered | you |
| `<Esc>` | Clear search highlight | you |
| `]q` / `[q` · `]Q` / `[Q` | Next/prev · last/first quickfix | nvim |
| `]l` / `[l` · `]L` / `[L` | Same for location list | nvim |
| `]a` / `[a` · `]A` / `[A` | Next/prev · last/first arglist file | nvim |
| `]t` / `[t` · `]T` / `[T` | Next/prev · last/first **tag** | nvim |
| `]<C-q>` / `[<C-q>` | First error in next / previous file (quickfix) | nvim |
| `]<C-l>` / `[<C-l>` | Same, location list | nvim |
| `]<C-t>` / `[<C-t>` | Next / previous **preview** tag | nvim |
| `]i` / `[i` | Bottom / top of indent scope | mini.indentscope |
| `]<Space>` / `[<Space>` | Add empty line below / above | nvim |
| `g[` / `g]` | Move to left / right "around" | mini.ai |

## LSP & Diagnostics
| Keys | Action | Source |
|------|--------|--------|
| `gd` | Go to definition | you |
| `grn` | **Rename symbol** | nvim |
| `grr` | References | nvim |
| `gra` | Code action (`n`/`x`) | nvim |
| `gri` | Implementation | nvim |
| `grt` | Type definition | nvim |
| `<C-s>` (i/s) | Signature help | nvim |
| `gl` | Show diagnostic float | you |
| `[d` / `]d` | Prev / next diagnostic | you |
| `[D` / `]D` | First / last diagnostic in buffer | nvim |
| `<C-w>d` | Diagnostics under cursor | nvim |
| `<leader>q` | Diagnostics → loclist | you |
| `<leader>lsp` | `:LspRestart` | you |
| `<leader>fm` | Format buffer (conform) | you |

## Renaming
| Keys | Action | Source |
|------|--------|--------|
| `<leader>rn` | **Rename symbol project-wide (LSP)** — semantic, skips strings/comments | you |
| `<leader>rw` | Rename word in buffer — old name prefilled, `<C-w>` clears it | you |
| `<leader>rp` | Rename word project-wide (ripgrep + `cfdo`), writes files directly | you |

> `rw` and `rp` are plain text substitution for filetypes with no LSP — they *will* hit
> strings and comments. `u` undoes `rw`; `rp` has no undo, it saves as it goes.

## Editing
| Keys | Action | Source |
|------|--------|--------|
| `<leader>d` (n/v) | Delete into black hole (no yank) | you |
| `<leader>p` (x) | Paste over selection, keep yank | you |
| `J` / `K` (v) | Move selection down / up | you |
| `J` (n) | Join lines, keep cursor | you |
| `<M-h/j/k/l>` | Move line or selection left/down/up/right | mini.move |
| `gy` / `gp` | Copy to / paste from system clipboard | mini.basics |
| `go` / `gO` | Put empty line below / above | mini.basics |
| `gS` | Split / join arguments | mini.splitjoin |
| `ga` / `gA` | Align / align with preview | mini.align |
| `gc` (n/x/o) · `gcc` | Comment selection/textobject · comment line | mini.comment |
| `g/` (x) | Search inside visual selection | mini.basics |
| `<leader>xh` / `<leader>xr` | Buffer → hex / hex → buffer (xxd) | you |

## Text Objects (mini.ai)
`i` = inside · `a` = around — usable after any operator or in visual.

| Keys | Action |
|------|--------|
| `ii` / `ai` | Indent scope / with border |
| `in` / `an` | **Next** inside / around |
| `il` / `al` | **Last** inside / around |
| `gh` (o) | Hunk range textobject |

## Surround (mini.surround) — `s` prefix
| Keys | Action |
|------|--------|
| `sa` | Add surrounding (n + motion, or x on selection) |
| `sd` / `sr` | Delete / replace surrounding |
| `sf` / `sF` | Find right / left surrounding |
| `sh` | Highlight surrounding |
| `sdn` / `sdl` | Delete **next** / **last** surrounding |
| `srn` / `srl` | Replace next / last · same `n`/`l` suffix works on `sf`, `sF`, `sh` |

## Git & Diff hunks
| Keys | Action | Source |
|------|--------|--------|
| `]h` / `[h` | Next / previous hunk | mini.diff |
| `]H` / `[H` | Last / first hunk | mini.diff |
| `gh` | Apply hunks (operator) | mini.diff |
| `gH` | Reset hunks | mini.diff |
| `gV` | Visually select changed text | mini.diff |

## Option toggles — `\` prefix (mini.basics)
`\w` wrap · `\n` number · `\r` relativenumber · `\c` cursorline · `\C` cursorcolumn
`\h` search highlight · `\i` ignorecase · `\l` list · `\s` spell · `\d` diagnostics · `\b` background

## AI — CodeCompanion
| Keys | Action |
|------|--------|
| `<C-a>` (n/v) | Action palette |
| `<localleader>a` (`Space a`) | Toggle chat |
| `<localleader>i` (`Space i`) (n) | Inline on whole buffer |
| `<localleader>i` (`Space i`) (v) | Inline on selection |
| `<localleader>cl` (`Space cl`) | Toggle CodeCompanion CLI |
| `ag` (v) | Add selection to chat |
| `:cc` | Command abbrev → `CodeCompanion` |

## Completion (blink.cmp)
| Keys | Mode | Action |
|------|------|--------|
| `<C-space>` | i | Show menu |
| `<C-n>` / `<C-p>` · `<Down>` / `<Up>` | i | Select next / prev |
| `<C-y>` | i | Select and accept |
| `<C-e>` | i | Cancel |
| `<CR>` | i | Accept (your override) |
| `<C-k>` | i | Toggle signature help |
| `<C-b>` / `<C-f>` | i | Scroll documentation up / down |
| `<Tab>` / `<S-Tab>` | i/s | Snippet jump forward / back |
| `<Tab>` / `<S-Tab>` | c | Cmdline: show + accept single / prev |
| `<C-n>` / `<C-p>` · `<Right>` / `<Left>` | c | Cmdline: select next / prev |
| `<C-y>` / `<C-e>` / `<End>` | c | Cmdline: accept / cancel / hide |
| `<Up>` / `<Down>` | c | Cmdline history (earlier / newer) |

Sources: LSP · snippets (`~/.config/nvim/snippets`, boosted +5) · path · buffer (−3)

## Insert-mode pairs (mini.pairs)
`(` `[` `{` auto-close · `)` `]` `}` skip over · `"` `'` `` ` `` close-or-open
`<BS>` deletes both halves · `<CR>` expands the pair onto its own line

## Macros
`@` / `Q` — run macro with mini.clue triggers disabled (avoids the popup mid-replay).

---

## mini.clue trigger keys
`<Leader>` · `g` · `z` · `'` · `` ` `` · `<C-w>` · `<C-x>`
Groups: `<leader>f`=find · `<leader>b`=buffer · `<leader>l`=lsp · `<leader>x`=hex · `<leader>r`=rename · `<leader>s`=split · `<leader>t`=terminal

> Not triggered today: `[` `]` `\` and `s`. Those groups exist but show no popup — add them to
> `triggers` in `lua/plugins/mini.lua` if you want the menu.

## Tooling (automatic)
- **Format on save** — stylua (lua) · ruff (python) · prettier (js/ts/html/css/md/json) · shfmt (sh)
- **Lint on save/read/insert-leave** — markdownlint (md) · eslint_d (js/ts)
- **LSP servers** — lua_ls · basedpyright · ruff · marksman · ts_ls · html · cssls · emmet_ls
- **Treesitter** — highlight + indent started per-buffer (nvim-treesitter `main` branch)
- **AI routing** — chat → Gemini Flash Lite · inline/cmd → Claude Haiku · CLI → claude (also gemini, codex)
- **Colorscheme** — tokyonight-moon (transparent)

> Also loaded but not listed: `matchit` (extends `%`) and the stock `python` ftplugin.
