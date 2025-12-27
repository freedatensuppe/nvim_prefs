require("nvchad.mappings")

local map = vim.keymap.set

local function run_python_float_term()
	local file = vim.fn.expand("%:p")
	vim.cmd("write")
	local cmd = { "bash", "-c", "python3 " .. file .. "; echo 'Press any key to exit...'; read -n 1 -s" }
	require("lazy.util").float_term(cmd, {
		cwd = vim.fn.getcwd(),
	})
end

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

map("n", "<leader>q", run_python_float_term, { noremap = true, silent = true, desc = "Run current Python file" })
map("n", "<F5>", run_python_float_term, { noremap = true, silent = true, desc = "Run current Python file" })
map("i", "<F5>", run_python_float_term, { noremap = true, silent = true, desc = "Run current Python file" })

-- Interactive Wezterm iPython
map("n", "<leader>ip", "<cmd>WeztermIpythonToggle<cr>", { desc = "Toggle Wezterm iPython pane" })
map({ "n", "i" }, "<S-CR>", "<cmd>WeztermIpythonSendLine<cr>", { desc = "Send Line to Wezterm iPython pane" })
map("x", "<S-CR>", "<cmd>WeztermIpythonSendRange<cr>", { desc = "Send Selection to Wezterm iPython pane" })
