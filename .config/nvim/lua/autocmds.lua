local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Remove whitespace on save
autocmd("BufWritePre", {
	pattern = "*",
	command = ":%s/\\s\\+$//e",
})

-- Don't auto commenting new lines
autocmd("BufEnter", {
	pattern = "*",
	command = "set fo-=c fo-=r fo-=o",
})

-- Restore cursor location when file is opened
autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})

-- Modicatorのハイライト設定
autocmd({ "ColorScheme", "VimEnter" }, {
	callback = function()
		-- Modicatorのハイライト設定（モードごとの色）
		vim.api.nvim_set_hl(0, 'ModicatorNormal', { fg = '#7aa2f7', bold = true })
		vim.api.nvim_set_hl(0, 'ModicatorInsert', { fg = '#9ece6a', bold = true })
		vim.api.nvim_set_hl(0, 'ModicatorVisual', { fg = '#bb9af7', bold = true })
		vim.api.nvim_set_hl(0, 'ModicatorReplace', { fg = '#f7768e', bold = true })
		vim.api.nvim_set_hl(0, 'ModicatorCommand', { fg = '#e0af68', bold = true })
		vim.api.nvim_set_hl(0, 'ModicatorTerminal', { fg = '#73daca', bold = true })
	end,
})
