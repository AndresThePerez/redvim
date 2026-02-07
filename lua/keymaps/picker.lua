-- Picker (Snacks.picker) keymaps

local map = vim.keymap.set

-- Resume last picker
map('n', '<leader>f<CR>', function() Snacks.picker.resume() end, { desc = 'Resume last picker' })
map('n', '<leader>fr', function() Snacks.picker.resume() end, { desc = 'Resume last picker' })

-- Find files
map('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find files' })
map('n', '<leader>fF', function() Snacks.picker.files({ hidden = true, ignored = true }) end, { desc = 'Find files (all)' })

-- Git files
map('n', '<leader>fg', function() Snacks.picker.git_files() end, { desc = 'Find git files' })

-- Live grep
map('n', '<leader>fw', function() Snacks.picker.grep() end, { desc = 'Live grep' })
map('n', '<leader>fW', function() Snacks.picker.grep({ hidden = true, ignored = true }) end, { desc = 'Live grep (all)' })

-- Grep word under cursor
map('n', '<leader>fc', function() Snacks.picker.grep_word() end, { desc = 'Find word under cursor' })

-- Buffers
map('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Find buffers' })

-- Recent files
map('n', '<leader>fo', function() Snacks.picker.recent() end, { desc = 'Recent files' })

-- Help
map('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Help tags' })

-- Keymaps
map('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })

-- Commands
map('n', '<leader>fC', function() Snacks.picker.commands() end, { desc = 'Commands' })

-- Command history
map('n', '<leader>f:', function() Snacks.picker.command_history() end, { desc = 'Command history' })

-- Search history
map('n', '<leader>f/', function() Snacks.picker.search_history() end, { desc = 'Search history' })

-- Colorschemes
map('n', '<leader>ft', function() Snacks.picker.colorschemes() end, { desc = 'Colorschemes' })

-- Marks
map('n', '<leader>fm', function() Snacks.picker.marks() end, { desc = 'Marks' })

-- Registers
map('n', '<leader>fR', function() Snacks.picker.registers() end, { desc = 'Registers' })

-- Diagnostics
map('n', '<leader>fd', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Buffer diagnostics' })
map('n', '<leader>fD', function() Snacks.picker.diagnostics() end, { desc = 'Workspace diagnostics' })

-- LSP symbols
map('n', '<leader>fs', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP symbols' })

-- All pickers
map('n', '<leader>fP', function() Snacks.picker.pickers() end, { desc = 'All pickers' })

-- Current buffer fuzzy find
map('n', '<leader>f.', function() Snacks.picker.lines() end, { desc = 'Fuzzy find in buffer' })

-- Grep in open files
map('n', '<leader>f/', function() Snacks.picker.grep_buffers() end, { desc = 'Grep in open files' })

-- Find in neovim config
map('n', '<leader>fn', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, { desc = 'Find neovim files' })

-- Spell suggest
map('n', 'z=', function() Snacks.picker.spelling() end, { desc = 'Spell suggestions' })

-- Notifications
map('n', '<leader>fN', function() Snacks.picker.notifications() end, { desc = 'Notifications' })

-- Undo history
map('n', '<leader>fu', function() Snacks.picker.undo() end, { desc = 'Undo history' })

return {}
