-- Helper function to set highlights
local function setHighlight(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Underline spelling mistakes
local spellGroups = { 'SpellBad', 'SpellCap', 'SpellLocal', 'SpellRare' }
for _, group in ipairs(spellGroups) do
  setHighlight(group, { underline = true })
end

-- MatchParen highlight
setHighlight('MatchParen', { ctermfg = 96, ctermbg = 'NONE', fg = 'purple', bg = 'NONE' })
