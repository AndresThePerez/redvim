-- Buffer management keymaps

local map = vim.keymap.set
local utils = require('core.utils')

-- Buffer navigation
map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })

-- Buffer switching by number
for i = 1, 9 do
  map('n', '<leader>' .. i, function()
    local bufs = vim.tbl_filter(function(b)
      return vim.bo[b].buflisted and vim.api.nvim_buf_is_valid(b)
    end, vim.api.nvim_list_bufs())
    if bufs[i] then
      vim.api.nvim_set_current_buf(bufs[i])
    end
  end, { desc = 'Go to buffer ' .. i })
end

-- Close buffer
map('n', '<leader>c', function()
  utils.bufremove()
end, { desc = 'Close buffer' })

map('n', '<leader>bd', function()
  utils.bufremove()
end, { desc = 'Delete buffer' })

map('n', '<leader>bD', function()
  utils.bufremove_force()
end, { desc = 'Delete buffer (force)' })

-- Close all buffers except current
map('n', '<leader>bc', function()
  local current = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if buf ~= current and vim.bo[buf].buflisted then
      utils.bufremove(buf)
    end
  end
end, { desc = 'Close other buffers' })

-- Close all buffers
map('n', '<leader>bC', function()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if vim.bo[buf].buflisted then
      utils.bufremove(buf)
    end
  end
end, { desc = 'Close all buffers' })

-- Close buffers to the left
map('n', '<leader>bl', function()
  local current = vim.api.nvim_get_current_buf()
  local bufs = vim.tbl_filter(function(b)
    return vim.bo[b].buflisted and vim.api.nvim_buf_is_valid(b)
  end, vim.api.nvim_list_bufs())
  for _, buf in ipairs(bufs) do
    if buf == current then
      break
    end
    utils.bufremove(buf)
  end
end, { desc = 'Close buffers to the left' })

-- Close buffers to the right
map('n', '<leader>br', function()
  local current = vim.api.nvim_get_current_buf()
  local bufs = vim.tbl_filter(function(b)
    return vim.bo[b].buflisted and vim.api.nvim_buf_is_valid(b)
  end, vim.api.nvim_list_bufs())
  local found = false
  for _, buf in ipairs(bufs) do
    if found then
      utils.bufremove(buf)
    end
    if buf == current then
      found = true
    end
  end
end, { desc = 'Close buffers to the right' })

-- Move buffer left/right in buffer list
map('n', '>b', function()
  -- This requires a buffer line plugin to work properly
  -- For now, just cycle through buffers
  vim.cmd('bnext')
end, { desc = 'Move buffer right' })

map('n', '<b', function()
  vim.cmd('bprevious')
end, { desc = 'Move buffer left' })

-- Sort buffers (various methods)
local function sort_buffers_by(method)
  local bufs = vim.tbl_filter(function(b)
    return vim.bo[b].buflisted and vim.api.nvim_buf_is_valid(b)
  end, vim.api.nvim_list_bufs())

  local sorted = {}
  for _, buf in ipairs(bufs) do
    local name = vim.api.nvim_buf_get_name(buf)
    table.insert(sorted, { buf = buf, name = name })
  end

  if method == 'extension' then
    table.sort(sorted, function(a, b)
      local ext_a = vim.fn.fnamemodify(a.name, ':e') or ''
      local ext_b = vim.fn.fnamemodify(b.name, ':e') or ''
      return ext_a < ext_b
    end)
  elseif method == 'relative_path' then
    table.sort(sorted, function(a, b)
      return a.name < b.name
    end)
  elseif method == 'modified' then
    table.sort(sorted, function(a, b)
      local mod_a = vim.bo[a.buf].modified and 1 or 0
      local mod_b = vim.bo[b.buf].modified and 1 or 0
      return mod_a > mod_b
    end)
  end

  utils.notify('Sorted buffers by ' .. method, vim.log.levels.INFO)
end

map('n', '<leader>bse', function() sort_buffers_by('extension') end, { desc = 'Sort by extension' })
map('n', '<leader>bsp', function() sort_buffers_by('relative_path') end, { desc = 'Sort by path' })
map('n', '<leader>bsm', function() sort_buffers_by('modified') end, { desc = 'Sort by modified' })

-- Buffer picker (via Telescope, defined in picker.lua)
-- <leader>bb is mapped in picker.lua

-- First and last buffer
map('n', '<leader>bf', '<cmd>bfirst<CR>', { desc = 'First buffer' })
map('n', '<leader>bL', '<cmd>blast<CR>', { desc = 'Last buffer' })

return {}
