-- Picker (Telescope) keymaps

local map = vim.keymap.set

-- Helper to check if telescope is loaded
local function telescope(builtin, opts)
  return function()
    require('telescope.builtin')[builtin](opts or {})
  end
end

-- Resume last picker
map('n', '<leader>f<CR>', telescope('resume'), { desc = 'Resume last picker' })
map('n', '<leader>fr', telescope('resume'), { desc = 'Resume last picker' })

-- Find files
map('n', '<leader>ff', telescope('find_files'), { desc = 'Find files' })
map('n', '<leader>fF', telescope('find_files', { hidden = true, no_ignore = true }), { desc = 'Find files (all)' })

-- Git files
map('n', '<leader>fg', telescope('git_files'), { desc = 'Find git files' })

-- Live grep
map('n', '<leader>fw', telescope('live_grep'), { desc = 'Live grep' })
map('n', '<leader>fW', telescope('live_grep', {
  additional_args = function()
    return { '--hidden', '--no-ignore' }
  end,
}), { desc = 'Live grep (all)' })

-- Grep word under cursor
map('n', '<leader>fc', telescope('grep_string'), { desc = 'Find word under cursor' })

-- Buffers
map('n', '<leader>fb', telescope('buffers', { sort_mru = true, sort_lastused = true }), { desc = 'Find buffers' })
map('n', '<leader>bb', telescope('buffers', { sort_mru = true, sort_lastused = true }), { desc = 'Buffer picker' })

-- Recent files
map('n', '<leader>fo', telescope('oldfiles'), { desc = 'Recent files' })

-- Help
map('n', '<leader>fh', telescope('help_tags'), { desc = 'Help tags' })

-- Keymaps
map('n', '<leader>fk', telescope('keymaps'), { desc = 'Keymaps' })

-- Commands
map('n', '<leader>fC', telescope('commands'), { desc = 'Commands' })

-- Command history
map('n', '<leader>f:', telescope('command_history'), { desc = 'Command history' })

-- Search history
map('n', '<leader>f/', telescope('search_history'), { desc = 'Search history' })

-- Colorschemes
map('n', '<leader>ft', telescope('colorscheme', { enable_preview = true }), { desc = 'Colorschemes' })

-- Marks
map('n', '<leader>fm', telescope('marks'), { desc = 'Marks' })

-- Registers
map('n', '<leader>fR', telescope('registers'), { desc = 'Registers' })

-- Diagnostics
map('n', '<leader>fd', telescope('diagnostics', { bufnr = 0 }), { desc = 'Buffer diagnostics' })
map('n', '<leader>fD', telescope('diagnostics'), { desc = 'Workspace diagnostics' })

-- Treesitter symbols
map('n', '<leader>fs', telescope('treesitter'), { desc = 'Treesitter symbols' })

-- Telescope pickers
map('n', '<leader>fP', telescope('builtin'), { desc = 'Telescope pickers' })

-- Current buffer fuzzy find
map('n', '<leader>f.', function()
  require('telescope.builtin').current_buffer_fuzzy_find(
    require('telescope.themes').get_dropdown({
      winblend = 10,
      previewer = false,
    })
  )
end, { desc = 'Fuzzy find in buffer' })

-- Live grep in open files
map('n', '<leader>f/', function()
  require('telescope.builtin').live_grep({
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  })
end, { desc = 'Grep in open files' })

-- Find in neovim config
map('n', '<leader>fn', function()
  require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })
end, { desc = 'Find neovim files' })

-- Spell suggest
map('n', 'z=', telescope('spell_suggest'), { desc = 'Spell suggestions' })

return {}
