-- Plugin specifications
-- This file loads all plugin modules

return {
  -- Core dependencies
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- Colorscheme (AstroNvim theme)
  {
    'AstroNvim/astrotheme',
    lazy = false,
    priority = 1000,
    config = function()
      require('astrotheme').setup({
        palette = 'astrodark',
        style = {
          transparent = false,
          inactive = true,
          float = true,
          neotree = true,
          border = true,
          title_invert = true,
          italic_comments = false,
          simple_syntax_colors = false,
        },
        termguicolors = true,
        terminal_color = true,
      })
      vim.cmd.colorscheme('astrodark')
    end,
  },

  -- Which-key (keybinding hints)
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ', Down = '<Down> ', Left = '<Left> ', Right = '<Right> ',
          C = '<C-…> ', M = '<M-…> ', D = '<D-…> ', S = '<S-…> ',
          CR = '<CR> ', Esc = '<Esc> ', ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ', NL = '<NL> ', BS = '<BS> ',
          Space = '<Space> ', Tab = '<Tab> ',
          F1 = '<F1>', F2 = '<F2>', F3 = '<F3>', F4 = '<F4>', F5 = '<F5>',
          F6 = '<F6>', F7 = '<F7>', F8 = '<F8>', F9 = '<F9>', F10 = '<F10>',
          F11 = '<F11>', F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>b', group = 'Buffer' },
        { '<leader>bs', group = 'Sort' },
        { '<leader>c', group = 'Code/Close' },
        { '<leader>d', group = 'Debug' },
        { '<leader>f', group = 'Find' },
        { '<leader>g', group = 'Git' },
        { '<leader>gh', group = 'Hunk', mode = { 'n', 'v' } },
        { '<leader>ght', group = 'Toggle' },
        { '<leader>l', group = 'LSP' },
        { '<leader>m', group = 'Markdown' },
        { '<leader>p', group = 'Packages' },
        { '<leader>S', group = 'Session' },
        { '<leader>t', group = 'Terminal' },
        { '<leader>u', group = 'UI Toggle' },
        { '<leader>y', group = 'Yank' },
        { '<leader><tab>', group = 'Tabs' },
      },
    },
  },

  -- Snacks.nvim (picker, notifier, and more)
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        ui_select = true,
        sources = {
          files = {
            hidden = true,
            ignored = false,
            exclude = { '.git/', 'node_modules/', '.cache/' },
          },
        },
        win = {
          input = {
            keys = {
              ['<C-j>'] = { 'list_down', mode = { 'i', 'n' } },
              ['<C-k>'] = { 'list_up', mode = { 'i', 'n' } },
            },
          },
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
        style = 'compact',
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)

      -- NvChad picker theme highlights
      local function set_nvchad_picker_highlights()
        local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
        local visual = vim.api.nvim_get_hl(0, { name = 'Visual' })
        local string_hl = vim.api.nvim_get_hl(0, { name = 'String' })
        local error_hl = vim.api.nvim_get_hl(0, { name = 'Error' })
        local bg = normal.bg
        local bg_alt = visual.bg
        local green = string_hl.fg
        local red = error_hl.fg
        vim.api.nvim_set_hl(0, 'SnacksPickerBorder', { fg = bg_alt, bg = bg })
        vim.api.nvim_set_hl(0, 'SnacksPicker', { bg = bg })
        vim.api.nvim_set_hl(0, 'SnacksPickerPreviewBorder', { fg = bg, bg = bg })
        vim.api.nvim_set_hl(0, 'SnacksPickerPreview', { bg = bg })
        vim.api.nvim_set_hl(0, 'SnacksPickerPreviewTitle', { fg = bg, bg = green })
        vim.api.nvim_set_hl(0, 'SnacksPickerBoxBorder', { fg = bg, bg = bg })
        vim.api.nvim_set_hl(0, 'SnacksPickerInputBorder', { fg = bg_alt, bg = bg_alt })
        vim.api.nvim_set_hl(0, 'SnacksPickerInputSearch', { fg = red, bg = bg_alt })
        vim.api.nvim_set_hl(0, 'SnacksPickerListBorder', { fg = bg, bg = bg })
        vim.api.nvim_set_hl(0, 'SnacksPickerList', { bg = bg })
        vim.api.nvim_set_hl(0, 'SnacksPickerListTitle', { fg = bg, bg = bg })
      end

      -- Apply on load and on colorscheme change
      set_nvchad_picker_highlights()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('nvchad-picker-highlights', { clear = true }),
        callback = set_nvchad_picker_highlights,
      })
    end,
  },

  -- Neo-tree (file explorer)
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    lazy = false,
    opts = {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
      window = {
        position = 'left',
        width = 35,
      },
    },
  },

  -- Gitsigns
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.nav_hunk('next') end)
          return '<Ignore>'
        end, { expr = true, desc = 'Next git change' })
        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.nav_hunk('prev') end)
          return '<Ignore>'
        end, { expr = true, desc = 'Previous git change' })
      end,
    },
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash', 'c', 'diff', 'html', 'css', 'javascript', 'typescript',
        'lua', 'luadoc', 'markdown', 'markdown_inline', 'query',
        'vim', 'vimdoc', 'json', 'yaml', 'toml', 'xml',
        'python', 'php', 'phpdoc', 'regex',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    },
  },

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach-config', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- Document highlight
          if client and client.supports_method('textDocument/documentHighlight') then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(e)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = e.buf })
              end,
            })
          end
        end,
      })

      -- Diagnostic config
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = { source = 'if_many', spacing = 2 },
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { globals = { 'vim' } },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua' })

      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      require('mason-lspconfig').setup({
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  },

  -- Lazydev for Neovim Lua development
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- Autocompletion
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
      },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        list = { selection = { preselect = true, auto_insert = false } },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },

  -- Autoformat
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local utils = require('core.utils')
        if not utils.format_on_save_enabled(bufnr) then
          return nil
        end
        if vim.g.autoformat == false then
          return nil
        end
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  },

  -- Comment.nvim
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      padding = true,
      sticky = true,
      toggler = { line = 'gcc', block = 'gbc' },
      opleader = { line = 'gc', block = 'gb' },
      extra = { above = 'gcO', below = 'gco', eol = 'gcA' },
      mappings = { basic = true, extra = true },
    },
  },

  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  -- Better Escape
  {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    opts = {
      timeout = 300,
      mappings = {
        i = { j = { j = '<Esc>', k = '<Esc>' } },
        c = { j = { j = '<Esc>', k = '<Esc>' } },
        t = { j = { k = '<C-\\><C-n>' } },
      },
    },
  },
  
  -- Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<M-l>',
          accept_word = '<M-k>',
          accept_line = '<M-j>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = true },
      filetypes = {
        markdown = true,
        help = false,
      },
    },
  },

  -- Mini.nvim modules
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.ai').setup({ n_lines = 500 })
      require('mini.surround').setup()
      require('mini.bufremove').setup()
    end,
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    main = 'ibl',
    opts = {
      indent = { char = '│' },
      scope = { enabled = true },
    },
  },

  -- Todo comments
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- ToggleTerm (AstroNvim style configuration)
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    cmd = { 'ToggleTerm', 'TermExec', 'ToggleTermToggleAll' },
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return math.ceil(vim.o.columns * 0.35)
        end
      end,
      open_mapping = false,
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      terminal_mappings = true,
      persist_size = true,
      direction = 'horizontal',
      close_on_exit = true,
      float_opts = {
        border = 'rounded',
        width = function() return math.ceil(vim.o.columns * 0.8) end,
        height = function() return math.ceil(vim.o.lines * 0.8) end,
      },
      highlights = {
        Normal = { link = 'Normal' },
        NormalNC = { link = 'NormalNC' },
        NormalFloat = { link = 'NormalFloat' },
        FloatBorder = { link = 'FloatBorder' },
        StatusLine = { link = 'StatusLine' },
        StatusLineNC = { link = 'StatusLineNC' },
        WinBar = { link = 'WinBar' },
        WinBarNC = { link = 'WinBarNC' },
      },
      on_create = function(t)
        vim.opt_local.foldcolumn = '0'
        vim.opt_local.signcolumn = 'no'
        if t.hidden then
          local function toggle() t:toggle() end
          vim.keymap.set({ 'n', 't', 'i' }, "<C-'>", toggle, { desc = 'Toggle terminal', buffer = t.bufnr })
          vim.keymap.set({ 'n', 't', 'i' }, '<F7>', toggle, { desc = 'Toggle terminal', buffer = t.bufnr })
        end
      end,
    },
  },

  -- Import other plugin modules
  { import = 'plugins.heirline' },
  { import = 'plugins.dashboard' },
  { import = 'plugins.sessions' },
  { import = 'plugins.debug' },
  { import = 'plugins.php' },
  { import = 'plugins.python' },
  { import = 'plugins.markdown' },
  { import = 'plugins.golang' },
}
