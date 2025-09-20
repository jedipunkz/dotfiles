local grugfar = require('grug-far')

grugfar.setup({
  -- use filetype regex patterns if available
  transient = false,

  -- appearance
  icons = {
    enabled = true,
    actionEntryBullet = "• ",
  },

  -- keymaps
  keymaps = {
    replace = { n = '<localleader>r' },
    qflist = { n = '<localleader>q' },
    syncLocations = { n = '<localleader>s' },
    syncLine = { n = '<localleader>l' },
    close = { n = '<localleader>c' },
    historyOpen = { n = '<localleader>t' },
    historyAdd = { n = '<localleader>a' },
    refresh = { n = '<localleader>f' },
    openLocation = { n = '<localleader>o' },
    gotoLocation = { n = '<enter>' },
    pickHistoryEntry = { n = '<enter>' },
    abort = { n = '<localleader>b' },
    help = { n = 'g?' },
    toggleShowCommand = { n = '<localleader>p' },
  },

  -- custom window configurations
  windowCreationCommand = 'vnew',

  -- results display
  resultLocation = {
    showNumberColumn = true,
  },
})

-- Global keymaps for quick access
vim.keymap.set('n', '<leader>sr', function()
  grugfar.open()
end, { desc = 'Open grug-far search and replace' })

vim.keymap.set('n', '<leader>sw', function()
  grugfar.open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = 'Search and replace word under cursor' })

vim.keymap.set('v', '<leader>sr', function()
  grugfar.with_visual_selection()
end, { desc = 'Search and replace visual selection' })