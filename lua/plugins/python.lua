-- Python language configuration
-- LSP: pyright (type checking) + pylsp (documentation/hover)
-- Formatters: black, isort
-- Linter: ruff

return {
  -- Python-specific LSP configuration
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- Pyright for type checking (hover disabled - pylsp handles it)
        pyright = {
          on_attach = function(client, bufnr)
            -- Disable hover in pyright, let pylsp/jedi handle documentation
            client.server_capabilities.hoverProvider = false
          end,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
                typeCheckingMode = 'standard',
              },
            },
          },
        },
        -- Pylsp with Jedi for rich documentation hover
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                -- Enable jedi for completions and documentation
                jedi_completion = { enabled = true },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true },
                -- Disable plugins that conflict with other tools
                pylint = { enabled = false },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                mccabe = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- Keep rope for refactoring
                rope_autoimport = { enabled = true },
              },
            },
          },
        },
        ruff_lsp = {
          init_options = {
            settings = {
              args = {},
            },
          },
        },
      },
    },
  },

  -- Mason tool installer for Python tools
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'pyright',
        'python-lsp-server',  -- pylsp for Jedi-based documentation
        'ruff',
        'ruff-lsp',
        'black',
        'isort',
        'debugpy',
      })
    end,
  },

  -- Conform formatter configuration for Python
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        python = { 'isort', 'black' },
      },
      formatters = {
        black = {
          prepend_args = { '--line-length', '88' },
        },
        isort = {
          prepend_args = { '--profile', 'black' },
        },
      },
    },
  },

  -- Treesitter for Python
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'python', 'rst', 'toml' })
    end,
  },

  -- Virtual environment selector
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
    },
    branch = 'regexp',
    cmd = 'VenvSelect',
    opts = {
      name = { 'venv', '.venv', 'env', '.env' },
    },
    keys = {
      { '<leader>cv', '<cmd>VenvSelect<cr>', desc = 'Select Python venv' },
    },
  },
}
