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
--   <leader>ap  - Copilot ON/OFF
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
    -- Use the modern preset
    preset = "modern",
    -- Other basic settings
    delay = 450,
    expand = 1,
    notify = true,
    triggers = {
      { "<auto>", mode = "nixsotc" },
      { "s", mode = { "n", "v" } },
    },
    -- Group display settings
    icons = {
      mappings = false,
      group = "", -- Empty the prefix shown before groups (hide "+")
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Close which-key with Esc
    wk.add({
      { "<Esc>", hidden = true, mode = "n" },
    })

    -- Register basic keymap groups
    wk.add({
      { "<leader>a",   group = "󰚩  AI" },
      { "<leader>ac",  group = "󰛄  Claude" },
      { "<leader>ap",  group = "Copilot" },
      { "<leader>g",   group = "  Git" },
      { "<leader>gs",  desc  = "󱖫  Git Status NeoTree" },
      { "<leader>gy",  desc  = "  Git Yank GitHub URL" },
      { "<leader>gv",  desc  = "Diffview: compare range" },
      { "<leader>gV",  desc  = "Diffview: close" },
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
