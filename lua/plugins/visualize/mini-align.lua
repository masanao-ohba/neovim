-- ============================================================================
-- Plugin: mini.align
-- Repository: echasnovski/mini.align
-- Category: Text Alignment / Visual Enhancement
--
-- Purpose:
--   Interactive text alignment tool with live preview.
--   Aligns text based on delimiters or patterns for improved readability.
--
-- Key Features:
--   - Interactive alignment with real-time preview
--   - Align by any delimiter (=, :, |, etc.)
--   - Visual mode support for block alignment
--   - Normal mode for line-based alignment
--   - Preview mode (gA) shows alignment before applying
--
-- Keybindings:
--   ga  - Align without preview (normal/visual mode)
--   gA  - Align with preview (normal/visual mode)
--
-- Usage Examples:
--   Select lines → ga= → aligns on = signs
--   Select lines → gA: → preview alignment on : colons
-- ============================================================================

return {
  "echasnovski/mini.align",
  version = "*",
  keys = {
    { "ga", mode = { "n", "x" }, desc = "align" },
    { "gA", mode = { "n", "x" }, desc = "align with preview" },
  },
  opts = {},
}