-- Set mapleader and maplocalleader before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('base')
require('autocmds')
require('config.lazy')
require('options')
require('keymaps')
require('colorscheme')
require('lsp')
require('completion')
require('statusline')
require('language')
require('tab')

