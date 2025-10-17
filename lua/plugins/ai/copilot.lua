-- ============================================================================
-- Plugin: copilot.lua
-- Repository: zbirenbaum/copilot.lua
-- Category: AI Assistance
--
-- Purpose:
--   GitHub Copilot integration for inline code suggestions in Neovim.
--   Provides real-time AI-powered code completions as you type.
--
-- Key Features:
--   - Auto-triggered inline suggestions while typing
--   - Configurable keybindings for suggestion navigation and acceptance
--   - Filetype-specific filtering (can disable for sensitive files)
--   - Cycle through multiple suggestion alternatives
--   - Integration with nvim-cmp via copilot-cmp
--   - Debounced suggestions to reduce API calls
--
-- Keybindings:
--   <C-l>   - Accept suggestion
--   <S-]>   - Next suggestion
--   <S-[>   - Previous suggestion
--   <C-d>   - Dismiss suggestion
-- ============================================================================

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  config = function()
    require("copilot").setup({
      -- suggestion = {enabled = false},
      -- panel = {enabled = false},
      -- copilot_node_command = 'node'

      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<S-]>",
          prev = "<S-[>",
          dismiss = "<C-d>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },

      filetypes = {
        markdown = true,
        gitcommit = true,
        ['*'] = function()
          -- disable for files with specific names
          local fname = vim.fs.basename(vim.api.nvim_buf_get_name(0))
          local disable_patterns = { 'env', 'conf', 'local', 'private' }
          return vim.iter(disable_patterns):all(function(pattern)
            return not string.match(fname, pattern)
          end)
        end,
      },

    })
  end,
}
