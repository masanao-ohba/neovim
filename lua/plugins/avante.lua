return {
  "yetone/avante.nvim",
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- オプションの依存関係
    "hrsh7th/nvim-cmp",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
  },
  opts = {
    -- provideをclaudeに変更
    provider = "copilot",
    auto_suggestions_provider = "copilot",

    -- ウィンドウ設定
    windows = {
      position = "right",
      wrap = true,
      width = 30,
      sidebar_header = {
        enabled = true,
        align = "center",
        rounded = true,
      },
      input = {
        prefix = "> ",
        height = 6,
      },
      edit = {
        border = "rounded",
        start_insert = true,
      },
      ask = {
        floating = false,
        start_insert = true,
        border = "rounded",
        focus_on_apply = "ours",
      },
    },
    -- キーマッピングの設定
    mappings = {
      suggestion = {
        accept = "<C-c>",
        next = "<C-n>",
        previous = "<C-p>",
      },
    },
    selector = {
      --- @alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
      provider = "fzf",
      -- Options override for custom providers
      provider_opts = {},
    }
  }
}
