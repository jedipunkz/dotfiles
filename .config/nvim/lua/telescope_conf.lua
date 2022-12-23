vim.keymap.set('n', 's', '<NOP>',{noremap = true})
vim.keymap.set('n', 'sf', '<cmd>lua require("telescope.builtin").find_files()<cr>',{noremap = true})
vim.keymap.set('n', 'sb', '<cmd>lua require("telescope.builtin").buffers()<cr>',{noremap = true})
vim.keymap.set('n', 'sh', '<cmd>lua require("telescope.builtin").help_tags()<cr>',{noremap = true})
