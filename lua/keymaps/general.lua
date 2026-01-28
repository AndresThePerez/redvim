-- General keymaps
-- Window navigation, splits, save/quit, basic operations

local map = vim.keymap.set

-- Clear search highlights
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Window navigation (CTRL+hjkl)
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })

-- Window resizing (CTRL+arrows)
-- Smart horizontal resize: always moves separator in arrow direction
local function smart_resize_horizontal(direction)
  local cur_winnr = vim.fn.winnr()
  local right_winnr = vim.fn.winnr('l')
  local has_right = cur_winnr ~= right_winnr

  if direction == 'right' then
    if has_right then
      vim.cmd('vertical resize +2')
    else
      vim.cmd('vertical resize -2')
    end
  else -- left
    if has_right then
      vim.cmd('vertical resize -2')
    else
      vim.cmd('vertical resize +2')
    end
  end
end

-- Smart vertical resize: always moves separator in arrow direction
local function smart_resize_vertical(direction)
  local cur_winnr = vim.fn.winnr()
  local below_winnr = vim.fn.winnr('j')
  local has_below = cur_winnr ~= below_winnr

  if direction == 'down' then
    if has_below then
      vim.cmd('resize +2')
    else
      vim.cmd('resize -2')
    end
  else -- up
    if has_below then
      vim.cmd('resize -2')
    else
      vim.cmd('resize +2')
    end
  end
end

map('n', '<C-Up>', function() smart_resize_vertical('up') end, { desc = 'Move separator up' })
map('n', '<C-Down>', function() smart_resize_vertical('down') end, { desc = 'Move separator down' })
map('n', '<C-Left>', function() smart_resize_horizontal('left') end, { desc = 'Move separator left' })
map('n', '<C-Right>', function() smart_resize_horizontal('right') end, { desc = 'Move separator right' })

-- Splits
map('n', '\\', '<cmd>split<CR>', { desc = 'Horizontal split' })
map('n', '|', '<cmd>vsplit<CR>', { desc = 'Vertical split' })

-- Save
map('n', '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })
map('i', '<C-s>', '<Esc><cmd>w<CR>', { desc = 'Save file' })
map('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
map('n', '<leader>W', '<cmd>w!<CR>', { desc = 'Save file (force)' })

-- Quit
map('n', '<C-q>', '<cmd>q<CR>', { desc = 'Quit' })
map('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
map('n', '<leader>Q', '<cmd>q!<CR>', { desc = 'Quit (force)' })
map('n', '<leader>wq', '<cmd>wq<CR>', { desc = 'Save and quit' })

-- New file
map('n', '<leader>n', '<cmd>enew<CR>', { desc = 'New file' })

-- Tabs
map('n', ']t', '<cmd>tabnext<CR>', { desc = 'Next tab' })
map('n', '[t', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
map('n', '<leader><tab>l', '<cmd>tablast<CR>', { desc = 'Last tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<CR>', { desc = 'First tab' })
map('n', '<leader><tab>n', '<cmd>tabnew<CR>', { desc = 'New tab' })
map('n', '<leader><tab>c', '<cmd>tabclose<CR>', { desc = 'Close tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<CR>', { desc = 'Next tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })

-- Better up/down (handle wrapped lines)
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move lines up/down
map('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move line down' })
map('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move line up' })
map('i', '<A-j>', '<Esc><cmd>m .+1<CR>==gi', { desc = 'Move line down' })
map('i', '<A-k>', '<Esc><cmd>m .-2<CR>==gi', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Better indenting in visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Add blank lines
map('n', ']<Space>', 'o<Esc>', { desc = 'Add blank line below' })
map('n', '[<Space>', 'O<Esc>', { desc = 'Add blank line above' })

-- Paste without yanking selection in visual mode
map('x', 'p', 'P')

-- Select all
map('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all' })

-- Center cursor after jumps
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Increment/decrement
map('n', '+', '<C-a>', { desc = 'Increment number' })
map('n', '-', '<C-x>', { desc = 'Decrement number' })

return {}
