-- ============================================================================
-- Plugin: ccc.nvim
-- Repository: uga-rosa/ccc.nvim
-- Category: Color Management / Visual Enhancement
--
-- Purpose:
--   Interactive color picker and format converter for color values in code.
--   Provides visual color selection and conversion between color formats.
--
-- Key Features:
--   - Interactive color picker with visual interface
--   - Format conversion (hex ↔ rgb ↔ hsl)
--   - Auto-highlighting of color values in code
--   - LSP color information integration
--   - Lowercase hex output (#rrggbb format)
--   - Real-time color preview while editing
--
-- Keybindings:
--   <leader>cp - Open color picker
--   <leader>cc - Convert color format
--
-- Commands:
--   :CccPick    - Launch interactive color picker
--   :CccConvert - Convert color format under cursor
--
-- Configuration:
--   Highlighter: auto-enabled with LSP support
--   Output: lowercase hex format
-- ============================================================================

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
