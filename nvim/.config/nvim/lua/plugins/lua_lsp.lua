local capabilities = require('cmp_nvim_lsp').default_capabilities()

return {
  "folke/lazydev.nvim",
  ft = "lua", -- only load on lua files
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
  config = function()
    require("lazydev").setup({
      capabilities = capabilities
    })
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          hint = {
            enable = true, -- necessary
          }
        }
      }
    })
    vim.lsp.enable('lua_ls')
  end,
}
