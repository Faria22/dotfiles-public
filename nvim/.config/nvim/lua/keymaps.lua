-- Moves by actual lines if using a count
local function smart_movement(key, wrapped_movement)
  vim.keymap.set({ 'n', 'v' }, key, function()
    return vim.v.count == 0 and key or wrapped_movement
  end, { expr = true })
end

-- Using the function to set the keymaps
smart_movement('n', 'j')
smart_movement('e', 'k')
smart_movement('i', 'l')
smart_movement('m', 'h')

vim.keymap.set('', '<Up>', 'g<Up>', { silent = true })
vim.keymap.set('', '<Down>', 'g<Down>', { silent = true })

vim.keymap.set('n', '<C-S-;>', '<C-y>', { silent = true })
vim.keymap.set('n', '<C-y>', '<C-e>', { silent = true })

-- Folds
vim.keymap.set('n', 'gf', 'za', { silent = true })

-- Spelling
vim.keymap.set('n', '<leader>s', '1z=', { noremap = true, silent = true, desc = 'First spelling suggestions' })

-- Turn off search highlighting
vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>')

-- Format code without moving cursor
vim.keymap.set('n', '<leader>=', vim.lsp.buf.format,
  { noremap = true, silent = true, desc = 'Reformat code without moving cursor' })

-- Format on save
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ buffer = args.buf, id = client.id })
        end,
      })
    end
  end,
})

-- LSP keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
vim.keymap.set('n', '<leader>c', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end,
  { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end,
  { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>ih', function() vim.lsp.inlay_hint.enable(true) end, { desc = 'Enable Inlay Hints' })
vim.keymap.set('n', '<leader>iH', function() vim.lsp.inlay_hint.enable(false) end, { desc = 'Disable Inlay Hints' })

-- Quickfix
vim.keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { noremap = true, silent = true, desc = "Open Quickfix List" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { noremap = true, silent = true, desc = "Close Quickfix List" })
vim.keymap.set("n", "<leader>qcl", "<cmd>call setqflist([])<CR>",
  { noremap = true, silent = true, desc = "Clear Quickfix List" })

-- Run lua code
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>',
  { noremap = true, silent = true, desc = 'Run current lua file' })
vim.keymap.set('n', '<leader>x', ':.lua<CR>', { noremap = true, silent = true, desc = 'Run current lua line' })
vim.keymap.set('v', '<leader>x', ':.lua<CR>', { noremap = true, silent = true, desc = 'Run current lua selection' })


-- prints variable that cursor is on
local esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
vim.fn.setreg('p', "viWyoprint('" .. esc .. "pa:', " .. esc .. "pa)" .. esc)

-- logs in debug mode variable that cursor is on
vim.fn.setreg('l', "viWyologger.debug('" .. esc .. "pa: %s', " .. esc .. "pa)" .. esc)

-- Split window and navigate
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.keymap.set('n', '<leader>h', '<cmd>sp<CR>', { silent = true, desc = 'Split Window' })
vim.keymap.set('n', '<leader>v', '<cmd>vsp<CR>', { silent = true, desc = 'Vertical Split Window' })

vim.keymap.set('n', '<C-N>', '<C-W>j', { silent = true, desc = 'Move Down' })
vim.keymap.set('n', '<C-E>', '<C-W>k', { silent = true, desc = 'Move Up' })
vim.keymap.set('n', '<C-M>', '<C-W>h', { silent = true, desc = 'Move Left' })
vim.keymap.set('n', '<C-I>', '<C-W>l', { silent = true, desc = 'Move Right' })

vim.keymap.set('n', '<C-S-M>', '<C-W>5<', { silent = true, desc = 'Decrease Width' })
vim.keymap.set('n', '<C-S-I>', '<C-W>5>', { silent = true, desc = 'Increase Width' })
vim.keymap.set('n', '<C-S-E>', '<C-W>5+', { silent = true, desc = 'Increase Height' })
vim.keymap.set('n', '<C-S-N>', '<C-W>5-', { silent = true, desc = 'Decrease Height' })

vim.keymap.set('n', '<C-S-O>', '<C-I>', { silent = true, desc = 'Move to next item in jump list' })
