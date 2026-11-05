return {
  'RRethy/vim-illuminate',
  config = function()
    local illuminate = require('illuminate')

    illuminate.configure({
      providers = {
        'lsp',
        'regex',
      },
    })

    vim.keymap.set('n', '<Tab>', illuminate.goto_next_reference, { desc = 'Next Reference' })
    vim.keymap.set('n', '<S-Tab>', illuminate.goto_prev_reference, { desc = 'Previous Reference' })
  end,
}
