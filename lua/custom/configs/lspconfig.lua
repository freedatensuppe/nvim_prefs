local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = {}
  opts.border = opts.border or 'single'
  opts.max_width = opts.max_width or 80
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

lspconfig.clangd.setup{
  on_attach = function (client, bufnr)
--    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,

  capabilities = capabilities,
}

lspconfig.pyright.setup {
  on_attach = function (client, bufnr)
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}
