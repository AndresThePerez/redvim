-- Heirline - NvChad-style Statusline and Tabline
-- Powerline separators with dynamic mode colors

return {
  'rebelot/heirline.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'lewis6991/gitsigns.nvim',
  },
  config = function()
    local heirline = require('heirline')
    local conditions = require('heirline.conditions')
    local heirline_utils = require('heirline.utils')

    -- Powerline separator characters
    local sep_l = '' -- U+E0B0
    local sep_r = '' -- U+E0B2

    -- Colors derived from highlight groups (NvChad approach)
    local function setup_colors()
      local normal_bg = heirline_utils.get_highlight('Normal').bg or '#1a1b26'
      local folded_fg = heirline_utils.get_highlight('Folded').fg or '#545c7e'
      local visual_bg = heirline_utils.get_highlight('Visual').bg or '#3b4261'
      local string_fg = heirline_utils.get_highlight('String').fg or '#9ece6a'
      local error_fg = heirline_utils.get_highlight('Error').fg or '#f7768e'
      local comment_fg = heirline_utils.get_highlight('Comment').fg or '#545c7e'
      local statusline = heirline_utils.get_highlight('StatusLine')

      return {
        -- Base
        fg = statusline.fg or '#a9b1d6',
        bg = statusline.bg or normal_bg,

        -- Section backgrounds
        blank_bg = folded_fg,
        file_info_bg = visual_bg,
        nav_icon_bg = string_fg,
        folder_icon_bg = error_fg,

        -- Mode colors
        normal = heirline_utils.get_highlight('Function').fg or '#7aa2f7',
        insert = string_fg,
        visual = heirline_utils.get_highlight('Statement').fg or '#bb9af7',
        replace = error_fg,
        command = heirline_utils.get_highlight('Constant').fg or '#ff9e64',
        terminal = string_fg,
        inactive = '#545c7e',

        -- Git (muted - all comment color per NvChad)
        git_fg = comment_fg,

        -- Diagnostics
        diag_error = heirline_utils.get_highlight('DiagnosticError').fg or '#f7768e',
        diag_warn = heirline_utils.get_highlight('DiagnosticWarn').fg or '#e0af68',
        diag_info = heirline_utils.get_highlight('DiagnosticInfo').fg or '#0db9d7',
        diag_hint = heirline_utils.get_highlight('DiagnosticHint').fg or '#1abc9c',

        -- LSP
        lsp_fg = string_fg,
      }
    end

    -- Mode utilities
    local mode_labels = {
      n = 'NORMAL',
      no = 'N-PENDING',
      nov = 'N-PENDING',
      noV = 'N-PENDING',
      ['no\22'] = 'N-PENDING',
      niI = 'NORMAL',
      niR = 'NORMAL',
      niV = 'NORMAL',
      nt = 'NORMAL',
      v = 'VISUAL',
      vs = 'VISUAL',
      V = 'V-LINE',
      Vs = 'V-LINE',
      ['\22'] = 'V-BLOCK',
      ['\22s'] = 'V-BLOCK',
      s = 'SELECT',
      S = 'S-LINE',
      ['\19'] = 'S-BLOCK',
      i = 'INSERT',
      ic = 'INSERT',
      ix = 'INSERT',
      R = 'REPLACE',
      Rc = 'REPLACE',
      Rx = 'REPLACE',
      Rv = 'V-REPLACE',
      Rvc = 'V-REPLACE',
      Rvx = 'V-REPLACE',
      c = 'COMMAND',
      cv = 'EX',
      r = 'PROMPT',
      rm = 'MORE',
      ['r?'] = 'CONFIRM',
      ['!'] = 'SHELL',
      t = 'TERMINAL',
    }

    local mode_colors = {
      n = 'normal',
      i = 'insert',
      v = 'visual',
      V = 'visual',
      ['\22'] = 'visual',
      c = 'command',
      s = 'visual',
      S = 'visual',
      ['\19'] = 'visual',
      R = 'replace',
      r = 'replace',
      ['!'] = 'replace',
      t = 'terminal',
    }

    local function get_mode_color()
      local m = vim.fn.mode(1):sub(1, 1)
      return mode_colors[m] or 'inactive'
    end

    -----------------------------------------------------------------
    -- STATUSLINE COMPONENTS
    -----------------------------------------------------------------

    -- 1. Mode section:  NORMAL
    local Mode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      -- Left separator (bg=nil so it inherits statusline bg)
      {
        provider = ' ',
        hl = function()
          return { fg = get_mode_color(), bg = get_mode_color() }
        end,
      },
      -- Icon + mode text
      {
        provider = function(self)
          return '  ' .. (mode_labels[self.mode] or 'UNKNOWN') .. ' '
        end,
        hl = function()
          return { fg = 'bg', bg = get_mode_color(), bold = true }
        end,
      },
      -- Right separator (transition to blank_bg)
      {
        provider = sep_l,
        hl = function()
          return { fg = get_mode_color(), bg = 'blank_bg' }
        end,
      },
      update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
          vim.cmd('redrawstatus')
        end),
      },
    }

    -- 2. Blank spacer section (transition from mode to file_info)
    local BlankSpacer = {
      { provider = ' ', hl = { bg = 'blank_bg' } },
      { provider = sep_l, hl = { fg = 'blank_bg', bg = 'file_info_bg' } },
    }

    -- 3. File info section (icon + filename)
    local FileInfo = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
      -- File icon
      {
        init = function(self)
          local filename = vim.api.nvim_buf_get_name(0)
          local extension = vim.fn.fnamemodify(filename, ':e')
          self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self)
          return self.icon and (' ' .. self.icon .. ' ') or ' '
        end,
        hl = { bg = 'file_info_bg' },
      },
      -- Filename
      {
        provider = function()
          local filename = vim.fn.expand('%:t')
          if filename == '' then
            return 'Empty '
          end
          return filename .. ' '
        end,
        hl = { fg = 'fg', bg = 'file_info_bg' },
      },
      -- Modified indicator
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = ' ',
        hl = { fg = 'diag_warn', bg = 'file_info_bg' },
      },
      -- Right separator (transition to statusline bg)
      {
        provider = sep_l,
        hl = { fg = 'file_info_bg', bg = 'bg' },
      },
    }

    -- 4. Git branch
    local GitBranch = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict or {}
      end,
      {
        provider = function(self)
          local branch = self.status_dict.head or ''
          return branch ~= '' and ('  ' .. branch .. ' ') or ''
        end,
        hl = { fg = 'git_fg', bg = 'bg' },
      },
    }

    -- 5. Git diff
    local GitDiff = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict or {}
      end,
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and (' ' .. count .. ' ') or ''
        end,
        hl = { fg = 'git_fg', bg = 'bg' },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and (' ' .. count .. ' ') or ''
        end,
        hl = { fg = 'git_fg', bg = 'bg' },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and (' ' .. count .. ' ') or ''
        end,
        hl = { fg = 'git_fg', bg = 'bg' },
      },
    }

    -- Fill
    local Fill = { provider = '%=', hl = { bg = 'bg' } }

    -- 6. LSP progress (center - loading indicator)
    local LSPProgress = {
      condition = conditions.lsp_attached,
      update = { 'User', pattern = 'LspProgressUpdate' },
      provider = function()
        local progress = vim.lsp.status()
        if progress and progress ~= '' then
          return ' ' .. progress .. ' '
        end
        return ''
      end,
      hl = { fg = 'fg', bg = 'bg' },
    }

    -- 7. Diagnostics section (right side)
    local Diagnostics = {
      condition = conditions.has_diagnostics,
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      end,
      update = { 'DiagnosticChanged', 'BufEnter' },
      {
        provider = function(self)
          return self.errors > 0 and (' ' .. self.errors .. ' ') or ''
        end,
        hl = { fg = 'diag_error', bg = 'bg' },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (' ' .. self.warnings .. ' ') or ''
        end,
        hl = { fg = 'diag_warn', bg = 'bg' },
      },
      {
        provider = function(self)
          return self.info > 0 and (' ' .. self.info .. ' ') or ''
        end,
        hl = { fg = 'diag_info', bg = 'bg' },
      },
      {
        provider = function(self)
          return self.hints > 0 and ('󰌵 ' .. self.hints .. ' ') or ''
        end,
        hl = { fg = 'diag_hint', bg = 'bg' },
      },
    }

    -- 8. LSP client names
    local LSPClients = {
      condition = conditions.lsp_attached,
      update = { 'LspAttach', 'LspDetach' },
      {
        provider = function()
          local names = {}
          for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
          end
          if #names == 0 then return '' end
          return '  ' .. table.concat(names, ', ') .. ' '
        end,
        hl = { fg = 'lsp_fg', bg = 'bg' },
      },
    }

    -- 9. CWD section (folder icon on colored bg + cwd on file_info_bg)
    local CWD = {
      flexible = 1,
      -- Full version
      {
        -- Left separator (transition from bg to folder_icon_bg)
        { provider = sep_r, hl = { fg = 'folder_icon_bg', bg = 'bg' } },
        -- Folder icon
        { provider = ' 󰉋 ', hl = { fg = 'bg', bg = 'folder_icon_bg', bold = true } },
        -- Right separator (transition from folder_icon_bg to file_info_bg)
        { provider = sep_r, hl = { fg = 'file_info_bg', bg = 'folder_icon_bg' } },
        -- CWD path
        {
          provider = function()
            local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
            return ' ' .. cwd .. ' '
          end,
          hl = { fg = 'fg', bg = 'file_info_bg' },
        },
      },
      -- Collapsed version (empty when window is narrow)
      {},
    }

    -- 10. Navigation section (scroll icon + percentage)
    local Nav = {
      -- Left separator (transition from file_info_bg to nav_icon_bg)
      { provider = sep_r, hl = { fg = 'nav_icon_bg', bg = 'file_info_bg' } },
      -- Scroll icon
      { provider = ' 󰈙 ', hl = { fg = 'bg', bg = 'nav_icon_bg', bold = true } },
      -- Right separator (transition from nav_icon_bg to file_info_bg)
      { provider = sep_r, hl = { fg = 'file_info_bg', bg = 'nav_icon_bg' } },
      -- Percentage
      {
        provider = function()
          local cur = vim.fn.line('.')
          local total = vim.fn.line('$')
          if cur == 1 then
            return ' Top '
          elseif cur == total then
            return ' Bot '
          else
            return string.format(' %2d%%%% ', math.floor(cur / total * 100))
          end
        end,
        hl = { fg = 'nav_icon_bg', bg = 'file_info_bg' },
      },
    }

    -----------------------------------------------------------------
    -- TERMINAL STATUSLINE (minimal)
    -----------------------------------------------------------------
    local TerminalStatusLine = {
      condition = function()
        return conditions.buffer_matches({ buftype = { 'terminal' } })
      end,
      Mode,
      BlankSpacer,
      {
        provider = function()
          local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
          return ' ' .. tname .. ' '
        end,
        hl = { fg = 'fg', bg = 'file_info_bg' },
      },
      { provider = sep_l, hl = { fg = 'file_info_bg', bg = 'bg' } },
      Fill,
    }

    -----------------------------------------------------------------
    -- DEFAULT STATUSLINE
    -----------------------------------------------------------------
    local DefaultStatusLine = {
      condition = function()
        return not conditions.buffer_matches({ buftype = { 'terminal' } })
      end,
      Mode,
      BlankSpacer,
      FileInfo,
      GitBranch,
      GitDiff,
      Fill,
      LSPProgress,
      Fill,
      Diagnostics,
      LSPClients,
      CWD,
      Nav,
    }

    -----------------------------------------------------------------
    -- COMBINED STATUSLINE
    -----------------------------------------------------------------
    local StatusLine = {
      hl = { fg = 'fg', bg = 'bg' },
      fallthrough = false,
      TerminalStatusLine,
      DefaultStatusLine,
    }

    -----------------------------------------------------------------
    -- TABLINE (kept from previous config)
    -----------------------------------------------------------------
    local FileIcon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ':e')
        self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. ' ')
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local TablineFileName = {
      provider = function(self)
        local filename = self.filename
        filename = filename == '' and '[No Name]' or vim.fn.fnamemodify(filename, ':t')
        return filename
      end,
      hl = function(self)
        return { bold = self.is_active or self.is_visible, italic = true }
      end,
    }

    local TablineFileFlags = {
      {
        condition = function(self)
          return vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
        end,
        provider = '[+]',
        hl = { fg = 'diag_warn' },
      },
      {
        condition = function(self)
          return not vim.api.nvim_get_option_value('modifiable', { buf = self.bufnr })
            or vim.api.nvim_get_option_value('readonly', { buf = self.bufnr })
        end,
        provider = function(self)
          if vim.api.nvim_get_option_value('buftype', { buf = self.bufnr }) == 'terminal' then
            return '  '
          else
            return ''
          end
        end,
        hl = { fg = 'command' },
      },
    }

    local TablineFileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
      end,
      hl = function(self)
        if self.is_active then
          return 'TabLineSel'
        else
          return 'TabLine'
        end
      end,
      on_click = {
        callback = function(_, minwid, _, button)
          if button == 'm' then
            vim.schedule(function()
              vim.api.nvim_buf_delete(minwid, { force = false })
            end)
          else
            vim.api.nvim_win_set_buf(0, minwid)
          end
        end,
        minwid = function(self)
          return self.bufnr
        end,
        name = 'heirline_tabline_buffer_callback',
      },
      { provider = ' ' },
      FileIcon,
      TablineFileName,
      TablineFileFlags,
      { provider = ' ' },
    }

    local TablineCloseButton = {
      condition = function(self)
        return not vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
      end,
      {
        provider = '',
        hl = { fg = 'inactive' },
        on_click = {
          callback = function(_, minwid)
            vim.schedule(function()
              vim.api.nvim_buf_delete(minwid, { force = false })
              vim.cmd.redrawtabline()
            end)
          end,
          minwid = function(self)
            return self.bufnr
          end,
          name = 'heirline_tabline_close_buffer_callback',
        },
      },
    }

    local TablineBufferBlock = heirline_utils.surround({ '', '' }, function(self)
      if self.is_active then
        return heirline_utils.get_highlight('TabLineSel').bg
      else
        return heirline_utils.get_highlight('TabLine').bg
      end
    end, { TablineFileNameBlock, TablineCloseButton })

    local BufferLine = heirline_utils.make_buflist(
      TablineBufferBlock,
      { provider = '', hl = { fg = 'inactive' } },
      { provider = '', hl = { fg = 'inactive' } }
    )

    local Tabpage = {
      provider = function(self)
        return '%' .. self.tabnr .. 'T ' .. self.tabpage .. ' %T'
      end,
      hl = function(self)
        if not self.is_active then
          return 'TabLine'
        else
          return 'TabLineSel'
        end
      end,
    }

    local TabPages = {
      condition = function()
        return #vim.api.nvim_list_tabpages() >= 2
      end,
      { provider = '%=' },
      heirline_utils.make_tablist(Tabpage),
    }

    local TabLine = { BufferLine, TabPages }

    -----------------------------------------------------------------
    -- SETUP
    -----------------------------------------------------------------
    heirline.setup({
      statusline = StatusLine,
      tabline = TabLine,
      opts = {
        colors = setup_colors(),
      },
    })

    -- Update colors on colorscheme change
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        heirline_utils.on_colorscheme(setup_colors)
      end,
    })
  end,
}
