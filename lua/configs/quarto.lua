require("quarto").setup({
	debug = false,
	closePreviewOnExit = true,
	lspFeatures = {
		enabled = true,
		chunks = "curly",
		languages = { "r", "python", "julia", "bash", "html" },
		diagnostics = {
			enabled = true,
			triggers = { "BufWritePost" },
		},
		completion = {
			enabled = true,
		},
	},
	codeRunner = {
		enabled = true,
		default_method = "slime",
		ft_runners = {},
		never_run = { "yaml" },
	},
})

local M = {}

function M.preview()
	local api = vim.api
	local tools = require("quarto.tools")
	local util = require("quarto.util")
	require("quarto.config")

	local opts = {}
	local args = opts.args or ""
	local buffer_path = api.nvim_buf_get_name(0)
	local root_dir = util.root_pattern("_quarto.yml")(buffer_path)

	-- render-on-save check
	local render_on_save = true
	local lines
	if root_dir then
		lines = vim.fn.readfile(root_dir .. "/_quarto.yml")
	else
		lines = api.nvim_buf_get_lines(0, 0, 500, false)
	end
	for _, line in ipairs(lines) do
		if line:find("render%-on%-save: false") then
			render_on_save = false
			break
		end
	end

	if not render_on_save and not args:find("%-%-no%-watch%-inputs") then
		args = args .. " --no-watch-inputs"
	end

	local cmd = root_dir and ("quarto preview " .. vim.fn.shellescape(root_dir) .. " " .. args)
		or ("quarto preview " .. vim.fn.shellescape(buffer_path) .. " " .. args)

	local ext = buffer_path:match("^.+(%..+)$")
	local quarto_exts = { ".qmd", ".Rmd", ".ipynb", ".md" }
	if not ext or not vim.tbl_contains(quarto_exts, ext) then
		vim.notify("Not a quarto file: " .. (ext or "none"), vim.log.levels.WARN)
		return
	end

	-- Try to find an existing preview terminal in this tab
	local existing = nil
	for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
		local buf = api.nvim_win_get_buf(win)
		local ok, mark = pcall(api.nvim_buf_get_var, buf, "quartoOutputBuf")
		if ok and mark == true then
			existing = { win = win, buf = buf }
			break
		end
	end

	-- Open or reuse a horizontal split at the bottom
	if existing and api.nvim_buf_is_valid(existing.buf) then
		api.nvim_set_current_win(existing.win)
		api.nvim_set_current_buf(existing.buf)
		-- Stop any existing running job (best-effort)
		local job = vim.b.terminal_job_id
		if job and job > 0 then
			pcall(vim.fn.jobstop, job)
		end
	else
		vim.cmd("botright 15split | enew")
	end

	local term_buf = api.nvim_get_current_buf()

	-- Make the buffer hidden from buffer/tab bars and ephemeral
	pcall(api.nvim_buf_set_name, term_buf, "[Quarto Preview]")
	vim.bo[term_buf].buflisted = false
	vim.bo[term_buf].bufhidden = "wipe"
	vim.bo[term_buf].swapfile = false
	vim.bo[term_buf].modifiable = true -- termopen will switch buftype to 'terminal'

	-- Mark this buffer for reuse
	pcall(api.nvim_buf_set_var, term_buf, "quartoOutputBuf", true)

	-- Start/restart the terminal job
	vim.fn.termopen(cmd, {
		on_exit = function(_, code)
			if code ~= 0 then
				vim.notify("Quarto preview failed: " .. code, vim.log.levels.ERROR)
			end
		end,
	})

	-- Optional: enter insert mode for terminal
	vim.cmd("startinsert")

	-- Clean up terminal buffer when source buffer/window closes (if configured)
	if QuartoConfig and QuartoConfig.closePreviewOnExit then
		local group = api.nvim_create_augroup("quartoPreview", { clear = true })
		api.nvim_create_autocmd({ "BufDelete", "WinClosed" }, {
			buffer = 0,
			group = group,
			callback = function()
				if api.nvim_buf_is_loaded(term_buf) then
					pcall(api.nvim_buf_delete, term_buf, { force = true })
				end
			end,
		})
	end

	-- Return to previous window
	vim.cmd("wincmd p")
end

return M
