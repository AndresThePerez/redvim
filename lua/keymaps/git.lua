-- Git keymaps

local map = vim.keymap.set

-- Telescope git pickers
map('n', '<leader>gb', '<cmd>Telescope git_branches<CR>', { desc = 'Git branches' })
map('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', { desc = 'Git commits' })
map('n', '<leader>gC', '<cmd>Telescope git_bcommits<CR>', { desc = 'Git buffer commits' })
map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', { desc = 'Git status' })
map('n', '<leader>gS', '<cmd>Telescope git_stash<CR>', { desc = 'Git stash' })

-- Git hunk navigation (these are also set in gitsigns on_attach)
map('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal({ ']c', bang = true })
  else
    require('gitsigns').nav_hunk('next')
  end
end, { desc = 'Next git change' })

map('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({ '[c', bang = true })
  else
    require('gitsigns').nav_hunk('prev')
  end
end, { desc = 'Previous git change' })

-- Git hunk actions (set up via gitsigns on_attach callback in plugin config)
-- These serve as fallbacks/documentation for the keymaps

-- Stage hunk
map({ 'n', 'v' }, '<leader>hs', function()
  require('gitsigns').stage_hunk()
end, { desc = 'Stage hunk' })

-- Reset hunk
map({ 'n', 'v' }, '<leader>hr', function()
  require('gitsigns').reset_hunk()
end, { desc = 'Reset hunk' })

-- Stage buffer
map('n', '<leader>hS', function()
  require('gitsigns').stage_buffer()
end, { desc = 'Stage buffer' })

-- Undo stage hunk
map('n', '<leader>hu', function()
  require('gitsigns').undo_stage_hunk()
end, { desc = 'Undo stage hunk' })

-- Reset buffer
map('n', '<leader>hR', function()
  require('gitsigns').reset_buffer()
end, { desc = 'Reset buffer' })

-- Preview hunk
map('n', '<leader>hp', function()
  require('gitsigns').preview_hunk()
end, { desc = 'Preview hunk' })

-- Blame line
map('n', '<leader>hb', function()
  require('gitsigns').blame_line({ full = false })
end, { desc = 'Blame line' })

map('n', '<leader>hB', function()
  require('gitsigns').blame_line({ full = true })
end, { desc = 'Blame line (full)' })

-- Diff
map('n', '<leader>hd', function()
  require('gitsigns').diffthis()
end, { desc = 'Diff against index' })

map('n', '<leader>hD', function()
  require('gitsigns').diffthis('@')
end, { desc = 'Diff against last commit' })

-- Toggle blame
map('n', '<leader>htb', function()
  require('gitsigns').toggle_current_line_blame()
end, { desc = 'Toggle line blame' })

-- Toggle deleted
map('n', '<leader>htd', function()
  require('gitsigns').toggle_deleted()
end, { desc = 'Toggle deleted' })

-- Text object for git hunks
map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })

return {}
