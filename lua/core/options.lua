-- Core Neovim options
-- All vim.opt and vim.o settings

local opt = vim.opt
local o = vim.o
local g = vim.g

-- Leader keys (must be set before plugins load)
g.mapleader = ' '
g.maplocalleader = ','

-- Nerd Font support
g.have_nerd_font = true

-- Disable autoformat by default (toggle with <leader>uf)
g.autoformat = false

-- Line numbers
o.number = true
o.relativenumber = true

-- Mouse
o.mouse = 'a'

-- Mode display (hidden since statusline shows it)
o.showmode = false

-- Clipboard (scheduled to avoid startup delay)
vim.schedule(function()
  o.clipboard = 'unnamedplus'
end)

-- Indentation
o.breakindent = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true

-- Undo
o.undofile = true
o.undolevels = 10000

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

-- UI
o.signcolumn = 'yes'
o.showtabline = 2
o.cursorline = true
o.termguicolors = true
o.wrap = false
o.linebreak = true
o.scrolloff = 10
o.sidescrolloff = 8

-- Timing
o.updatetime = 250
o.timeoutlen = 300

-- Splits
o.splitright = true
o.splitbelow = true

-- Whitespace display
o.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Hide tildes on empty lines (end of buffer)
opt.fillchars:append({ eob = ' ' })

-- Command line
o.inccommand = 'split'

-- Confirmation dialogs
o.confirm = true

-- Completion
o.completeopt = 'menu,menuone,noselect'
o.pumheight = 10

-- Statusline (global)
o.laststatus = 3

-- Session options
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }

-- Spelling
o.spelllang = 'en_us'

-- Folding (using treesitter)
o.foldmethod = 'expr'
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldlevel = 99
o.foldlevelstart = 99

-- Disable some built-in plugins
local disabled_built_ins = {
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'rrhelper',
  'spellfile_plugin',
  'matchit',
}

for _, plugin in pairs(disabled_built_ins) do
  g['loaded_' .. plugin] = 1
end

return {}
