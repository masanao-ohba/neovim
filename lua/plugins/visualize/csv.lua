-- ============================================================================
-- Plugin: csv.vim
-- Repository: chrisbra/csv.vim
-- Category: File Format Support / Visual Enhancement
--
-- Purpose:
--   CSV file viewing and editing with enhanced column-based features.
--   Provides specialized tools for working with comma-separated data files.
--
-- Key Features:
--   - Column-based navigation and highlighting
--   - Automatic delimiter detection (comma by default)
--   - Header row highlighting (Title style)
--   - Automatic column arrangement
--   - Concealment for better readability (level 2)
--   - Concealment in normal and command mode
--   - Filetype-specific automatic initialization
--
-- Configuration:
--   Delimiter: comma (,)
--   Column highlighting: enabled
--   Auto-arrange: enabled
--   Header highlight: Title group
--   Concealment: level 2, modes "nc"
-- ============================================================================

return {
  "chrisbra/csv.vim",
  ft = { "csv" },
  init = function()
    vim.g.csv_delim = ','
    vim.g.csv_highlight_column = 'y'
    vim.g.csv_autocmd_arrange = 1
    vim.g.csv_hiHeader = "Title"
  end,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "csv",
      callback = function()
        vim.cmd("silent! call csv#Init()")
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"
      end,
    })
  end
}
