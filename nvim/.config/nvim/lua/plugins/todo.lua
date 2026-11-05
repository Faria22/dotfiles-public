return {
  'folke/todo-comments.nvim',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {},
  config = function()
    require('todo-comments').setup()
    vim.keymap.set('n', ']t', require('todo-comments').jump_next, { desc = 'Next Todo' })
    vim.keymap.set('n', '[t', require('todo-comments').jump_prev, { desc = 'Previous Todo' })
  end,
}
