return {
  -- Language support
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

      -- Disable vim-terraform's built-in fmt on save
      vim.cmd([[let g:terraform_fmt_on_save=0]])
      vim.cmd([[let g:terraform_align=1]])

      -- Custom format function that uses mise-aware terraform
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = {"*.tf", "*.tfvars", "*.hcl"},
        callback = function()
          local buf_dir = vim.fn.expand("%:p:h")
          -- Use mise exec to run terraform in the correct project context
          local cmd = string.format("cd %s && mise exec -- terraform fmt -write=true %s",
                                    vim.fn.shellescape(buf_dir),
                                    vim.fn.shellescape(vim.fn.expand("%:p")))
          vim.fn.system(cmd)
          -- Reload buffer to reflect changes
          vim.cmd("edit")
        end,
      })
    end,
  },
  {
    "juliosueiras/vim-terraform-completion",
  },
  -- {
  --   "nvie/vim-Flake8",
  -- },
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
