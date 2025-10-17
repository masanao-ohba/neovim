-- ============================================================================
-- Plugin: mcphub.nvim
-- Repository: ravitemer/mcphub.nvim
-- Category: AI Assistance / MCP Integration
--
-- Purpose:
--   Model Context Protocol (MCP) Hub integration for Neovim.
--   Enables connection to multiple MCP servers and provides context
--   aggregation for AI tools like Avante.
--
-- Key Features:
--   - MCP server management and integration
--   - System prompt generation from active MCP servers
--   - Extension support for AI plugins (Avante integration)
--   - Automatic MCP Hub CLI installation via npm
--
-- Usage:
--   Used by Avante for enhanced context awareness through MCP servers
-- ============================================================================

return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest",
  config = function()
    require("mcphub").setup()
  end,
}
