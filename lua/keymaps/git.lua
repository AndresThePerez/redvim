-- Git keymaps

local map = vim.keymap.set

-- Git pickers (via Snacks.picker)
map('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = 'Git branches' })
map('n', '<leader>gc', function() Snacks.picker.git_log() end, { desc = 'Git commits' })
map('n', '<leader>gC', function() Snacks.picker.git_log_file() end, { desc = 'Git buffer commits' })
map('n', '<leader>gt', function() Snacks.picker.git_status() end, { desc = 'Git status' })
map('n', '<leader>gS', function() Snacks.picker.git_stash() end, { desc = 'Git stash' })

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

-- Git hunk actions (under <leader>gh* to avoid conflict with <leader>h for Dashboard)

-- Stage hunk
map({ 'n', 'v' }, '<leader>ghs', function()
  require('gitsigns').stage_hunk()
end, { desc = 'Stage hunk' })

-- Reset hunk
map({ 'n', 'v' }, '<leader>ghr', function()
  require('gitsigns').reset_hunk()
end, { desc = 'Reset hunk' })

-- Stage buffer
map('n', '<leader>ghS', function()
  require('gitsigns').stage_buffer()
end, { desc = 'Stage buffer' })

-- Undo stage hunk
map('n', '<leader>ghu', function()
  require('gitsigns').undo_stage_hunk()
end, { desc = 'Undo stage hunk' })

-- Reset buffer
map('n', '<leader>ghR', function()
  require('gitsigns').reset_buffer()
end, { desc = 'Reset buffer' })

-- Preview hunk
map('n', '<leader>ghp', function()
  require('gitsigns').preview_hunk()
end, { desc = 'Preview hunk' })

-- Blame line
map('n', '<leader>ghb', function()
  require('gitsigns').blame_line({ full = false })
end, { desc = 'Blame line' })

map('n', '<leader>ghB', function()
  require('gitsigns').blame_line({ full = true })
end, { desc = 'Blame line (full)' })

-- Diff
map('n', '<leader>ghd', function()
  require('gitsigns').diffthis()
end, { desc = 'Diff against index' })

map('n', '<leader>ghD', function()
  require('gitsigns').diffthis('@')
end, { desc = 'Diff against last commit' })

-- Toggle blame
map('n', '<leader>ghtb', function()
  require('gitsigns').toggle_current_line_blame()
end, { desc = 'Toggle line blame' })

-- Toggle deleted
map('n', '<leader>ghtd', function()
  require('gitsigns').toggle_deleted()
end, { desc = 'Toggle deleted' })

-- Text object for git hunks
map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })

return {}
