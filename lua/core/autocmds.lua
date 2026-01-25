-- Autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Resize splits on window resize
autocmd('VimResized', {
  desc = 'Resize splits when window is resized',
  group = augroup('resize-splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Close some filetypes with <q>
autocmd('FileType', {
  desc = 'Close certain filetypes with q',
  group = augroup('close-with-q', { clear = true }),
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'notify',
    'qf',
    'query',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'checkhealth',
    'man',
    'fugitive',
    'git',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Don't auto-comment new lines
autocmd('BufEnter', {
  desc = 'Disable auto-commenting on new lines',
  group = augroup('no-auto-comment', { clear = true }),
  callback = function()
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- Check if file changed outside of neovim
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  desc = 'Check if file changed outside of neovim',
  group = augroup('checktime', { clear = true }),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Auto create parent directories when saving
autocmd('BufWritePre', {
  desc = 'Create parent directories when saving',
  group = augroup('auto-create-dir', { clear = true }),
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Go to last location when opening a buffer
autocmd('BufReadPost', {
  desc = 'Go to last location when opening a buffer',
  group = augroup('last-loc', { clear = true }),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Wrap and spell check in text filetypes
autocmd('FileType', {
  desc = 'Wrap and spell check in text filetypes',
  group = augroup('wrap-spell', { clear = true }),
  pattern = { 'gitcommit', 'markdown', 'text' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for JSON files
autocmd('FileType', {
  desc = 'Fix conceallevel for JSON files',
  group = augroup('json-conceal', { clear = true }),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Disable statusline in neo-tree and other file explorers
autocmd('FileType', {
  desc = 'Disable statusline in file explorer windows',
  group = augroup('explorer-statusline', { clear = true }),
  pattern = { 'neo-tree', 'NvimTree', 'netrw' },
  callback = function()
    vim.wo.statusline = ''
  end,
})

-- Terminal settings
autocmd('TermOpen', {
  desc = 'Set terminal options',
  group = augroup('term-open', { clear = true }),
  pattern = 'term://*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.cmd('startinsert')
  end,
})

-- Large file handling
local large_file_size = 1024 * 1024 -- 1MB
autocmd('BufReadPre', {
  desc = 'Disable features for large files',
  group = augroup('large-file', { clear = true }),
  callback = function(args)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > large_file_size then
      vim.b.large_file = true
      vim.opt_local.swapfile = false
      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.undolevels = -1
      vim.opt_local.undoreload = 0
      vim.opt_local.list = false
      vim.cmd('syntax off')
    end
  end,
})

return {}
