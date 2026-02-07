-- Golang language configuration
-- LSP: gopls
-- Formatters: goimports, gofumpt
-- Linter: golangci-lint

return {
  -- Golang-specific LSP configuration
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
              },
              staticcheck = true,
              gofumpt = true,
              completeUnimported = true,
              usePlaceholders = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        },
      },
    },
  },

  -- Mason tool installer for Go tools
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'gopls',
        'goimports',
        'gofumpt',
        'golangci-lint',
      })
    end,
  },

  -- Conform formatter configuration for Go
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        go = { 'goimports', 'gofumpt' },
      },
    },
  },

  -- Treesitter for Go
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'go', 'gomod', 'gowork', 'gosum' })
    end,
  },
}
