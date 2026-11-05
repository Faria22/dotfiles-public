local languages = {
  'bash',
  'c',
  'python',
  'comment',
  'vim',
  'vimdoc',
  'regex',
  'query',
  'lua',
  'markdown',
  'markdown_inline',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require('nvim-treesitter')

    treesitter.install(languages)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = languages,
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
