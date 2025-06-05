return {
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { ",lg", ":LazyGit<CR>", desc = "Open LazyGit" },
  },
}
