# RedVim

```
  ██████  ███████ ██████  ██    ██ ██ ███    ███
  ██   ██ ██      ██   ██ ██    ██ ██ ████  ████
  ██████  █████   ██   ██ ██    ██ ██ ██ ████ ██
  ██   ██ ██      ██   ██  ██  ██  ██ ██  ██  ██
  ██   ██ ███████ ██████    ████   ██ ██      ██
```

A fast, modular Neovim configuration with first-class Python/PyTorch support and AstroNvim-style keybindings.

## Features

- **Modular Architecture** - Clean separation of options, keymaps, and plugins
- **Python IDE Experience** - Dual LSP setup (Pyright + Pylsp) for type checking AND rich documentation
- **PyTorch/NumPy Support** - Hover documentation that actually works for ML libraries
- **40+ UI Toggles** - Quick toggles for diagnostics, formatting, line numbers, and more
- **Modern Plugins** - Telescope, Neo-tree, Treesitter, Gitsigns, and more
- **Debug Support** - nvim-dap with Python and PHP configurations
- **Session Management** - Auto-save and restore your workspace

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
| `<C-s>` | Save file |
| `jj` / `jk` | Escape insert mode |
| `K` | Hover documentation |

### Find (`<leader>f`)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fw` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fo` | Recent files |

### LSP (`<leader>l`)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `<leader>la` | Code actions |
| `<leader>lr` | Rename symbol |
| `<leader>lf` | Format |

### Git (`<leader>g`)

| Key | Action |
|-----|--------|
| `<leader>gt` | Git status |
| `<leader>gb` | Git branches |
| `<leader>tl` | LazyGit |

### UI Toggles (`<leader>u`)

| Key | Action |
|-----|--------|
| `<leader>ud` | Toggle diagnostics |
| `<leader>uf` | Toggle format on save |
| `<leader>un` | Cycle line numbers |
| `<leader>uw` | Toggle word wrap |

### Python

| Key | Action |
|-----|--------|
| `<leader>cv` | Select Python venv |
| `K` | Show PyTorch/NumPy docs |

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
│   │   ├── general.lua      # Navigation, splits
│   │   ├── buffer.lua       # Buffer management
│   │   ├── lsp.lua          # LSP keymaps
│   │   ├── picker.lua       # Telescope
│   │   ├── ui.lua           # UI toggles
│   │   └── ...
│   └── plugins/
│       ├── init.lua         # Core plugins
│       ├── python.lua       # Python/PyTorch setup
│       ├── markdown.lua     # Markdown preview
│       ├── dashboard.lua    # Start screen
│       └── ...
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

## Customization

| What | Where |
|------|-------|
| Vim options | `lua/core/options.lua` |
| Keybindings | `lua/keymaps/` |
| Plugins | `lua/plugins/` |
| Colorscheme | `lua/plugins/init.lua` |
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
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configurations
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting

## License

MIT
