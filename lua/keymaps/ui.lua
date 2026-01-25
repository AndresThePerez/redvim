-- UI toggle keymaps

local map = vim.keymap.set
local utils = require('core.utils')

-- Toggle autopairs
map('n', '<leader>ua', function()
  utils.toggle_autopairs()
end, { desc = 'Toggle autopairs' })

-- Toggle background (dark/light)
map('n', '<leader>ub', function()
  utils.toggle_background()
end, { desc = 'Toggle background' })

-- Toggle completion (buffer)
map('n', '<leader>uc', function()
  utils.toggle_completion()
end, { desc = 'Toggle completion (buffer)' })

-- Toggle diagnostics
map('n', '<leader>ud', function()
  utils.toggle_diagnostics()
end, { desc = 'Toggle diagnostics' })

-- Toggle format on save (buffer)
map('n', '<leader>uf', function()
  utils.toggle_format_on_save()
end, { desc = 'Toggle format on save (buffer)' })

-- Toggle format on save (global)
map('n', '<leader>uF', function()
  vim.g.autoformat = not vim.g.autoformat
  if vim.g.autoformat then
    utils.notify('Enabled format on save (global)', vim.log.levels.INFO)
  else
    utils.notify('Disabled format on save (global)', vim.log.levels.INFO)
  end
end, { desc = 'Toggle format on save (global)' })

-- Toggle signcolumn
map('n', '<leader>ug', function()
  if vim.wo.signcolumn == 'no' then
    vim.wo.signcolumn = 'yes'
    utils.notify('Enabled signcolumn', vim.log.levels.INFO)
  else
    vim.wo.signcolumn = 'no'
    utils.notify('Disabled signcolumn', vim.log.levels.INFO)
  end
end, { desc = 'Toggle signcolumn' })

-- Toggle inlay hints
map('n', '<leader>uh', function()
  utils.toggle_inlay_hints()
end, { desc = 'Toggle inlay hints' })

-- Toggle indent guides
map('n', '<leader>ui', function()
  local ok, ibl = pcall(require, 'ibl')
  if ok then
    local enabled = require('ibl.config').get_config(0).enabled
    ibl.setup_buffer(0, { enabled = not enabled })
    if enabled then
      utils.notify('Disabled indent guides', vim.log.levels.INFO)
    else
      utils.notify('Enabled indent guides', vim.log.levels.INFO)
    end
  end
end, { desc = 'Toggle indent guides' })

-- Toggle statusline
map('n', '<leader>ul', function()
  utils.toggle_statusline()
end, { desc = 'Toggle statusline' })

-- Toggle line numbers
map('n', '<leader>un', function()
  utils.toggle_line_numbers()
end, { desc = 'Toggle line numbers' })

-- Toggle relative numbers
map('n', '<leader>uN', function()
  utils.toggle('relativenumber')
end, { desc = 'Toggle relative numbers' })

-- Toggle spellcheck
map('n', '<leader>us', function()
  utils.toggle('spell')
end, { desc = 'Toggle spellcheck' })

-- Toggle wrap
map('n', '<leader>uw', function()
  utils.toggle('wrap')
end, { desc = 'Toggle wrap' })

-- Toggle syntax highlighting
map('n', '<leader>uy', function()
  if vim.g.syntax_on then
    vim.cmd('syntax off')
    utils.notify('Disabled syntax highlighting', vim.log.levels.INFO)
  else
    vim.cmd('syntax on')
    utils.notify('Enabled syntax highlighting', vim.log.levels.INFO)
  end
end, { desc = 'Toggle syntax highlighting' })

-- Toggle conceal
map('n', '<leader>uz', function()
  utils.toggle_conceal()
end, { desc = 'Toggle conceal' })

-- Toggle cursorline
map('n', '<leader>uC', function()
  utils.toggle('cursorline')
end, { desc = 'Toggle cursorline' })

-- Toggle cursorcolumn
map('n', '<leader>uU', function()
  utils.toggle('cursorcolumn')
end, { desc = 'Toggle cursorcolumn' })

-- Toggle list (show whitespace)
map('n', '<leader>uL', function()
  utils.toggle('list')
end, { desc = 'Toggle list (whitespace)' })

-- Toggle treesitter context
map('n', '<leader>ut', function()
  utils.toggle_treesitter_context()
end, { desc = 'Toggle treesitter context' })

-- Toggle treesitter highlight
map('n', '<leader>uT', function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
    utils.notify('Disabled treesitter highlight', vim.log.levels.INFO)
  else
    vim.treesitter.start()
    utils.notify('Enabled treesitter highlight', vim.log.levels.INFO)
  end
end, { desc = 'Toggle treesitter highlight' })

-- Toggle virtual text diagnostics
map('n', '<leader>uv', function()
  local config = vim.diagnostic.config()
  if config.virtual_text then
    vim.diagnostic.config({ virtual_text = false })
    utils.notify('Disabled virtual text diagnostics', vim.log.levels.INFO)
  else
    vim.diagnostic.config({ virtual_text = true })
    utils.notify('Enabled virtual text diagnostics', vim.log.levels.INFO)
  end
end, { desc = 'Toggle virtual text diagnostics' })

-- Toggle minimap (if available)
map('n', '<leader>um', function()
  local ok = pcall(vim.cmd, 'MinimapToggle')
  if not ok then
    utils.notify('Minimap not available', vim.log.levels.WARN)
  end
end, { desc = 'Toggle minimap' })

-- Toggle zen mode (if available)
map('n', '<leader>uZ', function()
  local ok, zen = pcall(require, 'zen-mode')
  if ok then
    zen.toggle()
  else
    utils.notify('zen-mode not available', vim.log.levels.WARN)
  end
end, { desc = 'Toggle zen mode' })

-- Maximize/restore current window
map('n', '<leader>uM', function()
  if vim.t.maximized then
    vim.cmd('wincmd =')
    vim.t.maximized = false
    utils.notify('Restored window layout', vim.log.levels.INFO)
  else
    vim.cmd('wincmd _')
    vim.cmd('wincmd |')
    vim.t.maximized = true
    utils.notify('Maximized current window', vim.log.levels.INFO)
  end
end, { desc = 'Maximize/restore window' })

return {}
