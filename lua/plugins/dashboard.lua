-- Dashboard configuration with alpha-nvim
-- Custom ASCII art and quick actions

return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    -- Custom ASCII art header - RedVim
    dashboard.section.header.val = {
      [[                                                    ]],
      [[  ██████  ███████ ██████  ██    ██ ██ ███    ███    ]],
      [[  ██   ██ ██      ██   ██ ██    ██ ██ ████  ████    ]],
      [[  ██████  █████   ██   ██ ██    ██ ██ ██ ████ ██    ]],
      [[  ██   ██ ██      ██   ██  ██  ██  ██ ██  ██  ██    ]],
      [[  ██   ██ ███████ ██████    ████   ██ ██      ██    ]],
      [[                                                    ]],
    }

    -- Menu buttons
    dashboard.section.buttons.val = {
      dashboard.button('f', '  Find file', ':Telescope find_files<CR>'),
      dashboard.button('n', '  New file', ':enew<CR>'),
      dashboard.button('r', '  Recent files', ':Telescope oldfiles<CR>'),
      dashboard.button('g', '  Find text', ':Telescope live_grep<CR>'),
      dashboard.button('c', '  Configuration', ':e $MYVIMRC<CR>'),
      dashboard.button('s', '  Restore session', ':lua require("persistence").load()<CR>'),
      dashboard.button('l', '󰒲  Lazy', ':Lazy<CR>'),
      dashboard.button('m', '  Mason', ':Mason<CR>'),
      dashboard.button('q', '  Quit', ':qa<CR>'),
    }

    -- Footer
    local function footer()
      local stats = require('lazy').stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      return '  redvim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
    end

    dashboard.section.footer.val = footer()

    -- Update footer after lazy loads
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      once = true,
      callback = function()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = '  redvim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- Highlight groups and centering
    dashboard.section.header.opts.hl = 'AlphaHeader'
    dashboard.section.header.opts.position = 'center'
    dashboard.section.buttons.opts.hl = 'AlphaButtons'
    dashboard.section.footer.opts.hl = 'AlphaFooter'
    dashboard.section.footer.opts.position = 'center'

    -- Layout
    dashboard.config.layout = {
      { type = 'padding', val = 2 },
      dashboard.section.header,
      { type = 'padding', val = 2 },
      dashboard.section.buttons,
      { type = 'padding', val = 1 },
      dashboard.section.footer,
    }

    -- Setup
    alpha.setup(dashboard.config)

    -- Disable folding on alpha buffer
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'alpha',
      callback = function()
        vim.opt_local.foldenable = false
      end,
    })

    -- Auto-close alpha when file is opened
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      callback = function()
        vim.opt.showtabline = 0
        vim.opt.laststatus = 0
        vim.api.nvim_create_autocmd('BufUnload', {
          buffer = 0,
          once = true,
          callback = function()
            vim.opt.showtabline = 2
            vim.opt.laststatus = 3
          end,
        })
      end,
    })
  end,
}
