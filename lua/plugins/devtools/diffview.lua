-- ============================================================================
-- Plugin: diffview.nvim
-- Repository: sindrets/diffview.nvim
-- Category: Git Integration / Development Tools
--
-- Purpose:
--   Advanced git diff viewer with side-by-side comparison and file history.
--   Provides comprehensive diff viewing and navigation capabilities.
--
-- Key Features:
--   - Side-by-side diff viewing for file changes
--   - File history browser with commit navigation
--   - Interactive diff navigation with custom keybindings
--   - Integration with gitsigns for unified git workflow
--   - Merge conflict resolution interface
--
-- Keybindings (File History Panel):
--   <S-P> - Previous commit entry
--   <S-N> - Next commit entry
--
-- Commands:
--   :DiffviewFileHistory % - Show current file history (via gitsigns <leader>gb)
--   :DiffviewFileHistory   - Show project history (via gitsigns <leader>gB)
-- ============================================================================

return {
  "sindrets/diffview.nvim",
  config = function()
    require('diffview').setup({
      keymaps = {
        file_history_panel = {
          ["<S-P>"] = "prev_entry",
          ["<S-N>"] = "next_entry",
        }
      }
    })
    -- Git blame/historyはgitsignsに統一のためコメントアウト
    -- vim.keymap.set('n', '<leader>gb', '<cmd>DiffviewFileHistory %<cr>')
  end
}
