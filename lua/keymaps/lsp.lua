-- LSP keymaps
-- These keymaps are set up in an LspAttach autocmd so they only apply when LSP is active

local map = vim.keymap.set
local utils = require('core.utils')

-- Setup LSP keymaps on attach
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-keymaps', { clear = true }),
  callback = function(event)
    local buf = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local function buf_map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = 'LSP: ' .. desc })
    end

    -- Navigation (via Snacks.picker)
    buf_map('n', 'gd', function()
      Snacks.picker.lsp_definitions()
    end, 'Goto definition')

    buf_map('n', 'gD', vim.lsp.buf.declaration, 'Goto declaration')

    buf_map('n', 'gi', function()
      Snacks.picker.lsp_implementations()
    end, 'Goto implementation')

    buf_map('n', 'gr', function()
      Snacks.picker.lsp_references()
    end, 'Goto references')

    buf_map('n', 'gy', function()
      Snacks.picker.lsp_type_definitions()
    end, 'Goto type definition')

    buf_map('n', 'gO', function()
      Snacks.picker.lsp_symbols()
    end, 'Document symbols')

    buf_map('n', 'gW', function()
      Snacks.picker.lsp_workspace_symbols()
    end, 'Workspace symbols')

    -- Hover and signature
    buf_map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
    buf_map('n', 'gK', vim.lsp.buf.signature_help, 'Signature help')
    buf_map('i', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')

    -- Code actions
    buf_map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, 'Code action')
    buf_map('n', '<leader>lA', function()
      vim.lsp.buf.code_action({
        context = {
          only = { 'source' },
          diagnostics = {},
        },
      })
    end, 'Source action')

    -- Rename
    buf_map('n', '<leader>lr', vim.lsp.buf.rename, 'Rename symbol')

    -- Format
    buf_map({ 'n', 'v' }, '<leader>lf', function()
      require('conform').format({ async = true, lsp_format = 'fallback' })
    end, 'Format')

    -- Diagnostics
    buf_map('n', 'gl', vim.diagnostic.open_float, 'Line diagnostics')
    buf_map('n', '<leader>ld', vim.diagnostic.open_float, 'Line diagnostics')
    buf_map('n', '<leader>lD', function()
      Snacks.picker.diagnostics_buffer()
    end, 'Buffer diagnostics')

    -- LSP info
    buf_map('n', '<leader>li', '<cmd>LspInfo<CR>', 'LSP info')

    -- Codelens
    if client and client.supports_method('textDocument/codeLens') then
      buf_map('n', '<leader>ll', vim.lsp.codelens.run, 'CodeLens action')
      buf_map('n', '<leader>lL', vim.lsp.codelens.refresh, 'CodeLens refresh')
    end

    -- Inlay hints
    if client and client.supports_method('textDocument/inlayHint') then
      buf_map('n', '<leader>lh', function()
        utils.toggle_inlay_hints(buf)
      end, 'Toggle inlay hints')
    end
  end,
})

-- Diagnostic navigation (global, works even without LSP)
map('n', ']d', function()
  vim.diagnostic.goto_next()
end, { desc = 'Next diagnostic' })

map('n', '[d', function()
  vim.diagnostic.goto_prev()
end, { desc = 'Previous diagnostic' })

map('n', ']e', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Next error' })

map('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Previous error' })

map('n', ']w', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { desc = 'Next warning' })

map('n', '[w', function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, { desc = 'Previous warning' })

return {}
