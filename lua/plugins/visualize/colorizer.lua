return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("colorizer").setup({
      "*"; -- 全ファイルタイプで有効
    }, {
      RGB      = true;  -- #RGB
      RRGGBB   = true;  -- #RRGGBB
      RRGGBBAA = true;  -- #RRGGBBAA
      names    = true;  -- "blue" など色名も
      rgb_fn   = true;  -- rgb(), rgba()
      hsl_fn   = true;  -- hsl(), hsla()
      css      = true;  -- css: CSSカラー名
      css_fn   = true;  -- css: rgb()等関数
      mode     = "background"; -- 背景色で表示（文字色変更も可）
    })
  end,
}
