-- ============================================================================
-- Plugin: nvim-colorizer.lua
-- Repository: norcalli/nvim-colorizer.lua
-- Category: Color Visualization / Visual Enhancement
--
-- Purpose:
--   Real-time color highlighting in code for all color formats.
--   Displays actual colors inline by highlighting the background.
--
-- Key Features:
--   - Inline color preview for various formats
--   - Hex color support (#RGB, #RRGGBB, #RRGGBBAA)
--   - Named colors (e.g., "blue", "red")
--   - CSS function support (rgb(), rgba(), hsl(), hsla())
--   - Background color display mode
--   - Active on all file types by default
--   - Real-time updates as you type
--
-- Supported Formats:
--   - #RGB, #RRGGBB, #RRGGBBAA
--   - Named colors (blue, red, etc.)
--   - rgb(), rgba() functions
--   - hsl(), hsla() functions
--   - CSS color names and functions
--
-- Display Mode:
--   Background highlighting (colors shown as background)
-- ============================================================================

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
