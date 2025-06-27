return {
  "preservim/nerdcommenter",
  keys = {
    { "<C-/>", "<Plug>NERDCommenterToggle", mode = { "n", "v" }, desc = "Toggle comment" },
  },
  init = function()
    -- NERDCommenter の基本オプション（必要なら）
    vim.g.NERDCreateDefaultMappings = 0
    vim.g.NERDDefaultAlign = 'left'
    vim.g.NERDSpaceDelims = 1
    vim.g.NERDCommentEmptyLines = 1
  end,
}
