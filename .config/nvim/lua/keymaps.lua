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

-- ;でコマンド入力( ;と:を入れ替)
keymap("n", ";", ":", opts)

-- 行末までのヤンクにする
keymap("n", "Y", "y$", opts)

-- <Space>q で強制終了
keymap("n", "<Space>q", ":<C-u>q!<Return>", opts)

-- ESC*2 でハイライトやめる
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)

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

-- 0番レジスタを使いやすくした
keymap("v", "<C-p>", '"0p', opts)

-- neo-tree
vim.keymap.set("n", "<C-e>", "<cmd>Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<CR>", { noremap = true, silent = true })

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
