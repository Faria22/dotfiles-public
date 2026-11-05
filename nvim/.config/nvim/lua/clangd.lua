local no_format_files = {
  ["keymap.c"] = true,
}

vim.lsp.config('clangd', {
  on_attach = function(client, bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local base = vim.fs.basename(fname)

    if no_format_files[base] then
      client:stop()
      return
    end
  end,
})
vim.lsp.enable('clangd')
