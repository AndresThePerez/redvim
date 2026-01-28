-- Lazydocker integration
-- Terminal UI for Docker management within Neovim

return {
  {
    'crnvl96/lazydocker.nvim',
    event = 'VeryLazy',
    dependencies = {
      'akinsho/toggleterm.nvim',
    },
    opts = {
      window = {
        settings = {
          width = 0.9,
          height = 0.9,
          border = 'rounded',
          relative = 'editor',
        },
      },
    },
    keys = {
      {
        '<leader>D',
        function()
          require('lazydocker').toggle()
        end,
        desc = 'LazyDocker',
      },
    },
  },

  -- Add Docker group to which-key
  {
    'folke/which-key.nvim',
    optional = true,
    opts = {
      spec = {
        { '<leader>D', group = 'Docker', icon = '󰡨' },
      },
    },
  },
}
