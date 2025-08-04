local plugins = {
	{
		"mfussenegger/nvim-lint",
		event = "VeryLazy",
		config = function()
			require("configs.lint")
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
	{
		"lervag/vimtex",
		lazy = false,
		config = function()
			vim.g.vimtex_view_method = "zathura"
		end,
		ft = "tex",
	},
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			require("configs.nvim-dap")
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
	},
	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		opts = function()
			return require("configs.null-ls")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig")
			require("configs.lspconfig")
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"clangd",
				"clang-format",
				"codelldb",
				"eslint-lsp",
				"prettier",
				"pyright",
				"typescript-language-server",
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			"echasnovski/mini.pick", -- optional
		},
		config = true,
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "echasnovski/mini.icons", version = false },
	{ "akinsho/git-conflict.nvim", version = "v2.1.0", config = true },
	{
		"chomosuke/typst-preview.nvim",
		lazy = false, -- or ft = 'typst'
		version = "1.*",
		opts = {}, -- lazy.nvim will implicitly calls `setup {}`
	},
}

return plugins
