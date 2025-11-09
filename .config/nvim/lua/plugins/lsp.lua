return {
  -- Inline diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
    end,
  },
  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Disable default virtual text to use tiny-inline-diagnostic instead
      vim.diagnostic.config({ virtual_text = false })

      -- Mappings
      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

      -- on_attach function
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lsp_flags = {
        debounce_text_changes = 150,
      }

      -- Global LSP configuration
      vim.lsp.config('*', {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = lsp_flags,
      })

      -- Pyright (Python)
      vim.lsp.config.pyright = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = lsp_flags,
      }

      -- TypeScript/JavaScript
      vim.lsp.config.ts_ls = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = lsp_flags,
      }

      -- Rust
      vim.lsp.config.rust_analyzer = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          ["rust-analyzer"] = {}
        }
      }

      -- Go
      vim.lsp.config.gopls = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = lsp_flags,
      }

      -- Lua (Neovim configuration)
      vim.lsp.config.lua_ls = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      -- Zig
      vim.lsp.config.zls = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = lsp_flags,
      }

      -- Enable configured LSP servers
      vim.lsp.enable({'pyright', 'ts_ls', 'rust_analyzer', 'gopls', 'lua_ls', 'zls'})
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "glepnir/lspsaga.nvim",
  },
  {
    "juliosueiras/terraform-lsp",
  },
  {
    "prabirshrestha/asyncomplete.vim",
  },
  {
    "prabirshrestha/asyncomplete-lsp.vim",
  },

  -- Formatter
  {
    "MunifTanjim/prettier.nvim",
  },
}
