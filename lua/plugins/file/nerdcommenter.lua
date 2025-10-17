-- ============================================================================
-- Plugin: nerdcommenter
-- Repository: preservim/nerdcommenter
-- Category: Code Editing / File Management
--
-- Purpose:
--   Easy code commenting and uncommenting with language-aware support.
--   Provides quick toggle for comment blocks in any programming language.
--
-- Key Features:
--   - Language-aware commenting (adapts to file type)
--   - Toggle comments for single or multiple lines
--   - Block comment support
--   - Empty line commenting capability
--   - Left-aligned comments
--   - Automatic space after comment delimiters
--
-- Keybindings:
--   <C-/> - Toggle comment (normal/visual mode)
--
-- Configuration:
--   Default mappings: disabled (custom <C-/> only)
--   Align: left
--   Space delimiters: enabled
--   Comment empty lines: enabled
-- ============================================================================

return {
  "preservim/nerdcommenter",
  keys = {
    { "<C-/>", "<Plug>NERDCommenterToggle", mode = { "n", "v" }, desc = "Toggle comment" },
  },
  init = function()
    -- NERDCommenter の基本オプション（必要なら）
    vim.g.NERDCreateDefaultMappings = 0
    vim.g.NERDDefaultAlign = 'left'
    vim.g.NERDSpaceDelims = 1
    vim.g.NERDCommentEmptyLines = 1
  end,
}
