vim.keymap.set('n', 's', '<NOP>',{noremap = true})
vim.keymap.set('n', 'sf', '<cmd>lua require("telescope.builtin").find_files()<cr>',{noremap = true})
vim.keymap.set('n', 'sb', '<cmd>lua require("telescope.builtin").buffers()<cr>',{noremap = true})
vim.keymap.set('n', 'sh', '<cmd>lua require("telescope.builtin").help_tags()<cr>',{noremap = true})
vim.keymap.set('n', 'sg', '<cmd>lua require("telescope.builtin").live_grep()<cr>',{noremap = true})

require('telescope').setup{
  defaults = {
    -- ...
  },
  pickers = {
    find_files = {
      theme = "dropdown",
    }
  },
  extensions = {
    -- ...
  }
}

-- This will load fzy_native and have it override the default file sorter
require('telescope').load_extension('fzy_native')
