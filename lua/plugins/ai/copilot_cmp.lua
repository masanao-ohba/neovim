-- ============================================================================
-- Plugin: copilot-cmp
-- Repository: zbirenbaum/copilot-cmp
-- Category: AI Assistance / Completion Integration
--
-- Purpose:
--   GitHub Copilot source adapter for nvim-cmp completion engine.
--   Integrates Copilot suggestions seamlessly into the nvim-cmp interface.
--
-- Key Features:
--   - Copilot suggestions appear in nvim-cmp completion menu
--   - Unified completion interface with other sources (LSP, buffer, etc.)
--   - Automatic integration with copilot.lua
-- ============================================================================

return {
  "zbirenbaum/copilot-cmp",
  config = function ()
    require("copilot_cmp").setup()
  end
}
