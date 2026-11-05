return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
  },
  config = function()
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'

    telescope.setup {
      pickers = {
        find_files = {
          find_command = { 'fd', '--type', 'f', '--follow', '--exclude', '.git' },
        },
        live_grep = {
          -- use ripgrep with hidden files, but respect .gitignore
          additional_args = function()
            return { '--follow' }
          end,
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {}
        },
        fzf = {
          fuzzy = true, -- fuzzy matching
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case", -- ignore case unless capitals
        }
      }
    }

    -- after setup
    telescope.load_extension 'fzf'
    telescope.load_extension 'ui-select'

    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics' })
    vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Commands' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Grep Word' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end, { desc = 'Find Config Files' })
  end,
}
