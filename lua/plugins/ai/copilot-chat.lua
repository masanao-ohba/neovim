-- ============================================================================
-- Plugin: CopilotChat.nvim
-- Repository: CopilotC-Nvim/CopilotChat.nvim
-- Category: AI Assistance
--
-- Purpose:
--   GitHub Copilot chat interface for conversational AI assistance.
--   Provides an interactive chat window for asking questions and getting
--   code suggestions through natural language conversations.
--
-- Key Features:
--   - Interactive chat interface with GitHub Copilot
--   - Model selection support (Claude Sonnet 4, GPT-4.1)
--   - Context-aware code suggestions based on current buffer
--   - Debug mode for troubleshooting AI responses
--   - Tiktoken integration for accurate token counting
--
-- Configuration:
--   Uses external copilot_chat_config module for detailed setup
-- ============================================================================

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken",
    config = function()
      -- 設定モジュールを呼び出す
      require("copilot_chat_config").setup()
    end,
    opts = {
      -- プラグインのオプションをここに設定
      -- model = "claude-sonnet-4",
      model = "gpt-4.1",
      debug = true,
    },
  },
}
