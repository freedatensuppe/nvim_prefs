local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")

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


-- npm install --save-dev @types/node; needed for eslint to work properly
lspconfig.ts_ls.setup {
  on_attach = function (client, bufnr)
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = false
    }
  }
}
