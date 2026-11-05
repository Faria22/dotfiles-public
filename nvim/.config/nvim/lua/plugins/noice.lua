return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("noice").setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        signature = {
          enabled = false,
        },
      },
      presets = {
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,            -- enables an input dialog for inc-rename.nvim
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "lines",
          },
          opts = { skip = true },
        },
      }
    })

    -- Function to toggle Noice LSP Signature Help
    local noice_signature_enabled = false

    function ToggleNoiceSignatureHelp()
      noice_signature_enabled = not noice_signature_enabled
      require("noice").setup({
        lsp = {
          signature = {
            enabled = noice_signature_enabled,
          },
        },
      })

      if noice_signature_enabled then
        vim.notify("Noice LSP Signature Help: Enabled")
      else
        vim.notify("Noice LSP Signature Help: Disabled")
      end
    end

    -- Keymap to toggle Noice Signature Help
    vim.keymap.set('n', '<leader>sh', ToggleNoiceSignatureHelp, { desc = "Toggle Noice LSP Signature Help" })
  end,
}
