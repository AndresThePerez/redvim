-- Terminal keymaps

local map = vim.keymap.set

-- Exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', 'jk', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Terminal navigation (when in terminal mode)
map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left window' })
map('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Move to lower window' })
map('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Move to upper window' })
map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Move to right window' })

-- Toggle terminal (these work with toggleterm plugin)
-- Note: Actual toggleterm keymaps are set in the plugin config

-- ToggleTerm mappings (will be overridden by plugin if loaded)
map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = 'Floating terminal' })
map('n', '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<CR>', { desc = 'Horizontal terminal' })
map('n', '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<CR>', { desc = 'Vertical terminal' })
map('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
map('n', '<F7>', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
map('t', '<F7>', '<C-\\><C-n><cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
map('n', "<C-'>", '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
map('t', "<C-'>", '<C-\\><C-n><cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })

-- LazyGit (mapped in plugin config as well)
map('n', '<leader>tl', '<cmd>LazyGit<CR>', { desc = 'LazyGit' })
map('n', '<leader>gg', '<cmd>LazyGit<CR>', { desc = 'LazyGit' })

-- LazyDocker
map('n', '<leader>td', function()
  local ok, lazydocker = pcall(require, 'lazydocker')
  if ok then
    lazydocker.open()
  else
    vim.notify('lazydocker.nvim not installed', vim.log.levels.WARN)
  end
end, { desc = 'LazyDocker' })

return {}
