-- Terminal keymaps (AstroNvim style)

local map = vim.keymap.set

-- Exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Terminal navigation with float detection (AstroNvim style)
local function term_nav(dir)
  return function()
    if vim.api.nvim_win_get_config(0).zindex then
      -- In floating window, pass key through to terminal
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-' .. dir .. '>', true, false, true), 'n', false)
    else
      -- In regular split, navigate windows
      vim.cmd.wincmd(dir)
    end
  end
end

map('t', '<C-h>', term_nav('h'), { desc = 'Move to left window' })
map('t', '<C-j>', term_nav('j'), { desc = 'Move to lower window' })
map('t', '<C-k>', term_nav('k'), { desc = 'Move to upper window' })
map('t', '<C-l>', term_nav('l'), { desc = 'Move to right window' })

-- Toggle terminal keymaps (AstroNvim style - simple commands)
-- horizontal = bottom split (full width), vertical = right side split
map('n', '<leader>tf', '<Cmd>ToggleTerm direction=float<CR>', { desc = 'Float terminal' })
map('n', '<leader>th', '<Cmd>ToggleTerm size=15 direction=horizontal<CR>', { desc = 'Horizontal terminal (bottom)' })
map('n', '<leader>tv', '<Cmd>ToggleTerm size=80 direction=vertical<CR>', { desc = 'Vertical terminal (right)' })

-- Generic toggle with count support (e.g., 2<F7> opens terminal #2)
map('n', '<leader>tt', '<Cmd>execute v:count . "ToggleTerm"<CR>', { desc = 'Toggle terminal' })
map('n', '<F7>', '<Cmd>execute v:count . "ToggleTerm"<CR>', { desc = 'Toggle terminal' })
map('t', '<F7>', '<Cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
map('i', '<F7>', '<Esc><Cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
map('n', "<C-'>", '<Cmd>execute v:count . "ToggleTerm"<CR>', { desc = 'Toggle terminal' })
map('t', "<C-'>", '<Cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
map('i', "<C-'>", '<Esc><Cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })

-- LazyGit with git repo detection
local lazygit_term = nil

local function open_lazygit()
  local git_dir = vim.fn.finddir('.git', vim.fn.getcwd() .. ';')
  if git_dir == '' then
    vim.notify('Not a git repository', vim.log.levels.WARN, {
      title = 'LazyGit',
      timeout = 2000,
    })
    return
  end

  local ok, _ = pcall(require, 'toggleterm')
  if not ok then
    vim.notify('toggleterm.nvim not installed', vim.log.levels.ERROR)
    return
  end

  if not lazygit_term then
    local Terminal = require('toggleterm.terminal').Terminal
    lazygit_term = Terminal:new({
      cmd = 'lazygit',
      dir = 'git_dir',
      hidden = true,
      direction = 'float',
      float_opts = {
        border = 'curved',
        width = math.ceil(vim.o.columns * 0.9),
        height = math.ceil(vim.o.lines * 0.9),
      },
      on_open = function(term)
        vim.cmd('startinsert!')
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
      end,
    })
  end
  lazygit_term:toggle()
end

map('n', '<leader>gg', open_lazygit, { desc = 'LazyGit' })

-- Claude Code terminal (dedicated instance with unique ID)
local claude_term = nil

local function open_claude()
  local ok, _ = pcall(require, 'toggleterm')
  if not ok then
    vim.notify('toggleterm.nvim not installed', vim.log.levels.ERROR)
    return
  end

  if not claude_term then
    local Terminal = require('toggleterm.terminal').Terminal
    claude_term = Terminal:new({
      cmd = 'claude',
      dir = vim.fn.getcwd(),
      hidden = true,
      direction = 'vertical',
      count = 1000,
      size = function()
        return math.ceil(vim.o.columns * 0.4)
      end,
      on_open = function()
        vim.cmd('startinsert!')
      end,
      on_exit = function()
        claude_term = nil
      end,
    })
  end
  claude_term:toggle()
end

map('n', '<leader>tc', open_claude, { desc = 'Claude Code' })

-- Terminal in current buffer
map('n', '<leader>tb', '<cmd>terminal<CR>', { desc = 'Buffer terminal' })

return {}
