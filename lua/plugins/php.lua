-- PHP language configuration
-- LSP: phpactor
-- Formatters: php-cs-fixer (PSR-12)
-- Linters: phpcs, phpstan

return {
  -- PHP-specific LSP configuration
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        phpactor = {
          init_options = {
            ['language_server_phpstan.enabled'] = true,
            ['language_server_php_cs_fixer.enabled'] = true,
            ['indexer.exclude_patterns'] = {
              '/vendor/**/Tests/**/*',
              '/vendor/**/tests/**/*',
              '/var/cache/**/*',
              '/var/log/**/*',
            },
          },
          filetypes = { 'php' },
        },
        intelephense = {
          filetypes = { 'php' },
          settings = {
            intelephense = {
              stubs = {
                'bcmath', 'bz2', 'Core', 'curl', 'date', 'dom', 'fileinfo',
                'filter', 'gd', 'gettext', 'hash', 'iconv', 'intl', 'json',
                'libxml', 'mbstring', 'mcrypt', 'mysql', 'mysqli', 'password',
                'pcntl', 'pcre', 'PDO', 'pdo_mysql', 'Phar', 'readline',
                'regex', 'session', 'SimpleXML', 'sockets', 'sodium', 'standard',
                'superglobals', 'tokenizer', 'xml', 'xdebug', 'xmlreader',
                'xmlwriter', 'yaml', 'zip', 'zlib', 'wordpress', 'woocommerce',
              },
              environment = {
                includePaths = {
                  '/usr/share/php/',
                },
              },
              files = {
                maxSize = 5000000,
              },
            },
          },
        },
      },
    },
  },

  -- Mason tool installer for PHP tools
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'phpactor',
        'php-cs-fixer',
        'phpcs',
        'phpstan',
        'php-debug-adapter',
      })
    end,
  },

  -- Conform formatter configuration for PHP
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        php = { 'php_cs_fixer' },
      },
      formatters = {
        php_cs_fixer = {
          command = 'php-cs-fixer',
          args = {
            'fix',
            '--rules=@PSR12',
            '--using-cache=no',
            '--no-interaction',
            '--quiet',
            '$FILENAME',
          },
          stdin = false,
        },
      },
    },
  },

  -- Treesitter for PHP
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'php', 'phpdoc' })
    end,
  },
}
