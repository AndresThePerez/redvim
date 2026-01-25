-- Debug (DAP) keymaps

local map = vim.keymap.set

-- Helper to safely call dap functions
local function dap_cmd(cmd)
  return function()
    local ok, dap = pcall(require, 'dap')
    if ok then
      dap[cmd]()
    else
      vim.notify('nvim-dap not installed', vim.log.levels.WARN)
    end
  end
end

local function dapui_cmd(cmd)
  return function()
    local ok, dapui = pcall(require, 'dapui')
    if ok then
      dapui[cmd]()
    else
      vim.notify('nvim-dap-ui not installed', vim.log.levels.WARN)
    end
  end
end

-- Start/Continue
map('n', '<leader>dc', dap_cmd('continue'), { desc = 'Debug: Continue' })
map('n', '<F5>', dap_cmd('continue'), { desc = 'Debug: Continue' })

-- Pause
map('n', '<leader>dp', dap_cmd('pause'), { desc = 'Debug: Pause' })
map('n', '<F6>', dap_cmd('pause'), { desc = 'Debug: Pause' })

-- Breakpoint
map('n', '<leader>db', dap_cmd('toggle_breakpoint'), { desc = 'Debug: Toggle breakpoint' })
map('n', '<F9>', dap_cmd('toggle_breakpoint'), { desc = 'Debug: Toggle breakpoint' })

-- Conditional breakpoint
map('n', '<leader>dB', function()
  local ok, dap = pcall(require, 'dap')
  if ok then
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
  end
end, { desc = 'Debug: Conditional breakpoint' })

-- Log point
map('n', '<leader>dL', function()
  local ok, dap = pcall(require, 'dap')
  if ok then
    dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
  end
end, { desc = 'Debug: Log point' })

-- Step over
map('n', '<leader>do', dap_cmd('step_over'), { desc = 'Debug: Step over' })
map('n', '<F10>', dap_cmd('step_over'), { desc = 'Debug: Step over' })

-- Step into
map('n', '<leader>di', dap_cmd('step_into'), { desc = 'Debug: Step into' })
map('n', '<F11>', dap_cmd('step_into'), { desc = 'Debug: Step into' })

-- Step out
map('n', '<leader>dO', dap_cmd('step_out'), { desc = 'Debug: Step out' })
map('n', '<S-F11>', dap_cmd('step_out'), { desc = 'Debug: Step out' })

-- Terminate/Close
map('n', '<leader>dq', dap_cmd('terminate'), { desc = 'Debug: Terminate' })

-- Disconnect
map('n', '<leader>dd', dap_cmd('disconnect'), { desc = 'Debug: Disconnect' })

-- Run to cursor
map('n', '<leader>dC', dap_cmd('run_to_cursor'), { desc = 'Debug: Run to cursor' })

-- Go to line (no execute)
map('n', '<leader>dg', dap_cmd('goto_'), { desc = 'Debug: Go to line' })

-- Restart
map('n', '<leader>dr', dap_cmd('restart'), { desc = 'Debug: Restart' })
map('n', '<C-F5>', dap_cmd('restart'), { desc = 'Debug: Restart' })

-- Toggle REPL
map('n', '<leader>dR', dap_cmd('repl.toggle'), { desc = 'Debug: Toggle REPL' })

-- Session
map('n', '<leader>ds', dap_cmd('session'), { desc = 'Debug: Session' })

-- Widget hover
map({ 'n', 'v' }, '<leader>dh', function()
  local ok, widgets = pcall(require, 'dap.ui.widgets')
  if ok then
    widgets.hover()
  end
end, { desc = 'Debug: Hover' })

-- Widget preview
map({ 'n', 'v' }, '<leader>dP', function()
  local ok, widgets = pcall(require, 'dap.ui.widgets')
  if ok then
    widgets.preview()
  end
end, { desc = 'Debug: Preview' })

-- Frames
map('n', '<leader>df', function()
  local ok, widgets = pcall(require, 'dap.ui.widgets')
  if ok then
    widgets.centered_float(widgets.frames)
  end
end, { desc = 'Debug: Frames' })

-- Scopes
map('n', '<leader>dS', function()
  local ok, widgets = pcall(require, 'dap.ui.widgets')
  if ok then
    widgets.centered_float(widgets.scopes)
  end
end, { desc = 'Debug: Scopes' })

-- DAP UI
map('n', '<leader>du', dapui_cmd('toggle'), { desc = 'Debug: Toggle UI' })
map('n', '<leader>de', dapui_cmd('eval'), { desc = 'Debug: Eval' })
map('v', '<leader>de', dapui_cmd('eval'), { desc = 'Debug: Eval selection' })

return {}
