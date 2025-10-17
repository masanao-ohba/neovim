-- ============================================================================
-- Plugin: indent-blankline.nvim
-- Repository: lukas-reineke/indent-blankline.nvim
-- Category: Visual Guide / Visual Enhancement
--
-- Purpose:
--   Display indent guides for better code readability and structure visualization.
--   Shows vertical lines for each indentation level.
--
-- Key Features:
--   - Visual indent level markers
--   - Tree-sitter integration for context-aware indentation
--   - Scope highlighting (highlights current code block)
--   - Customizable indent characters
--   - Minimal configuration (uses defaults)
--
-- Configuration:
--   Uses default settings with Tree-sitter integration
-- ============================================================================

return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" }
}
