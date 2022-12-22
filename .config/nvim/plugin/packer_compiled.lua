-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/thirai/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/thirai/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/thirai/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/thirai/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/thirai/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["async.vim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/async.vim",
    url = "https://github.com/prabirshrestha/async.vim"
  },
  ["asyncomplete-lsp.vim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/asyncomplete-lsp.vim",
    url = "https://github.com/prabirshrestha/asyncomplete-lsp.vim"
  },
  ["asyncomplete.vim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/asyncomplete.vim",
    url = "https://github.com/prabirshrestha/asyncomplete.vim"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["ctrlp.vim.git"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/ctrlp.vim.git",
    url = "https://github.com/kien/ctrlp.vim.git"
  },
  ["dein.vim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/dein.vim",
    url = "https://github.com/Shougo/dein.vim"
  },
  delve = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/delve",
    url = "https://github.com/go-delve/delve"
  },
  gruvbox = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/gruvbox",
    url = "https://github.com/morhetz/gruvbox"
  },
  ["nerdtree.git"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/nerdtree.git",
    url = "https://github.com/scrooloose/nerdtree.git"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ripgrep = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/ripgrep",
    url = "https://github.com/BurntSushi/ripgrep"
  },
  ["rust.vim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/rust.vim",
    url = "https://github.com/rust-lang/rust.vim"
  },
  syntastic = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/syntastic",
    url = "https://github.com/vim-syntastic/syntastic"
  },
  tComment = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/tComment",
    url = "https://github.com/vim-scripts/tComment"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["terraform-lsp"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/terraform-lsp",
    url = "https://github.com/juliosueiras/terraform-lsp"
  },
  ["trouble.nvim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/ultisnips",
    url = "https://github.com/SirVer/ultisnips"
  },
  ["vim-Flake8"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-Flake8",
    url = "https://github.com/nvie/vim-Flake8"
  },
  ["vim-airline"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-airline",
    url = "https://github.com/vim-airline/vim-airline"
  },
  ["vim-airline-themes"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-airline-themes",
    url = "https://github.com/vim-airline/vim-airline-themes"
  },
  ["vim-ansible-yaml"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-ansible-yaml",
    url = "https://github.com/chase/vim-ansible-yaml"
  },
  ["vim-delve"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-delve",
    url = "https://github.com/sebdah/vim-delve"
  },
  ["vim-dispatch"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-dispatch",
    url = "https://github.com/tpope/vim-dispatch"
  },
  ["vim-goimports"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-goimports",
    url = "https://github.com/mattn/vim-goimports"
  },
  ["vim-indent-guides"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-indent-guides",
    url = "https://github.com/nathanaelkane/vim-indent-guides"
  },
  ["vim-lsp"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-lsp",
    url = "https://github.com/prabirshrestha/vim-lsp"
  },
  ["vim-lsp-settings"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-lsp-settings",
    url = "https://github.com/mattn/vim-lsp-settings"
  },
  ["vim-lsp-snippets"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-lsp-snippets",
    url = "https://github.com/thomasfaingnaert/vim-lsp-snippets"
  },
  ["vim-lsp-ultisnips"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-lsp-ultisnips",
    url = "https://github.com/thomasfaingnaert/vim-lsp-ultisnips"
  },
  ["vim-node"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-node",
    url = "https://github.com/moll/vim-node"
  },
  ["vim-quickrun.git"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-quickrun.git",
    url = "https://github.com/thinca/vim-quickrun.git"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-snippets",
    url = "https://github.com/honza/vim-snippets"
  },
  ["vim-terraform"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-terraform",
    url = "https://github.com/hashivim/vim-terraform"
  },
  ["vim-terraform-completion"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-terraform-completion",
    url = "https://github.com/juliosueiras/vim-terraform-completion"
  },
  ["vim-test"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ",
    url = "https://github.com/hrsh7th/vim-vsnip-integ"
  },
  ["yajs.vim"] = {
    loaded = true,
    path = "/Users/thirai/.local/share/nvim/site/pack/packer/start/yajs.vim",
    url = "https://github.com/othree/yajs.vim"
  }
}

time([[Defining packer_plugins]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
