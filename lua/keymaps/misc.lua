-- Miscellaneous keymaps
-- Comments, lists, escape sequences, file explorer, dashboard, packages

local map = vim.keymap.set

-- Quick escape from insert mode
map('i', 'jj', '<Esc>', { desc = 'Escape' })
map('i', 'jk', '<Esc>', { desc = 'Escape' })

-- Toggle comment (with Comment.nvim)
map('n', '<leader>/', function()
  require('Comment.api').toggle.linewise.current()
end, { desc = 'Toggle comment' })

map('v', '<leader>/', "<Esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = 'Toggle comment' })

-- Add comment below/above/end of line (handled by Comment.nvim's extra mappings)
-- gco, gcO, gcA are already set by Comment.nvim

-- Quickfix and location list
map('n', '<leader>xq', '<cmd>copen<CR>', { desc = 'Open quickfix' })
map('n', '<leader>xl', '<cmd>lopen<CR>', { desc = 'Open location list' })
map('n', '<leader>xQ', '<cmd>cclose<CR>', { desc = 'Close quickfix' })
map('n', '<leader>xL', '<cmd>lclose<CR>', { desc = 'Close location list' })

-- Navigate quickfix/location lists
map('n', ']q', '<cmd>cnext<CR>', { desc = 'Next quickfix item' })
map('n', '[q', '<cmd>cprev<CR>', { desc = 'Previous quickfix item' })
map('n', ']Q', '<cmd>clast<CR>', { desc = 'Last quickfix item' })
map('n', '[Q', '<cmd>cfirst<CR>', { desc = 'First quickfix item' })
map('n', ']l', '<cmd>lnext<CR>', { desc = 'Next location item' })
map('n', '[l', '<cmd>lprev<CR>', { desc = 'Previous location item' })

-- File explorer (Neo-tree)
map('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle file explorer' })
map('n', '<leader>o', '<cmd>Neotree focus<CR>', { desc = 'Focus file explorer' })
map('n', '<leader>E', '<cmd>Neotree reveal<CR>', { desc = 'Reveal file in explorer' })

-- Dashboard
map('n', '<leader>h', function()
  -- Try alpha first, then other dashboard plugins
  local ok = pcall(vim.cmd, 'Alpha')
  if not ok then
    -- Fallback: just go to empty buffer
    vim.cmd('enew')
  end
end, { desc = 'Dashboard' })

-- Package management
map('n', '<leader>pa', '<cmd>Lazy update<CR>', { desc = 'Update all plugins' })
map('n', '<leader>pi', '<cmd>Lazy install<CR>', { desc = 'Install plugins' })
map('n', '<leader>pm', '<cmd>Mason<CR>', { desc = 'Mason installer' })
map('n', '<leader>ps', '<cmd>Lazy<CR>', { desc = 'Plugin status' })
map('n', '<leader>pS', '<cmd>Lazy sync<CR>', { desc = 'Plugin sync' })
map('n', '<leader>pu', '<cmd>Lazy check<CR>', { desc = 'Check for updates' })
map('n', '<leader>pU', '<cmd>Lazy update<CR>', { desc = 'Update plugins' })
map('n', '<leader>px', '<cmd>Lazy clean<CR>', { desc = 'Clean unused plugins' })
map('n', '<leader>pp', '<cmd>Lazy profile<CR>', { desc = 'Plugin profile' })
map('n', '<leader>pl', '<cmd>Lazy log<CR>', { desc = 'Plugin log' })
map('n', '<leader>ph', '<cmd>Lazy help<CR>', { desc = 'Plugin help' })
map('n', '<leader>pd', '<cmd>Lazy debug<CR>', { desc = 'Plugin debug' })

-- Session management (with auto-session or persistence.nvim)
map('n', '<leader>Ss', function()
  local ok, persistence = pcall(require, 'persistence')
  if ok then
    persistence.save()
    require('core.utils').notify('Session saved', vim.log.levels.INFO)
  else
    -- Fallback to mksession
    vim.cmd('mksession! ' .. vim.fn.stdpath('state') .. '/session.vim')
    require('core.utils').notify('Session saved (fallback)', vim.log.levels.INFO)
  end
end, { desc = 'Save session' })

map('n', '<leader>Sl', function()
  local ok, persistence = pcall(require, 'persistence')
  if ok then
    persistence.load({ last = true })
  else
    -- Fallback to source
    local session_file = vim.fn.stdpath('state') .. '/session.vim'
    if vim.fn.filereadable(session_file) == 1 then
      vim.cmd('source ' .. session_file)
    else
      require('core.utils').notify('No session found', vim.log.levels.WARN)
    end
  end
end, { desc = 'Load last session' })

map('n', '<leader>Sf', function()
  local ok, persistence = pcall(require, 'persistence')
  if ok then
    persistence.select()
  else
    require('core.utils').notify('persistence.nvim not installed', vim.log.levels.WARN)
  end
end, { desc = 'Search sessions' })

map('n', '<leader>Sd', function()
  local ok, persistence = pcall(require, 'persistence')
  if ok then
    persistence.stop()
    require('core.utils').notify('Session tracking stopped', vim.log.levels.INFO)
  end
end, { desc = 'Stop session tracking' })

map('n', '<leader>Sr', function()
  local ok, persistence = pcall(require, 'persistence')
  if ok then
    persistence.load()
  end
end, { desc = 'Restore session for cwd' })

-- Open markdown links (file-type specific, set in autocmd)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.keymap.set('n', 'gx', function()
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2] + 1

      -- Pattern to match markdown links: [text](url)
      local link_pattern = '%[([^%]]+)%]%(([^%)]+)%)'

      local start_pos = 1
      while true do
        local link_start, link_end, _, url = line:find(link_pattern, start_pos)
        if not link_start then
          break
        end

        if col >= link_start and col <= link_end then
          if url:match('^https?://') then
            -- Web URL
            local open_cmd = vim.fn.has('unix') == 1 and 'xdg-open' or 'open'
            vim.fn.jobstart({ open_cmd, url }, { detach = true })
          else
            -- Local file
            local current_dir = vim.fn.expand('%:p:h')
            local file_path = url
            if not vim.fn.isabsolute(file_path) then
              file_path = vim.fn.resolve(current_dir .. '/' .. file_path)
            end
            if vim.fn.filereadable(file_path) == 1 or vim.fn.isdirectory(file_path) == 1 then
              vim.cmd('edit ' .. vim.fn.fnameescape(file_path))
            else
              vim.notify('File not found: ' .. file_path, vim.log.levels.WARN)
            end
          end
          return
        end

        start_pos = link_end + 1
      end

      -- Default gx behavior
      vim.cmd('normal! gx')
    end, { buffer = true, desc = 'Open markdown link' })
  end,
})

-- Rename current file
map('n', '<leader>R', function()
  local old_name = vim.fn.expand('%')
  local new_name = vim.fn.input('New name: ', old_name, 'file')
  if new_name ~= '' and new_name ~= old_name then
    vim.cmd('saveas ' .. vim.fn.fnameescape(new_name))
    vim.fn.delete(old_name)
    require('core.utils').notify('Renamed to ' .. new_name, vim.log.levels.INFO)
  end
end, { desc = 'Rename file' })

-- Copy file path
map('n', '<leader>yp', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  require('core.utils').notify('Copied: ' .. path, vim.log.levels.INFO)
end, { desc = 'Copy file path' })

map('n', '<leader>yr', function()
  local path = vim.fn.expand('%:.')
  vim.fn.setreg('+', path)
  require('core.utils').notify('Copied: ' .. path, vim.log.levels.INFO)
end, { desc = 'Copy relative path' })

map('n', '<leader>yf', function()
  local filename = vim.fn.expand('%:t')
  vim.fn.setreg('+', filename)
  require('core.utils').notify('Copied: ' .. filename, vim.log.levels.INFO)
end, { desc = 'Copy filename' })

return {}
