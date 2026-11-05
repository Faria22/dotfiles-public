local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function uv_root(bufnr)
  local root = vim.fs.root(bufnr, { { 'uv.lock', '.git' } })
  if root and vim.uv.fs_stat(root .. '/uv.lock') then
    return root
  end
end

-- Organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = buffer,
  callback = function()
    if vim.bo.filetype == "python" then
      vim.lsp.buf.code_action({
        ---@diagnostic disable-next-line: missing-fields
        context = { only = { "source.fixAll.ruff" }, },
        apply = true,
      })
      vim.wait(100)
    end
  end,
})

vim.lsp.config('ruff', {
  init_options = {
    configuration = vim.fn.expand("~/.ruff.toml")
  }
})

vim.lsp.enable('ruff')

-- basedpyright
vim.lsp.config('basedpyright', {
  capabilities = capabilities, -- Enables completion support
  root_dir = function(bufnr, on_dir)
    if uv_root(bufnr) then
      return
    end

    local root = vim.fs.root(bufnr, {
      {
        'pyrightconfig.json',
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        '.git',
      },
    })
    if root then
      on_dir(root)
    end
  end,
  settings = {
    basedpyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
})
vim.lsp.enable('basedpyright')

-- Use ty for uv projects and basedpyright everywhere else.
vim.lsp.config('ty', {
  capabilities = capabilities,
  root_dir = function(bufnr, on_dir)
    local root = uv_root(bufnr)
    if root then
      on_dir(root)
    end
  end,
})
vim.lsp.enable('ty')

vim.hl.priorities.semantic_tokens = 95

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})
