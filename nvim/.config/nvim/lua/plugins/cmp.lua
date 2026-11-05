return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
  },
  opts = {},
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
            cmp.select_next_item()
          end
        end,
        ["<C-p>"] = function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
            cmp.select_prev_item()
          end
        end,
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = {
        { name = "nvim_lsp" },                 -- Completion from LSP (Pyright)
        { name = "lazydev", group_index = 0 }, -- set group index to 0 to skip loading LuaLS completions
      },
      -- Disable auto-popup
      completion = {
        autocomplete = false, -- Prevent automatic completion popups
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end
      },
    })

    vim.diagnostic.config({
      virtual_text = {
        severity = { min = vim.diagnostic.severity.HINT },
      },
    })
  end,
}
