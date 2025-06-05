return {
  "hashivim/vim-terraform",
  ft = { "terraform", "hcl", "tf" },
  init = function()
    vim.g.terraform_fmt_on_save = 0
    vim.g.terraform_align = 1
  end
}
