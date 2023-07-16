vim.cmd("autocmd!")

vim.scriptencoding = "utf-8"

vim.wo.number = true

-- for vim-terraform
-- ref: https://github.com/hashivim/vim-terraform/pull/133
vim.o.compatible = false
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')
