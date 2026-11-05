local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { "Cargo.toml", "rust-project.json", ".git" })
    on_dir(root)
  end,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
})

vim.lsp.enable("rust_analyzer")
