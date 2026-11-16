return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit" },
  keys = {
    { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame (Enter: blame before change)" },
  },
}
