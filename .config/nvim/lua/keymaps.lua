local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

--local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- New tab
keymap("n", "te", ":tabedit", opts)
-- 新しいタブを一番右に作る
keymap("n", "gn", ":tabnew<Return>", opts)
-- move tab
keymap("n", "gh", "gT", opts)
keymap("n", "gl", "gt", opts)

-- Split window
keymap("n", "ss", ":split<Return><C-w>w", opts)
keymap("n", "sv", ":vsplit<Return><C-w>w", opts)

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", opts)

-- Do not yank with x
keymap("n", "x", '"_x', opts)

-- Delete a word backwards
keymap("n", "dw", 'vb"_d', opts)

-- 行の端に行く
keymap("n", "<Space>h", "^", opts)
keymap("n", "<Space>l", "$", opts)

-- Claude Code keybindings
keymap("n", "<Space>cc", "<cmd>ClaudeCode<cr>", opts)
keymap("n", "<Space>cr", "<cmd>ClaudeCode --resume<cr>", opts)
keymap("v", "<Space>cs", "<cmd>ClaudeCodeSend<cr>", opts)
keymap("n", "<Space>cf", "<cmd>ClaudeCodeFocus<cr>", opts)
keymap("n", "<Space>cC", "<cmd>ClaudeCode --continue<cr>", opts)
keymap("n", "<Space>cm", "<cmd>ClaudeCodeSelectModel<cr>", opts)
keymap("n", "<Space>cb", "<cmd>ClaudeCodeAdd %<cr>", opts)
keymap("n", "<Space>ca", "<cmd>ClaudeCodeDiffAccept<cr>", opts)
keymap("n", "<Space>cd", "<cmd>ClaudeCodeDiffDeny<cr>", opts)

-- Snacks.nvim keybindings (デフォルト設定)
keymap("n", "st", "<cmd>lua Snacks.terminal.toggle()<cr>", opts)  -- ターミナルをトグル
keymap("t", "st", "<cmd>lua Snacks.terminal.toggle()<cr>", opts)  -- ターミナルモードでもトグル
keymap("n", "sf", "<cmd>lua Snacks.picker.smart()<cr>", opts)  -- スマートファイル検索
keymap("n", "sg", "<cmd>lua Snacks.picker.grep()<cr>", opts)  -- grep検索
keymap("n", "sb", "<cmd>lua Snacks.gitbrowse()<cr>", opts)  -- git browse in browser
keymap("n", "sl", "<cmd>lua Snacks.lazygit()<cr>", opts)  -- lazygit

-- ;でコマンド入力( ;と:を入れ替)
keymap("n", ";", ":", opts)

-- 行末までのヤンクにする
keymap("n", "Y", "y$", opts)

-- <Space>q で強制終了
keymap("n", "<Space>q", ":<C-u>q!<Return>", opts)

-- ESC*2 でハイライトやめる
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)

-- checktime for reloading externally changed files
keymap("n", "ct", ":checktime<CR>", opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)

-- Ctrl-kでカーソル位置から行末まで削除
keymap("i", "<C-k>", "<C-o>d$", opts)

-- コンマの後に自動的にスペースを挿入
-- keymap("i", ",", ",<Space>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- ビジュアルモード時vで行末まで選択
keymap("v", "v", "$h", opts)

-- 0番レジスタを使いやすくした（<C-p>をnamu.nvimで使うため変更）
keymap("v", "<leader>p", '"0p', opts)

-- snacks.nvim explorer
vim.keymap.set("n", "<C-e>", "<cmd>lua Snacks.explorer()<CR>", { noremap = true, silent = true })

-- LSP keymaps
-- 関数定義にジャンプ
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
-- 関数の実装にジャンプ
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
-- 関数の参照を表示
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
-- 関数のドキュメントを表示
keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

-- ジャンプ履歴ナビゲーション
-- 前の位置に戻る
keymap("n", "<C-y>", "<C-o>", opts)
-- 次の位置に進む
keymap("n", "<C-i>", "<C-i>", opts)
-- ジャンプ履歴を表示
keymap("n", "<leader>j", ":jumps<CR>", opts)

-- Terminal --
-- Terminal escape and window navigation
keymap("t", "<C-\\>", "<C-\\><C-N>", term_opts)  -- Escape terminal mode
keymap("t", "<C-w>h", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-w>j", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-w>k", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-w>l", "<C-\\><C-N><C-w>l", term_opts)

-- TreeSJ keybindings
keymap("n", "mm", "<cmd>TSJToggle<CR>", opts)  -- split/join toggle
keymap("n", "mj", "<cmd>TSJJoin<CR>", opts)    -- join
keymap("n", "ms", "<cmd>TSJSplit<CR>", opts)   -- split

-- Git blame keybindings
keymap("n", "gb", "<cmd>GitBlameToggle<CR>", opts)  -- toggle git blame
keymap("n", "gB", "<cmd>GitBlameCopyCommitURL<CR>", opts)  -- copy commit URL

-- Namu.nvim keybindings
vim.keymap.set("n", "nm", ":Namu symbols<cr>", { desc = "Jump to LSP symbol", silent = true })
vim.keymap.set("n", "nw", ":Namu workspace<cr>", { desc = "LSP Symbols - Workspace", silent = true })

