-- Markdown language configuration
-- LSP: marksman
-- Preview: markdown-preview.nvim
-- Rendering: markview.nvim (already installed)

return {
  -- Markdown-specific LSP configuration
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        marksman = {
          filetypes = { 'markdown', 'markdown.mdx' },
        },
      },
    },
  },

  -- Mason tool installer for Markdown tools
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'marksman',
        'markdownlint',
        'prettier',
      })
    end,
  },

  -- Conform formatter configuration for Markdown
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        markdown = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
      },
    },
  },

  -- Markdown Preview
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npm install',
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', desc = 'Markdown preview' },
    },
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_theme = 'dark'
    end,
  },

  -- Markview (markdown rendering in buffer)
  -- Only renders when not in insert mode and cursor is not on current line
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = { 'saghen/blink.cmp' },
    opts = {
      -- Only render in normal mode, not while editing
      modes = { 'n', 'c' },
      -- Hybrid mode shows raw markdown on cursor line
      hybrid_modes = { 'n' },
      -- Don't mess with conceallevel globally - let it render without hiding line content
      callbacks = {
        on_enable = function(_, win)
          -- Use conceallevel 0 to prevent line number jumping
          -- Markview will handle rendering via extmarks instead
          vim.wo[win].conceallevel = 0
        end,
      },
    },
  },

  -- Treesitter for Markdown
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'markdown',
        'markdown_inline',
      })
    end,
  },

}
