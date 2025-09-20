local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  -- use 'morhetz/gruvbox'
  -- DoomeOne theme
  use 'NTBBloodbath/doom-one.nvim'

  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- File explorer (neo-tree)
use({
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- Optional image support in preview window: See `# Preview Mode` for more information
    -- { "3rd/image.nvim", config = function() require('image').setup({}) end },
    -- OR use snacks.nvim's image module:
    -- "folke/snacks.nvim",
  }
})

  -- Icons
  use 'ryanoasis/vim-devicons'
  use 'nvim-tree/nvim-web-devicons'

  -- Others
  use 'vim-scripts/tComment'
  use 'nathanaelkane/vim-indent-guides'
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use 'prabirshrestha/async.vim'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'sebdah/vim-delve'
  use 'go-delve/delve'
  use 'vim-test/vim-test'
  use 'tpope/vim-dispatch'
  use 'nvim-lua/plenary.nvim'
  use 'BurntSushi/ripgrep'
  use 'folke/trouble.nvim'

	-- Completions
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "hrsh7th/cmp-cmdline" }) -- cmdline completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })
	use({ "onsails/lspkind-nvim" })

	-- LSP
	use({ "neovim/nvim-lspconfig" }) -- enable LSP
	-- use({ "williamboman/nvim-lsp-installer" }) -- deprecated
  use({ "williamboman/mason.nvim" })
  use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
  use({ "glepnir/lspsaga.nvim" }) -- LSP UIs
  use 'juliosueiras/terraform-lsp'
  use 'prabirshrestha/asyncomplete.vim'
  use 'prabirshrestha/asyncomplete-lsp.vim'

	-- Formatter
	use({ "MunifTanjim/prettier.nvim" })

  -- Lamguage
  use 'github/copilot.vim'
  use 'othree/yajs.vim'
  use 'chase/vim-ansible-yaml'
  use 'hashivim/vim-terraform'
  use 'juliosueiras/vim-terraform-completion'
  use 'nvie/vim-Flake8'
  use 'mattn/vim-goimports'
  use 'rust-lang/rust.vim'
  use 'moll/vim-node'

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzy-native.nvim'},
    },
  }

  -- Snacks.nvim (dependency for claudecode.nvim)
  use {
    'folke/snacks.nvim',
    config = function()
      local snacks = require('snacks')
      if not snacks.did_setup then
        snacks.setup({
          terminal = { 
            enabled = true,
            win = {
              -- DoomOne theme colors for terminal
              wo = {
                winhl = "Normal:Normal,FloatBorder:FloatBorder,FloatTitle:FloatTitle,FloatFooter:FloatFooter"
              },
            },
          },
        })
      end


      -- Create Snacks commands manually
      vim.api.nvim_create_user_command('SnackTerminal', function()
        require('snacks').terminal.toggle()
      end, { desc = 'Toggle terminal' })

      vim.api.nvim_create_user_command('SnackTerminalOpen', function()
        require('snacks').terminal.open()
      end, { desc = 'Open terminal' })
    end
  }

  -- Claude Code for Neovim
  use {
    'coder/claudecode.nvim',
    after = 'snacks.nvim',
    config = function()
      require('claudecode').setup()
    end
  }

  -- Treesitter for syntax highlighting and parsing
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "lua", "vim", "vimdoc", "query", "javascript", "typescript", "python", "go", "rust", "json", "yaml", "markdown" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end
  }

  -- TreeSJ for split/join syntax tree nodes
  use {
    'Wansmer/treesj',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup()
    end
  }

  -- GitSigns for git integration
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        current_line_blame = false,
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
      })
    end
  }

  -- Git blame
  use {
    'f-person/git-blame.nvim',
    config = function()
      require('gitblame').setup({
        enabled = true,
        message_template = ' <summary> • <date> • <author>',
        date_format = '%m/%d/%y',
        virtual_text_column = 1,
      })
    end
  }

  -- Grug-far for find and replace
  use {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('replace')
    end
  }

  -- Chunk highlighting
  use {
    'shellRaining/hlchunk.nvim',
    config = function()
      require('hlchunk').setup({
        chunk = {
          enable = true,
          style = "#00ffff",
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
          },
        },
        indent = {
          enable = false,
        }
      })
    end
  }


  -- mason.nvim
  require("mason").setup()

  -- startup
  use {
    "startup-nvim/startup.nvim",
    requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
    -- config = function()
    --   require"startup".setup({theme = "dashboard"})
    -- end
  }
end)

