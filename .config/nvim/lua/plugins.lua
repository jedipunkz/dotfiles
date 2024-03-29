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
  use 'morhetz/gruvbox'

  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

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

