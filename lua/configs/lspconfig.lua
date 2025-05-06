local base = require "nvchad.configs.lspconfig"
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require "lspconfig"

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    --    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,

  capabilities = capabilities,
}

lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { "*" },
      },
    },
  },
}

-- npm install --save-dev @types/node; needed for eslint to work properly
lspconfig.ts_ls.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = false,
    },
  },
}

require("lspconfig").ruff.setup {
  init_options = {
    settings = {
      logLevel = "debug",
    },
  },
}

require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "ruff_fix", "ruff_format" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

require("dap-python").setup "python3"

require("git-conflict").setup {
  default_mappings = true, -- disable buffer local mapping created by this plugin
  default_commands = true, -- disable commands created by this plugin
  disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
  list_opener = "copen", -- command or function to open the conflicts list
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = "DiffAdd",
    current = "DiffText",
  },
}
