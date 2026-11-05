return {
  'Faria22/nvim-stay.lua',
  event = 'BufReadPre',
  opts = {
    disabled_viewoptions = { 'folds' },
  },
  config = function(_, opts)
    require('stay').setup(opts)
  end,
}
