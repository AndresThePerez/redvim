# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration ("RedVim") using lazy.nvim as the plugin manager. It follows a modular architecture with AstroNvim-style keybindings.

## Testing Changes

After modifying configuration files:
1. Restart Neovim or run `:source %` for the current file
2. Run `:Lazy sync` if plugin specs changed
3. Run `:checkhealth` to verify configuration health

For LSP/Mason changes:
- `:LspInfo` - Check active LSP servers
- `:Mason` - Manage LSP servers, formatters, linters

## Architecture

### Load Order
1. `init.lua` - Bootstraps lazy.nvim, loads core modules, then plugins
2. `lua/core/options.lua` - Vim options (loaded first for leader key)
3. `lua/core/autocmds.lua` - Autocommands
4. `lua/keymaps/init.lua` - Loads all keymap modules
5. Plugins loaded via lazy.nvim from `lua/plugins/`

### Plugin System
Plugins use lazy.nvim's spec format. Language-specific configs (PHP, Python, Markdown) are in separate files that extend base plugin specs using the `opts` function pattern:

```lua
opts = function(_, opts)
  opts.ensure_installed = opts.ensure_installed or {}
  vim.list_extend(opts.ensure_installed, { 'new-tool' })
end
```

### Keymap Organization
Keymaps are split by domain in `lua/keymaps/`:
- `general.lua` - Navigation, splits, save/quit
- `buffer.lua` - Buffer management (`<leader>b`)
- `lsp.lua` - LSP keymaps (set via LspAttach autocmd)
- `picker.lua` - Telescope keymaps (`<leader>f`)
- `ui.lua` - UI toggles (`<leader>u`)
- `debug.lua` - DAP keymaps (`<leader>d`)

LSP keymaps are attached per-buffer via autocmd, not globally.

### Utility Module
`lua/core/utils.lua` provides toggle helpers used throughout:
- `toggle(option)` - Toggle local option with notification
- `toggle_diagnostics()` - Toggle vim.diagnostic
- `toggle_inlay_hints(bufnr)` - Toggle LSP inlay hints
- `format_on_save_enabled(bufnr)` - Check if format-on-save is enabled
- `bufremove(buf)` - Delete buffer respecting mini.bufremove

## Key Conventions

- Leader: `<Space>`, Local leader: `,`
- Nerd Font required (`vim.g.have_nerd_font = true`)
- Autoformat disabled by default (`vim.g.autoformat = false`)
- Colorscheme: astrodark from AstroNvim/astrotheme
- Dashboard: `lua/plugins/dashboard.lua` (alpha-nvim with "RedVim" branding)

## Adding Language Support

Create `lua/plugins/{language}.lua` with:
1. LSP server config extending nvim-lspconfig
2. Mason tools extending mason-tool-installer
3. Formatter config extending conform.nvim
4. Treesitter parsers extending nvim-treesitter

See `lua/plugins/python.lua` or `lua/plugins/php.lua` as templates.

## Python Configuration

Python uses a **dual LSP setup** for optimal experience:
- **Pyright**: Type checking only (hover disabled)
- **Pylsp with Jedi**: Documentation hover, completions, references

This is because Pyright shows "Unknown" for C++ implemented functions (like `torch.mean`). Jedi extracts docstrings properly from libraries like PyTorch/NumPy.

**Virtual environment**: Use `<leader>cv` (VenvSelect) to select the Python environment. LSP servers need the correct venv to find installed packages.

## Markdown Configuration

- **Browser preview**: `<leader>mp` opens markdown-preview.nvim in browser
- **In-buffer rendering**: markview.nvim (set to `conceallevel = 0` to prevent line number display issues)

If markdown displays with jumbled line numbers, check that `conceallevel` is set to 0 in markview.nvim callbacks.

## Common Issues & Solutions

### Tildes (~) on empty lines
Controlled by `fillchars` in `lua/core/options.lua`:
```lua
vim.opt.fillchars:append({ eob = ' ' })
```

### Hover showing "Unknown" for Python libraries
Ensure pylsp is installed (`:Mason`) and the correct venv is selected (`<leader>cv`). Pyright's hover is disabled in favor of Jedi.

### Keybinding conflicts
The `K` key is mapped by both `lua/keymaps/lsp.lua` and hovercraft.nvim in `lua/plugins/init.lua`. Hovercraft takes precedence and wraps LSP hover with enhanced UI.

### LSP not finding packages
Select the correct Python virtual environment with `<leader>cv`. The venv must have the packages installed for LSP to provide documentation.
