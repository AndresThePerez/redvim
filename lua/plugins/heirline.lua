-- Heirline - Statusline and Tabline configuration
-- Highly customizable statusline/tabline

return {
  'rebelot/heirline.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'lewis6991/gitsigns.nvim',
  },
  config = function()
    local heirline = require 'heirline'
    local conditions = require 'heirline.conditions'
    local utils = require 'heirline.utils'

    -- Colors from colorscheme
    local function setup_colors()
      return {
        bright_bg = utils.get_highlight('Folded').bg or '#3b4261',
        bright_fg = utils.get_highlight('Folded').fg or '#c0caf5',
        red = utils.get_highlight('DiagnosticError').fg or '#f7768e',
        dark_red = utils.get_highlight('DiffDelete').bg or '#3f2d3d',
        green = utils.get_highlight('String').fg or '#9ece6a',
        blue = utils.get_highlight('Function').fg or '#7aa2f7',
        gray = utils.get_highlight('NonText').fg or '#545c7e',
        orange = utils.get_highlight('Constant').fg or '#ff9e64',
        purple = utils.get_highlight('Statement').fg or '#bb9af7',
        cyan = utils.get_highlight('Special').fg or '#7dcfff',
        diag_warn = utils.get_highlight('DiagnosticWarn').fg or '#e0af68',
        diag_error = utils.get_highlight('DiagnosticError').fg or '#f7768e',
        diag_hint = utils.get_highlight('DiagnosticHint').fg or '#1abc9c',
        diag_info = utils.get_highlight('DiagnosticInfo').fg or '#0db9d7',
        git_del = utils.get_highlight('GitSignsDelete').fg or '#f7768e',
        git_add = utils.get_highlight('GitSignsAdd').fg or '#9ece6a',
        git_change = utils.get_highlight('GitSignsChange').fg or '#7aa2f7',
        statusline_bg = utils.get_highlight('StatusLine').bg or '#1a1b26',
        statusline_fg = utils.get_highlight('StatusLine').fg or '#a9b1d6',
      }
    end

    -- ViMode component
    local ViMode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_names = {
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
        },
        mode_colors = {
          n = 'blue',
          i = 'green',
          v = 'purple',
          V = 'purple',
          ['\22'] = 'purple',
          c = 'orange',
          s = 'cyan',
          S = 'cyan',
          ['\19'] = 'cyan',
          R = 'red',
          r = 'red',
          ['!'] = 'red',
          t = 'green',
        },
      },
      provider = function(self)
        return ' %2(' .. self.mode_names[self.mode] .. '%) '
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { fg = 'statusline_bg', bg = self.mode_colors[mode], bold = true }
      end,
      update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
          vim.cmd 'redrawstatus'
        end),
      },
    }

    -- File info components
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

    local FileName = {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ':.')
        if filename == '' then
          return '[No Name]'
        end
        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename
      end,
      hl = { fg = 'bright_fg' },
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = ' [+]',
        hl = { fg = 'green' },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = ' ',
        hl = { fg = 'orange' },
      },
    }

    local FileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
      FileIcon,
      FileName,
      FileFlags,
      { provider = ' ' },
    }

    -- Git component
    local Git = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,
      hl = { fg = 'orange' },
      {
        provider = function(self)
          return ' ' .. self.status_dict.head .. ' '
        end,
        hl = { bold = true },
      },
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = '(',
      },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and ('+' .. count)
        end,
        hl = { fg = 'git_add' },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and ('-' .. count)
        end,
        hl = { fg = 'git_del' },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and ('~' .. count)
        end,
        hl = { fg = 'git_change' },
      },
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = ') ',
      },
    }

    -- Diagnostics
    local Diagnostics = {
      condition = conditions.has_diagnostics,
      static = {
        error_icon = vim.fn.sign_getdefined('DiagnosticSignError')[1] and vim.fn.sign_getdefined('DiagnosticSignError')[1].text or 'E',
        warn_icon = vim.fn.sign_getdefined('DiagnosticSignWarn')[1] and vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text or 'W',
        info_icon = vim.fn.sign_getdefined('DiagnosticSignInfo')[1] and vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text or 'I',
        hint_icon = vim.fn.sign_getdefined('DiagnosticSignHint')[1] and vim.fn.sign_getdefined('DiagnosticSignHint')[1].text or 'H',
      },
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,
      update = { 'DiagnosticChanged', 'BufEnter' },
      {
        provider = function(self)
          return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
        end,
        hl = { fg = 'diag_error' },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
        end,
        hl = { fg = 'diag_warn' },
      },
      {
        provider = function(self)
          return self.info > 0 and (self.info_icon .. self.info .. ' ')
        end,
        hl = { fg = 'diag_info' },
      },
      {
        provider = function(self)
          return self.hints > 0 and (self.hint_icon .. self.hints .. ' ')
        end,
        hl = { fg = 'diag_hint' },
      },
    }

    -- LSP active
    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { 'LspAttach', 'LspDetach' },
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
          table.insert(names, server.name)
        end
        return ' ' .. table.concat(names, ', ') .. ' '
      end,
      hl = { fg = 'green', bold = true },
    }

    -- File type
    local FileType = {
      provider = function()
        return vim.bo.filetype
      end,
      hl = { fg = 'cyan', bold = true },
    }

    -- File encoding
    local FileEncoding = {
      provider = function()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
        return enc ~= 'utf-8' and enc:upper() .. ' '
      end,
      hl = { fg = 'gray' },
    }

    -- File format
    local FileFormat = {
      provider = function()
        local fmt = vim.bo.fileformat
        return fmt ~= 'unix' and fmt:upper() .. ' '
      end,
      hl = { fg = 'gray' },
    }

    -- Ruler
    local Ruler = {
      provider = ' %3l:%-2c ',
      hl = { fg = 'bright_fg' },
    }

    -- Percentage
    local ScrollBar = {
      static = {
        sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
      },
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2)
      end,
      hl = { fg = 'blue', bg = 'bright_bg' },
    }

    -- Spacer and Align
    local Align = { provider = '%=' }
    local Space = { provider = ' ' }

    -- Terminal statusline (minimal)
    local TerminalStatusLine = {
      condition = function()
        return conditions.buffer_matches({ buftype = { 'terminal' } })
      end,
      ViMode,
      Space,
      {
        provider = function()
          local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
          return '  ' .. tname
        end,
        hl = { fg = 'blue', bold = true },
      },
      Align,
    }

    -- Default statusline
    local DefaultStatusLine = {
      condition = function()
        return not conditions.buffer_matches({ buftype = { 'terminal' } })
      end,
      ViMode,
      Space,
      FileNameBlock,
      Space,
      Git,
      Align,
      Diagnostics,
      Space,
      LSPActive,
      Space,
      FileType,
      Space,
      FileEncoding,
      FileFormat,
      Ruler,
      ScrollBar,
    }

    -- Combined statusline with fallbacks
    local StatusLine = {
      fallthrough = false,
      TerminalStatusLine,
      DefaultStatusLine,
    }

    -- Tabline components
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
        hl = { fg = 'green' },
      },
      {
        condition = function(self)
          return not vim.api.nvim_get_option_value('modifiable', { buf = self.bufnr }) or vim.api.nvim_get_option_value('readonly', { buf = self.bufnr })
        end,
        provider = function(self)
          if vim.api.nvim_get_option_value('buftype', { buf = self.bufnr }) == 'terminal' then
            return '  '
          else
            return ''
          end
        end,
        hl = { fg = 'orange' },
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
        hl = { fg = 'gray' },
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

    local TablineBufferBlock = utils.surround({ '', '' }, function(self)
      if self.is_active then
        return utils.get_highlight('TabLineSel').bg
      else
        return utils.get_highlight('TabLine').bg
      end
    end, { TablineFileNameBlock, TablineCloseButton })

    local BufferLine = utils.make_buflist(TablineBufferBlock, { provider = '', hl = { fg = 'gray' } }, { provider = '', hl = { fg = 'gray' } })

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
      utils.make_tablist(Tabpage),
    }

    local TabLine = { BufferLine, TabPages }

    -- Setup heirline
    heirline.setup {
      statusline = StatusLine,
      tabline = TabLine,
      opts = {
        colors = setup_colors(),
      },
    }

    -- Update colors on colorscheme change
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        utils.on_colorscheme(setup_colors)
      end,
    })
  end,
}
