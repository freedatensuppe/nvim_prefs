require("nvchad.mappings")

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("i", "jk", "<ESC>")

map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>")
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>")
map("n", "<leader>dc", "<cmd> DapContinue <CR>")

-- function required to use . to repeat DapContinue
_G._operator_func = function()
	require("dap").step_over()
end

map("n", "<leader>do", function()
	vim.o.operatorfunc = "v:lua._operator_func"
	vim.cmd.normal("g@l")
end, { desc = " DapStepOver" })
-- map("n", "<leader>do", "<cmd> DapStepOver <CR>")
map("n", "<leader>di", "<cmd> DapStepInto <CR>")
map("n", "<leader>dO", "<cmd> DapStepOut <CR>")
map("n", "<leader>dq", "<cmd> DapTerminate <CR>")

local M = {}

M.general = {

	n = {
		["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
		["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
		["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
		["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
	},
}

return M
