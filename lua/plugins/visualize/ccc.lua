return {
  "uga-rosa/ccc.nvim",
  cmd = { "CccPick", "CccConvert" },
  keys = {
    { "<leader>cp", "<cmd>CccPick<cr>", desc = "Pick color" },
    { "<leader>cc", "<cmd>CccConvert<cr>", desc = "Convert color format" },
  },
  config = function()
    require("ccc").setup({
      highlighter = {
        auto_enable = true,    -- 自動でハイライト
        lsp = true,            -- LSPカラー情報も利用
      },
      picker = {
        default = "color",     -- デフォルトでカラーピッカー
      },
      convert = {
        -- デフォルトの変換先: hex, rgb, hsl など
        { "hex", "rgb", "hsl" },
      },
      output = {
        hex = { case = "lower" }, -- #rrggbb を小文字に統一
      },
    })
  end,
}
