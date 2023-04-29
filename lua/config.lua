local signature_config = {
  log_path = vim.fn.expand("$HOME") .. "/tmp/sig.log",
  debug = true,
  hint_enable = false,
  handler_opts = { border = "single" },
  max_width = 80,

 vim.keymap.set({ 'n' }, '<Leader>k', function()
     vim.lsp.buf.signature_help()
  end, { silent = true, noremap = true, desc = 'toggle signature' })
}

require("lsp_signature").setup(signature_config)

