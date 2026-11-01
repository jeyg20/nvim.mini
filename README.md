# nvim.mini

My Neovim config: lazy.nvim, built around `mini.nvim`, with native LSP
(`vim.lsp.config`), blink.cmp, conform, nvim-lint, treesitter (`main`
branch) and CodeCompanion for AI. The main target is WSL (Ubuntu), but it runs
on any Linux or macOS once the clipboard note below is handled.

- Keymaps: [CHEATSHEET.md](CHEATSHEET.md)
- How the config is organized: [AI_CONTEXT.md](AI_CONTEXT.md)

## Requirements

| Dependency                            | Why                                                                   |
| ------------------------------------- | --------------------------------------------------------------------- |
| Neovim **0.12+** (latest stable)      | nvim-treesitter `main` targets the latest stable release              |
| `git`, `curl`, `tar`, `gzip`, `unzip` | lazy.nvim bootstrap, Mason downloads, treesitter parser downloads     |
| C compiler (`gcc`/`clang`) + `make`   | builds treesitter parsers                                             |
| `tree-sitter` CLI **0.26.1+**         | nvim-treesitter `main` compiles parsers with it (do **not** use npm)  |
| `ripgrep` (`rg`)                      | `:grep`, `<leader>fg` live grep, `<leader>rp` project rename          |
| Node.js 18+ and `npm`                 | Mason npm packages (ts_ls, prettier, eslint_d, html/css/emmet LSPs)   |
| Python 3 + `venv`                     | Mason pip packages (basedpyright, ruff)                               |
| `xxd`                                 | `<leader>xh` / `<leader>xr` hex view                                  |
| A Nerd Font in the terminal           | icons (`mini.icons`, statusline, tabline)                             |
| `win32yank.exe` (WSL only)            | system clipboard bridge (see [Clipboard](#clipboard))                 |

Optional, for AI features (CodeCompanion):

| Dependency                                        | Used for                                         |
| ------------------------------------------------- | ------------------------------------------------ |
| `claude` (Claude Code CLI)                        | CLI terminal (`<localleader>cl`)                 |
| `claude-agent-acp` (npm)                          | chat buffer (`<leader>ac`) via ACP               |
| `gemini` (npm `@google/gemini-cli`)               | alternate ACP/CLI agent                          |
| `codex` (npm `@openai/codex`)                     | alternate ACP/CLI agent                          |
| Env vars `ANTHROPIC_OAUTH_TOKEN`, `GEMINI_API_KEY`, `GPT_KEY` | auth (see [AI setup](#ai-setup))   |

Mason installs the LSPs, formatters and linters for you on first start. You do
not install them yourself.

## Install: Ubuntu / Debian / WSL

```sh
# 1. System packages
sudo apt update
sudo apt install -y git curl tar gzip unzip build-essential ripgrep xxd \
    python3 python3-venv python3-pip

# 2. Neovim (apt's version is too old; use the official release build)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz
nvim --version | head -1   # must be 0.12 or later

# 3. tree-sitter CLI (prebuilt release binary)
curl -L https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz \
    | gunzip > /tmp/tree-sitter
sudo install -m 755 /tmp/tree-sitter /usr/local/bin/tree-sitter
tree-sitter --version      # must be 0.26.1 or later
#    Alternative if you have Rust: cargo install --locked tree-sitter-cli

# 4. Node.js via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
source ~/.nvm/nvm.sh
nvm install --lts
```

On ARM Linux, replace `x86_64` with `arm64` in the Neovim tarball name and
`x64` with `arm64` in the tree-sitter one.

### WSL only: clipboard bridge

```sh
curl -LO https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
unzip -o win32yank-x64.zip win32yank.exe
sudo install -m 755 win32yank.exe /usr/local/bin/win32yank.exe
rm win32yank-x64.zip win32yank.exe
```

Install the Nerd Font on the **Windows** side (for example JetBrainsMono Nerd
Font from <https://www.nerdfonts.com>) and select it in Windows Terminal.

## Install: macOS

```sh
brew install neovim git curl ripgrep tree-sitter node python
# xxd ships with macOS (part of vim).
brew install --cask font-jetbrains-mono-nerd-font
```

Then pick the font in your terminal. See [Clipboard](#clipboard): the WSL
clipboard override must not run on macOS.

## Install: Arch

```sh
sudo pacman -S --needed neovim git curl tar gzip unzip base-devel ripgrep \
    tree-sitter-cli nodejs npm python tinyxxd ttf-jetbrains-mono-nerd
```

## Install the config

```sh
# Back up any existing config and data
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
[ -d ~/.local/share/nvim ] && mv ~/.local/share/nvim ~/.local/share/nvim.bak

git clone git@github.com:jeyg20/nvim.mini.git ~/.config/nvim
#   or over HTTPS: git clone https://github.com/jeyg20/nvim.mini.git ~/.config/nvim

# Install plugins at the exact commits in lazy-lock.json
nvim --headless "+Lazy! restore" +qa

# First real start: Mason installs the tools and treesitter compiles parsers.
# Wait for both to finish (watch :Mason), then restart nvim.
nvim
```

Then check everything inside Neovim:

```vim
:checkhealth
:Mason          " all packages should show as installed
```

### What Mason installs

LSPs: `lua_ls`, `basedpyright`, `ruff`, `marksman`, `ts_ls`, `html-lsp`,
`css-lsp`, `emmet-ls`.
Formatters and linters: `stylua`, `prettier`, `shfmt`, `markdownlint`,
`eslint_d`.

Treesitter parsers: lua, luadoc, python, javascript, typescript, tsx, jsdoc,
html, css, json, yaml, toml, bash, markdown, markdown_inline, diff, query,
vim, vimdoc.

## AI setup

Skip this section if you don't use CodeCompanion. The rest of the config works
without it.

```sh
# Claude Code CLI
curl -fsSL https://claude.ai/install.sh | bash

# ACP bridge for the chat buffer, plus the alternate agents
npm install -g @agentclientprotocol/claude-agent-acp @google/gemini-cli @openai/codex

# Long-lived token that bills your Claude subscription
claude setup-token
```

Add the keys to `~/.zshrc` (or `~/.bashrc`):

```sh
export ANTHROPIC_OAUTH_TOKEN="..."   # from `claude setup-token`
export GEMINI_API_KEY="..."          # chat titles + Gemini agent
export GPT_KEY="..."                 # inline edits, :CodeCompanionCmd, Codex agent
```

Never export `ANTHROPIC_API_KEY`. Claude Code prefers it over the subscription
token and bills the API instead.

## Clipboard

`lua/config/options.lua` always sets `vim.g.clipboard` to `win32yank.exe`.
That only works on WSL. On native Linux or macOS, delete that
`vim.g.clipboard = { ... }` block and keep `vim.opt.clipboard = "unnamedplus"`.
Neovim then finds the system clipboard on its own (`pbcopy` on macOS,
`wl-copy`/`xclip` on Linux; install `wl-clipboard` or `xclip` if missing).

## Useful commands

| Command                     | What it does                                           |
| --------------------------- | ------------------------------------------------------ |
| `:Lazy`                     | plugin manager UI                                      |
| `:Lazy restore`             | reset plugins to the commits in `lazy-lock.json`       |
| `:Lazy update`              | update plugins (then commit `lazy-lock.json`)          |
| `:Mason`                    | LSP / formatter / linter installer UI                  |
| `:MasonToolsUpdate`         | update Mason tools (auto-update is off)                |
| `:TSUpdate`                 | update treesitter parsers                              |
| `:FormatToggle` / `:FormatToggle!` | toggle format-on-save globally / for this buffer |
| `:TimeTracker`              | time spent per project (local, no service)             |
| `:CodeCompanion` (`:cc`)    | AI prompt; `<leader>aa` opens the actions palette      |
| `:checkhealth`              | diagnose missing dependencies                          |

Everything else is in [CHEATSHEET.md](CHEATSHEET.md).

## Troubleshooting

- **Treesitter errors about the CLI or ABI:** check `tree-sitter --version`
  (0.26.1+) and `nvim --version` (0.12+), then run `:TSUpdate`.
- **A Mason package fails to install:** open `:Mason`, press `l` on it for the
  log. Usually `npm` (Node missing) or `python3 -m venv` (install
  `python3-venv`).
- **Boxes instead of icons:** the terminal font isn't a Nerd Font.
- **Clipboard error on startup outside WSL:** see [Clipboard](#clipboard).
