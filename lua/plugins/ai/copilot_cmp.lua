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

    local source = require("copilot_cmp.source")
    source.is_available = function(self)
      -- client is stopped.
      if self.client:is_stopped() or not self.client.name == "copilot" then
        return false
      end

      local get_source_client = function()
        if vim.lsp.get_clients == nil then
          return vim.lsp.get_active_clients({
            bufnr = vim.api.nvim_get_current_buf(),
            id = self.client.id,
          })
        end
        return vim.lsp.get_clients({
          bufnr = vim.api.nvim_get_current_buf(),
          id = self.client.id,
        })
      end

      return next(get_source_client()) ~= nil
    end
  end,
}
