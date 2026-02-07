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
Plugins use lazy.nvim's spec format. Language-specific configs (PHP, Python, Golang, Markdown) are in separate files that extend base plugin specs using the `opts` function pattern:

```lua
opts = function(_, opts)
  opts.ensure_installed = opts.ensure_installed or {}
  vim.list_extend(opts.ensure_installed, { 'new-tool' })
end
```

### Keymap Organization
Keymaps are split by domain in `lua/keymaps/`:
- `general.lua` - Navigation, splits, save/quit, window resizing
- `buffer.lua` - Buffer management (`<leader>b`)
- `lsp.lua` - LSP keymaps (set via LspAttach autocmd)
- `picker.lua` - Snacks.picker keymaps (`<leader>f`)
- `git.lua` - Git keymaps (`<leader>g`, `<leader>gh*` for hunks)
- `terminal.lua` - Terminal keymaps (`<leader>t`, LazyGit)
- `misc.lua` - Comments, file explorer, dashboard, packages, sessions
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
- Fuzzy finder: Snacks.picker (folke/snacks.nvim) with NvChad-style theme
- Statusline: Heirline with NvChad-style powerline separators
- Notifications: Snacks.notifier (replaces nvim-notify)
- Insert-mode escape: better-escape.nvim (jj/jk with timeout)
- AI completion: copilot.lua (Alt-based keymaps to avoid Tab conflicts)

## Adding Language Support

Create `lua/plugins/{language}.lua` with:
1. LSP server config extending nvim-lspconfig
2. Mason tools extending mason-tool-installer
3. Formatter config extending conform.nvim
4. Treesitter parsers extending nvim-treesitter

See `lua/plugins/python.lua`, `lua/plugins/php.lua`, or `lua/plugins/golang.lua` as templates.

## Python Configuration

Python uses a **dual LSP setup** for optimal experience:
- **Pyright**: Type checking only (hover disabled)
- **Pylsp with Jedi**: Documentation hover, completions, references

This is because Pyright shows "Unknown" for C++ implemented functions (like `torch.mean`). Jedi extracts docstrings properly from libraries like PyTorch/NumPy.

**Virtual environment**: Use `<leader>cv` (VenvSelect) to select the Python environment. LSP servers need the correct venv to find installed packages.

## Golang Configuration

- **LSP:** gopls with analyses, staticcheck, gofumpt, and inlay hints
- **Formatters:** goimports + gofumpt via conform.nvim
- **Mason tools:** gopls, goimports, gofumpt, golangci-lint
- Config at `lua/plugins/golang.lua`, lazy-loaded on Go filetypes

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

### Hover behavior
`K` is mapped to `vim.lsp.buf.hover` in `lua/keymaps/lsp.lua`. This provides basic LSP hover documentation.

### LSP not finding packages
Select the correct Python virtual environment with `<leader>cv`. The venv must have the packages installed for LSP to provide documentation.

### Window resizing inconsistency
Window resizing uses AstroNvim's `smart_resize` approach in `lua/keymaps/general.lua`. It checks the edge in the direction of the arrow press and inverts the resize amount if at the edge, so behavior is consistent regardless of which split is focused.

### Tab completion not working (blink.cmp)
Ensure the blink.cmp keymap config includes explicit Tab/S-Tab bindings:
```lua
keymap = {
  preset = 'default',
  ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
  ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
},
```
