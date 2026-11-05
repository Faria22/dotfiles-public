return {
  'smjonas/inc-rename.nvim',
  opts = {},
  config = function()
    require("inc_rename").setup()
    vim.keymap.set("n", "<leader>r", ":IncRename ", { desc = "Rename" })
    vim.keymap.set("n", "<leader>R", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = "Rename with word" })
  end,
}
