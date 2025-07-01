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
    selector = {
      --- @alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
      provider = "fzf_lua",
      -- Options override for custom providers
      provider_opts = {},
    },
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      return hub:get_active_servers_prompt()
    end,
    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
      }
    end,
  },
  config = function(_, opts)
    require("avante").setup(opts)
    
    -- デフォルトキーマップを強制削除
    local keymaps_to_delete = {
      "<leader>a", "<leader>aa", "<leader>ah", "<leader>as", "<leader>aB", 
      "<leader>an", "<leader>aS", "<leader>ad", "<leader>ar", "<leader>at",
      "<leader>af", "<leader>aR", "<leader>a?"
    }
    
    for _, keymap in ipairs(keymaps_to_delete) do
      pcall(function()
        vim.keymap.del("n", keymap)
        vim.keymap.del("v", keymap)
      end)
    end
    
    -- 手動でキーマップを設定（which-keyと連携）
    vim.keymap.set("n", "<leader>aga", function() require("avante.api").ask() end, { desc = "Avante: Ask" })
    vim.keymap.set("v", "<leader>aga", function() require("avante.api").ask() end, { desc = "Avante: Ask" })
    vim.keymap.set("n", "<leader>age", function() require("avante.api").edit() end, { desc = "Avante: Edit" })
    vim.keymap.set("v", "<leader>age", function() require("avante.api").edit() end, { desc = "Avante: Edit" })
  end,
}
