local mason_dap = require("mason-nvim-dap")
local dap = require("dap")
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")
dap_virtual_text.setup()

mason_dap.setup({
	ensure_installed = { "python" },
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
	},
})

dap.configurations = {
	python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",

			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
				-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
				-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
				-- Use VIRTUAL_ENV environment variable if set
				local venv = os.getenv("VIRTUAL_ENV")
				if venv then
					return venv .. "/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
		},
	},
}

local dapui_opts = {
	layouts = {
		{
			elements = {
				{ id = "console", size = 0.5 },
				{ id = "repl", size = 0.5 },
			},
			position = "left",
			size = 60,
		},
		{
			elements = {
				{ id = "scopes", size = 0.50 },
				{ id = "breakpoints", size = 0.20 },
				{ id = "stacks", size = 0.15 },
				{ id = "watches", size = 0.15 },
			},
			position = "bottom",
			size = 25,
		},
	},
}

ui.setup(dapui_opts)

vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end
