return {
  -- Language support
  {
    "github/copilot.vim",
  },
  {
    "othree/yajs.vim",
  },
  {
    "chase/vim-ansible-yaml",
  },
  {
    "hashivim/vim-terraform",
    config = function()
      -- vim-terraform settings
      vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
      vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
      vim.cmd([[autocmd BufRead,BufNewFile *.hcl,*.tf,*.tfvars set filetype=terraform]])
      vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
      vim.cmd([[let g:terraform_fmt_on_save=1]])
      vim.cmd([[let g:terraform_align=1]])
      vim.api.nvim_command('autocmd BufWritePre *.hcl TerraformFmt')
    end,
  },
  {
    "juliosueiras/vim-terraform-completion",
  },
  {
    "nvie/vim-Flake8",
  },
  {
    "mattn/vim-goimports",
  },
  {
    "rust-lang/rust.vim",
  },
  {
    "moll/vim-node",
  },
}
