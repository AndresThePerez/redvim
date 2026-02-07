# RedVim

```
  ██████  ███████ ██████  ██    ██ ██ ███    ███
  ██   ██ ██      ██   ██ ██    ██ ██ ████  ████
  ██████  █████   ██   ██ ██    ██ ██ ██ ████ ██
  ██   ██ ██      ██   ██  ██  ██  ██ ██  ██  ██
  ██   ██ ███████ ██████    ████   ██ ██      ██
```

A fast, modular Neovim configuration with first-class Python/PyTorch support, Golang support, and AstroNvim-style keybindings.

## Features

- **Modular Architecture** - Clean separation of options, keymaps, and plugins
- **Python IDE Experience** - Dual LSP setup (Pyright + Pylsp) for type checking AND rich documentation
- **Golang Support** - gopls with goimports/gofumpt formatting and golangci-lint
- **PyTorch/NumPy Support** - Hover documentation that actually works for ML libraries
- **Snacks.picker** - Fast fuzzy finder with NvChad-style theme (replaces Telescope)
- **NvChad Statusline** - Heirline with powerline separators and dynamic mode colors
- **40+ UI Toggles** - Quick toggles for diagnostics, formatting, line numbers, and more
- **Modern Plugins** - Snacks.nvim, Neo-tree, Treesitter, Gitsigns, blink.cmp, and more
- **Debug Support** - nvim-dap with Python and PHP configurations
- **Session Management** - Auto-save and restore your workspace
- **AI Completion** - GitHub Copilot via copilot.lua with Alt-based keymaps

## Screenshots

<!-- Add your screenshots here -->

## Requirements

- Neovim >= 0.10
- Git
- A C compiler (gcc)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- A [Nerd Font](https://www.nerdfonts.com/)
- Node.js (for some LSP servers and markdown preview)

### Fedora

```bash
sudo dnf install -y gcc make git ripgrep fd-find unzip neovim nodejs
```

### Ubuntu/Debian

```bash
sudo apt install -y gcc make git ripgrep fd-find unzip neovim nodejs npm
```

### Arch

```bash
sudo pacman -S gcc make git ripgrep fd unzip neovim nodejs npm
```

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone RedVim
git clone https://github.com/yourusername/redvim.git ~/.config/nvim

# Start Neovim (plugins install automatically)
nvim
```

After first launch:
1. Run `:Lazy sync` to ensure all plugins are installed
2. Run `:Mason` to install LSP servers and tools
3. Run `:checkhealth` to verify everything works

## Keybindings

Leader key: `Space`

### General

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Window navigation |
| `<C-Up/Down/Left/Right>` | Smart window resizing |
| `<C-s>` | Save file |
| `jj` / `jk` | Escape insert mode (better-escape.nvim) |
| `K` | Hover documentation (LSP) |

### Find (`<leader>f`)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fw` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fo` | Recent files |
| `<leader>fk` | Keymaps |
| `<leader>fh` | Help tags |
| `<leader>f'` | Resume last picker |

### LSP (`<leader>l`)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `gO` | Document symbols |
| `<leader>la` | Code actions |
| `<leader>lr` | Rename symbol |
| `<leader>lf` | Format |
| `<leader>ld` | Line diagnostics |
| `<leader>lh` | Toggle inlay hints |

### Git (`<leader>g`)

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |
| `<leader>gt` | Git status |
| `<leader>gb` | Git branches |
| `<leader>gc` | Git commits |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line |

### Buffer (`<leader>b`)

| Key | Action |
|-----|--------|
| `<S-h>` / `<S-l>` | Previous / Next buffer |
| `<leader>c` | Close buffer |
| `<leader>bc` | Close other buffers |
| `<leader>bl` | Close buffers to the left |
| `<leader>br` | Close buffers to the right |

### Terminal (`<leader>t`)

| Key | Action |
|-----|--------|
| `<leader>tf` | Float terminal |
| `<leader>th` | Horizontal terminal (bottom) |
| `<leader>tv` | Vertical terminal (right) |
| `<leader>tc` | Claude Code terminal |
| `<leader>tt` / `<F7>` | Toggle terminal |
| `<leader>D` | LazyDocker |

### UI Toggles (`<leader>u`)

| Key | Action |
|-----|--------|
| `<leader>ud` | Toggle diagnostics |
| `<leader>uf` | Toggle format on save |
| `<leader>un` | Cycle line numbers |
| `<leader>uw` | Toggle word wrap |

### File Explorer

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>o` | Toggle explorer focus |
| `<leader>E` | Reveal file in explorer |

### Python

| Key | Action |
|-----|--------|
| `<leader>cv` | Select Python venv |
| `K` | Show PyTorch/NumPy docs |

### Session (`<leader>S`)

| Key | Action |
|-----|--------|
| `<leader>Ss` | Save session |
| `<leader>Sl` | Load last session |
| `<leader>Sf` | Search sessions |
| `<leader>Sr` | Restore session for cwd |

### Debug (`<leader>d`)

| Key | Action |
|-----|--------|
| `<F5>` | Continue |
| `<F9>` | Toggle breakpoint |
| `<F10>` | Step over |
| `<F11>` | Step into |

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── core/
│   │   ├── options.lua      # Vim options
│   │   ├── autocmds.lua     # Autocommands
│   │   └── utils.lua        # Helper functions
│   ├── keymaps/
│   │   ├── general.lua      # Navigation, splits, resize
│   │   ├── buffer.lua       # Buffer management
│   │   ├── lsp.lua          # LSP keymaps
│   │   ├── picker.lua       # Snacks.picker
│   │   ├── git.lua          # Git + hunk actions
│   │   ├── terminal.lua     # Terminal + LazyGit
│   │   ├── misc.lua         # Explorer, comments, packages
│   │   ├── ui.lua           # UI toggles
│   │   └── debug.lua        # DAP keymaps
│   └── plugins/
│       ├── init.lua         # Core plugins
│       ├── heirline.lua     # NvChad-style statusline
│       ├── python.lua       # Python/PyTorch setup
│       ├── golang.lua       # Golang setup
│       ├── php.lua          # PHP setup
│       ├── markdown.lua     # Markdown preview
│       ├── dashboard.lua    # Start screen
│       ├── lazydocker.lua   # LazyDocker integration
│       └── sessions.lua     # Session management
```

## Python/PyTorch Setup

RedVim uses a dual LSP setup for the best Python experience:

- **Pyright** - Fast type checking
- **Pylsp (Jedi)** - Rich documentation hover

This means when you press `K` over `torch.mean()`, you get actual PyTorch documentation instead of "Unknown".

### Setup

1. Select your virtual environment: `<leader>cv`
2. Ensure PyTorch/NumPy are installed in that venv
3. Hover over any function and press `K`

## Golang Setup

Golang support includes:

- **gopls** LSP with analyses, staticcheck, and inlay hints
- **goimports** + **gofumpt** formatting via conform.nvim
- **golangci-lint** for additional linting
- Treesitter parsers: go, gomod, gowork, gosum

## Customization

| What | Where |
|------|-------|
| Vim options | `lua/core/options.lua` |
| Keybindings | `lua/keymaps/` |
| Plugins | `lua/plugins/` |
| Colorscheme | `lua/plugins/init.lua` |
| Statusline | `lua/plugins/heirline.lua` |
| Dashboard | `lua/plugins/dashboard.lua` |

## Adding Language Support

Create `lua/plugins/{language}.lua`:

```lua
return {
  -- LSP
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        your_lsp = { settings = {} },
      },
    },
  },

  -- Mason tools
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'your-lsp', 'your-formatter' })
    end,
  },

  -- Formatter
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        yourlang = { 'your-formatter' },
      },
    },
  },
}
```

## Credits

Built with these amazing projects:

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [AstroNvim](https://github.com/AstroNvim/AstroNvim) - Keybinding inspiration & theme
- [Snacks.nvim](https://github.com/folke/snacks.nvim) - Picker, notifier, and utilities
- [Heirline](https://github.com/rebelot/heirline.nvim) - NvChad-style statusline
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configurations
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - AI code completion

## License

MIT
