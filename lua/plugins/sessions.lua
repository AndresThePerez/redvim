-- Session management with persistence.nvim

return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    -- Directory where session files are saved
    dir = vim.fn.stdpath('state') .. '/sessions/',
    -- Minimum number of file buffers to save
    need = 1,
    -- Enable branch-based sessions
    branch = true,
  },
  keys = {
    {
      '<leader>Ss',
      function()
        require('persistence').save()
        require('core.utils').notify('Session saved', vim.log.levels.INFO)
      end,
      desc = 'Save session',
    },
    {
      '<leader>Sl',
      function()
        require('persistence').load({ last = true })
      end,
      desc = 'Load last session',
    },
    {
      '<leader>Sr',
      function()
        require('persistence').load()
      end,
      desc = 'Restore session for cwd',
    },
    {
      '<leader>Sf',
      function()
        require('persistence').select()
      end,
      desc = 'Select session',
    },
    {
      '<leader>Sd',
      function()
        require('persistence').stop()
        require('core.utils').notify('Session tracking stopped', vim.log.levels.INFO)
      end,
      desc = 'Stop session tracking',
    },
  },
}
