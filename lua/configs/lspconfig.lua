require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "pyright", "clangd", "ts_ls", "ruff" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--background-index",
    "--offset-encoding=utf-8",
  },
  root_markers = { ".clangd", "compile_commands.json" },
  filetypes = { "c", "cpp" },
}

vim.lsp.config.ruff = {
  settings = {
    checkFix = true,
    format = true,
    organizeImports = true,
    lineLength = 80, -- Black
    showSyntaxErrors = false, -- Redundant (handled by Pyright)
    lint = {
      -- Linter Configuration: These are the linters that I think will be
      -- able to identify most of the code smells. These linters are non-
      -- overlapping with Pyright's linting.
      --
      -- To know more about linters supported by Ruff, execute: ruff linter
      select = { "E", "I", "SIM", "B", "S", "N" },
    },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  },
}

vim.lsp.config.ts_ls = {
  preferences = {
    disableSuggestions = false,
  },
  -- npm install --save-dev @types/node; needed for eslint to work properly
}

require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "ruff", "ruff_fix", "ruff_format" },
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
