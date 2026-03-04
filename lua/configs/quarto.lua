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

function QuartoPreview2()
	local api = vim.api
	local util = require("quarto.util")
	require("quarto.config")

	local args, buf = "", api.nvim_get_current_buf()
	local buffer_path = api.nvim_buf_get_name(buf)
	local root = util.root_pattern("_quarto.yml")(buffer_path)

	-- ensure it's a quarto file
	local ext = buffer_path:match("%.[^.]+$") or ""
	if not vim.tbl_contains({ ".qmd", ".Rmd", ".ipynb", ".md" }, ext) then
		return vim.notify("Not a quarto file: " .. ext, vim.log.levels.WARN)
	end

	-- render-on-save check
	local lines = root and vim.fn.readfile(root .. "/_quarto.yml") or api.nvim_buf_get_lines(buf, 0, 500, false)
	local ros = true
	for _, l in ipairs(lines) do
		if l:find("render%-on%-save:%s*false") then
			ros = false
			break
		end
	end
	if not ros and not args:find("%-%-no%-watch%-inputs") then
		args = args .. " --no-watch-inputs"
	end

	local target = root and vim.fn.shellescape(root) or vim.fn.shellescape(buffer_path)
	local cmd = "quarto preview " .. target .. " " .. args

	-- open terminal split (unlisted, wipe on hide)
	vim.cmd("botright 15split | enew")
	local tbuf = api.nvim_get_current_buf()
	vim.bo[tbuf].buflisted = false
	vim.bo[tbuf].bufhidden = "wipe"
	vim.bo[tbuf].swapfile = false
	vim.bo[tbuf].scrollback = 100000 -- large scrollback for history
	pcall(api.nvim_buf_set_name, tbuf, "[Quarto Preview]")
	pcall(api.nvim_buf_set_var, tbuf, "quartoOutputBuf", true)

	-- start the terminal job
	vim.fn.termopen(cmd, {
		on_exit = function(_, code)
			if code ~= 0 then
				vim.notify("Quarto preview failed: " .. code, vim.log.levels.ERROR)
			end
		end,
	})

	-- helper: find window showing a given buffer
	local function win_for_buf(bufnr)
		for _, win in ipairs(api.nvim_list_wins()) do
			if api.nvim_win_get_buf(win) == bufnr then
				return win
			end
		end
	end

	-- move focus to the terminal window, jump to bottom, and enter terminal mode
	local term_win = win_for_buf(tbuf)
	if term_win then
		api.nvim_set_current_win(term_win)
		vim.cmd("normal! G")
		-- keep "follow" behavior when re-entering this terminal
		local g = api.nvim_create_augroup("quartoPreviewTermFollow_" .. tbuf, { clear = true })
		api.nvim_create_autocmd({ "BufEnter", "TermOpen" }, {
			buffer = tbuf,
			group = g,
			callback = function()
				-- jump to bottom and enter terminal-mode again
				pcall(vim.cmd, "normal! G")
				pcall(vim.cmd, "startinsert")
			end,
		})
	end

	if QuartoConfig and QuartoConfig.closePreviewOnExit then
		local g = api.nvim_create_augroup("quartoPreview", { clear = true })
		api.nvim_create_autocmd({ "BufDelete", "WinClosed" }, {
			buffer = buf,
			group = g,
			callback = function()
				if api.nvim_buf_is_loaded(tbuf) then
					pcall(api.nvim_buf_delete, tbuf, { force = true })
				end
			end,
		})
	end

	-- return focus to previous window (optional)
	vim.cmd("wincmd p")
end

vim.api.nvim_create_user_command("QuartoPreview2", QuartoPreview2, { desc = "Quarto with horizontal split" })
