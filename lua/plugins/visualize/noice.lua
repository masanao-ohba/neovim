-- lazy.nvim用
return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",    -- UIコンポーネント
    "rcarriga/nvim-notify"     -- 通知サポート（任意）
  },
  config = function()
    require("noice").setup({
      stages = "fade",
      timeout = 500, -- 通知の表示時間
      cmdline = {
        enabled = true,
        view = "cmdline_popup", -- 中央ポップアップにする
        format = {
          cmdline = { icon = ">_" }, -- 好みに応じて変更可能
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = "40%", -- 中央付近に配置
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
          border = {
            style = "rounded",
            padding = { 1, 2 },
          },
        },
      },
    })
  end,
}
