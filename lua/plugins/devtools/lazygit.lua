return {
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gl", ":LazyGit<CR>", desc = "Open LazyGit" },
  },
}
