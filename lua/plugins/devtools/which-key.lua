return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- modern presetを使用
    preset = "modern",
    -- その他の基本設定
    delay = 450,
    expand = 1,
    notify = true,
    triggers = {
      { "<auto>", mode = "nixsotc" },
      { "s", mode = { "n", "v" } },
    },
    -- グループ表示の設定
    icons = {
      mappings = false,
      group = "", -- グループの前に表示される文字を空にする（"+"を非表示）
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Escキーでwhich-keyを無効化
    wk.add({
      { "<Esc>", hidden = true, mode = "n" },
    })

    -- 基本的なキーマッピングのグループを登録
    wk.add({
      { "<leader>a",   group = "󰚩  AI" },
      { "<leader>ac",  group = "󰛄  Claude" },
      { "<leader>ag",  group = "  Avante" },
      { "<leader>aga", desc  = "󱋉  Ask"},
      { "<leader>age", desc  = "  Edit" },
      { "<leader>g",   group = "  Git" },
      { "<leader>gs",  desc  = "󱖫  Git Status NeoTree" },
      { "<leader>c",   desc  = "  Color Managements" },
      { "<leader>cp",  desc  = "󰴱  ColorPicker" },
      { "<leader>cc",  desc  = "  Convert ColorFromat" },
      { "<leader>`",   group = "  Code Block for Markdown" },
      { "<leader>R",   group = "󰛔  Bulk Replacein the Project" },
      { ",v",          group = "  View" },
      { ",vd",         group = "  View Diff Tools" },
      { ",t",          group = "  Terminal" },
    })
  end,
}
