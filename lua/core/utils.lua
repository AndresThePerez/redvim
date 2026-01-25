-- Utility functions for keymaps and toggles
local M = {}

-- Notification helper
function M.notify(msg, level, opts)
  opts = opts or {}
  level = level or vim.log.levels.INFO
  vim.notify(msg, level, vim.tbl_extend('force', { title = 'Neovim' }, opts))
end

-- Toggle helper with notification
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    if not silent then
      M.notify(
        'Set ' .. option .. ' to ' .. vim.opt_local[option]:get(),
        vim.log.levels.INFO
      )
    end
    return
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      M.notify('Enabled ' .. option, vim.log.levels.INFO)
    else
      M.notify('Disabled ' .. option, vim.log.levels.INFO)
    end
  end
end

-- Toggle global option
function M.toggle_global(option, silent, values)
  if values then
    if vim.opt[option]:get() == values[1] then
      vim.opt[option] = values[2]
    else
      vim.opt[option] = values[1]
    end
    if not silent then
      M.notify(
        'Set ' .. option .. ' to ' .. vim.opt[option]:get(),
        vim.log.levels.INFO
      )
    end
    return
  end
  vim.opt[option] = not vim.opt[option]:get()
  if not silent then
    if vim.opt[option]:get() then
      M.notify('Enabled ' .. option, vim.log.levels.INFO)
    else
      M.notify('Disabled ' .. option, vim.log.levels.INFO)
    end
  end
end

-- Diagnostics toggle state
M.diagnostics_enabled = true

function M.toggle_diagnostics()
  M.diagnostics_enabled = not M.diagnostics_enabled
  if M.diagnostics_enabled then
    vim.diagnostic.enable()
    M.notify('Enabled diagnostics', vim.log.levels.INFO)
  else
    vim.diagnostic.enable(false)
    M.notify('Disabled diagnostics', vim.log.levels.INFO)
  end
end

-- Inlay hints toggle
function M.toggle_inlay_hints(bufnr)
  bufnr = bufnr or 0
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  if vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) then
    M.notify('Enabled inlay hints', vim.log.levels.INFO)
  else
    M.notify('Disabled inlay hints', vim.log.levels.INFO)
  end
end

-- Format on save toggle (buffer local)
M.format_on_save = {}

function M.toggle_format_on_save(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  M.format_on_save[bufnr] = not (M.format_on_save[bufnr] == nil and true or M.format_on_save[bufnr])
  if M.format_on_save[bufnr] then
    M.notify('Enabled format on save (buffer)', vim.log.levels.INFO)
  else
    M.notify('Disabled format on save (buffer)', vim.log.levels.INFO)
  end
end

function M.format_on_save_enabled(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return M.format_on_save[bufnr] == nil and true or M.format_on_save[bufnr]
end

-- Completion toggle (buffer local)
M.completion_enabled = {}

function M.toggle_completion(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  M.completion_enabled[bufnr] = not (M.completion_enabled[bufnr] == nil and true or M.completion_enabled[bufnr])
  if M.completion_enabled[bufnr] then
    M.notify('Enabled completion (buffer)', vim.log.levels.INFO)
  else
    M.notify('Disabled completion (buffer)', vim.log.levels.INFO)
  end
end

-- Autopairs toggle state
M.autopairs_enabled = true

function M.toggle_autopairs()
  M.autopairs_enabled = not M.autopairs_enabled
  local ok, autopairs = pcall(require, 'nvim-autopairs')
  if ok then
    if M.autopairs_enabled then
      autopairs.enable()
      M.notify('Enabled autopairs', vim.log.levels.INFO)
    else
      autopairs.disable()
      M.notify('Disabled autopairs', vim.log.levels.INFO)
    end
  end
end

-- Background toggle (dark/light)
function M.toggle_background()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
    M.notify('Set background to light', vim.log.levels.INFO)
  else
    vim.o.background = 'dark'
    M.notify('Set background to dark', vim.log.levels.INFO)
  end
end

-- Statusline toggle
M.statusline_enabled = true

function M.toggle_statusline()
  M.statusline_enabled = not M.statusline_enabled
  if M.statusline_enabled then
    vim.o.laststatus = 3
    M.notify('Enabled statusline', vim.log.levels.INFO)
  else
    vim.o.laststatus = 0
    M.notify('Disabled statusline', vim.log.levels.INFO)
  end
end

-- Line numbers toggle (cycle: relative -> absolute -> none)
function M.toggle_line_numbers()
  if vim.wo.number and vim.wo.relativenumber then
    vim.wo.relativenumber = false
    M.notify('Absolute line numbers', vim.log.levels.INFO)
  elseif vim.wo.number then
    vim.wo.number = false
    M.notify('No line numbers', vim.log.levels.INFO)
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
    M.notify('Relative line numbers', vim.log.levels.INFO)
  end
end

-- Conceal level toggle
function M.toggle_conceal()
  if vim.wo.conceallevel == 0 then
    vim.wo.conceallevel = 2
    M.notify('Enabled conceal', vim.log.levels.INFO)
  else
    vim.wo.conceallevel = 0
    M.notify('Disabled conceal', vim.log.levels.INFO)
  end
end

-- Treesitter context toggle
M.treesitter_context_enabled = true

function M.toggle_treesitter_context()
  M.treesitter_context_enabled = not M.treesitter_context_enabled
  local ok, context = pcall(require, 'treesitter-context')
  if ok then
    if M.treesitter_context_enabled then
      context.enable()
      M.notify('Enabled treesitter context', vim.log.levels.INFO)
    else
      context.disable()
      M.notify('Disabled treesitter context', vim.log.levels.INFO)
    end
  end
end

-- Get visual selection
function M.get_visual_selection()
  local _, ls, cs = unpack(vim.fn.getpos('v'))
  local _, le, ce = unpack(vim.fn.getpos('.'))
  if ls > le or (ls == le and cs > ce) then
    ls, cs, le, ce = le, ce, ls, cs
  end
  local lines = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
  return table.concat(lines, '\n')
end

-- Keymap helper
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Buffer delete helper (respects mini.bufremove if available)
function M.bufremove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  local ok, mini_bufremove = pcall(require, 'mini.bufremove')
  if ok then
    mini_bufremove.delete(buf, false)
  else
    vim.api.nvim_buf_delete(buf, { force = false })
  end
end

-- Force buffer delete
function M.bufremove_force(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  local ok, mini_bufremove = pcall(require, 'mini.bufremove')
  if ok then
    mini_bufremove.delete(buf, true)
  else
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

return M
