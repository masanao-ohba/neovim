-- ============================================================================
-- Plugin: which-key.nvim
-- Repository: folke/which-key.nvim
-- Category: Keybinding Helper / Development Tools
--
-- Purpose:
--   Display available keybindings in a popup menu with descriptions.
--   Helps discover and remember complex keybinding hierarchies.
--
-- Key Features:
--   - Hierarchical keybinding display with icons
--   - Custom group definitions for organized menus
--   - Modern preset UI with clean aesthetics
--   - Context-aware keybinding suggestions
--   - Configurable delay before popup appears
--   - Hidden keybindings support (e.g., <Esc>)
--
-- Defined Groups:
--   <leader>a   - AI operations
--   <leader>ac  - Claude integrations
--   <leader>ag  - Avante operations
--   <leader>g   - Git operations
--   <leader>c   - Color management
--   <leader>`   - Code blocks for Markdown
--   <leader>R   - Bulk replace in project
--   ,v          - View options
--   ,t          - Terminal operations
--
-- Configuration:
--   delay: 450ms
--   preset: modern
-- ============================================================================

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- modern presetを使用
    preset = "modern",
    -- その他の基本設定
    delay = 450,
    expand = 1,
    notify = true,
    triggers = {
      { "<auto>", mode = "nixsotc" },
      { "s", mode = { "n", "v" } },
    },
    -- グループ表示の設定
    icons = {
      mappings = false,
      group = "", -- グループの前に表示される文字を空にする（"+"を非表示）
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Escキーでwhich-keyを無効化
    wk.add({
      { "<Esc>", hidden = true, mode = "n" },
    })

    -- 基本的なキーマッピングのグループを登録
    wk.add({
      { "<leader>a",   group = "󰚩  AI" },
      { "<leader>ac",  group = "󰛄  Claude" },
      { "<leader>ag",  group = "  Avante" },
      { "<leader>aga", desc  = "󱋉  Ask"},
      { "<leader>age", desc  = "  Edit" },
      { "<leader>g",   group = "  Git" },
      { "<leader>gs",  desc  = "󱖫  Git Status NeoTree" },
      { "<leader>gy",  desc  = "  Git Yank GitHub URL" },
      { "<leader>c",   desc  = "  Color Managements" },
      { "<leader>cp",  desc  = "󰴱  ColorPicker" },
      { "<leader>cc",  desc  = "  Convert ColorFromat" },
      { "<leader>`",   group = "  Code Block for Markdown" },
      { "<leader>R",   group = "󰛔  Bulk Replacein the Project" },
      { ",v",          group = "  View" },
      { ",vd",         group = "  View Diff Tools" },
      { ",t",          group = "  Terminal" },
    })
  end,
}
