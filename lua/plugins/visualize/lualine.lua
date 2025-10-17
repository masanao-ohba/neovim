-- ============================================================================
-- Plugin: lualine.nvim
-- Repository: nvim-lualine/lualine.nvim
-- Category: Status Line / Visual Enhancement
--
-- Purpose:
--   Fast and highly customizable statusline for Neovim.
--   Displays essential file and git information at the bottom of the window.
--
-- Key Features:
--   - Git branch display
--   - File information (name, encoding, format, type)
--   - Diff statistics (additions/deletions)
--   - LSP diagnostics integration (errors, warnings, hints)
--   - Minimal and clean design
--   - Fast performance with lazy updates
--
-- Status Line Sections:
--   lualine_a: filename
--   lualine_b: git branch
--   lualine_c: diff stats, diagnostics
--   lualine_x: file encoding, file format
--   lualine_y: filetype
--   lualine_z: (empty)
-- ============================================================================

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require('lualine')
    local config = {
      sections = {
        lualine_a = {'filename'},
        lualine_b = {'branch'},
        lualine_c = {'diff', 'diagnostics'},
        lualine_x = {'encoding', 'fileformat'},
        lualine_y = {'filetype'},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }
    lualine.setup(config)
  end
}
