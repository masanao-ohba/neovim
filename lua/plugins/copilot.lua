return {
  "github/copilot.vim",
  event = "InsertEnter", -- 挿入モードで遅延読み込み
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
  end,
}
