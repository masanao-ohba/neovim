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
      model = "claude-3.7-sonnet",
      debug = true,
    },
  },
}
