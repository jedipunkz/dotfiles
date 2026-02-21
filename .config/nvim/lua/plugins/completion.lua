return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/vim-vsnip",
      "fang2hou/blink-copilot",
      {
        "zbirenbaum/copilot.lua",
        config = function()
          require("copilot").setup({
            suggestion = {
              enabled = true,
              auto_trigger = true,
              keymap = {
                accept = "<Tab>",
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-e>",
              },
            },
            panel = { enabled = false },
          })
        end,
      },
    },
    config = function()
      require("blink.cmp").setup({
        keymap = {
          preset = 'none',
          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'cancel', 'fallback' },
          ['<CR>'] = { 'accept', 'fallback' },
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
          ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        },
        completion = {
          documentation = { auto_show = true, auto_show_delay_ms = 200 },
          ghost_text = { enabled = false },  -- NES との競合回避
        },
        snippets = { preset = 'vsnip' },
        sources = {
          default = { 'copilot', 'lsp', 'snippets', 'path', 'buffer' },
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-copilot",
              async = true,
              score_offset = 100,
              opts = { max_completions = 3, debounce = 200 },
            },
          },
        },
        cmdline = {
          enabled = true,
          keymap = { preset = 'cmdline' },
          completion = { menu = { auto_show = true } },
          sources = function()
            local t = vim.fn.getcmdtype()
            if t == '/' or t == '?' then return { 'buffer' } end
            if t == ':' then return { 'path', 'cmdline' } end
            return {}
          end,
        },
        signature = { enabled = true },
      })
    end,
  },
}
