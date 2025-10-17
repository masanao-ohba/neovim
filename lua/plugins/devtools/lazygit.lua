-- ============================================================================
-- Plugin: lazygit.nvim
-- Repository: kdheepak/lazygit.nvim
-- Category: Git Integration / Development Tools
--
-- Purpose:
--   LazyGit terminal UI integration for comprehensive git operations.
--   Provides a full-featured, interactive git interface within Neovim.
--
-- Key Features:
--   - Full LazyGit terminal interface in Neovim
--   - Interactive commit and staging operations
--   - Branch management and visualization
--   - Merge and rebase operations
--   - Stash management
--   - Git log browsing with diff viewing
--
-- Keybindings:
--   <leader>gl - Open LazyGit interface
--
-- Commands:
--   :LazyGit - Launch LazyGit terminal UI
-- ============================================================================

return {
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gl", ":LazyGit<CR>", desc = "Open LazyGit" },
  },
}
