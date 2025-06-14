local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- 個別ファイルに分けたプラグイン群
  { import = "plugins" },

  -- 個別ファイルにしていないプラグイン（ここに追加）
  { "tpope/vim-fugitive" },
  { "junegunn/fzf.vim" },
  { "junegunn/fzf", build = "./install --all" },
  { "shaunsingh/nord.nvim" },
  { "ChristianChiarulli/nvcode-color-schemes.vim" },
  { "Shougo/unite.vim" },
  { "Shougo/vimproc.vim", build = "make" }
})
