-- ============================================================================
-- Plugin: nvim-treesitter
-- Repository: nvim-treesitter/nvim-treesitter
-- Category: Syntax & Parsing
--
-- Purpose:
--   Advanced syntax highlighting and code understanding using Tree-sitter
--   parsers. Provides precise syntax awareness for better highlighting,
--   folding, and code manipulation.
--
-- Key Features:
--   - Accurate syntax-aware highlighting (better than regex-based)
--   - Tree-sitter based code folding
--   - Smart indentation based on syntax tree
--   - Incremental parsing for performance
--   - Multiple language support (Lua, Python, PHP, JavaScript, HTML, CSS)
--   - Lazy loading on buffer read for optimal startup time
--   - Fallback to indent folding when parser unavailable
--
-- Supported Languages:
--   lua, python, php, javascript, html, css
--
-- Folding:
--   Uses foldmethod=expr with Tree-sitter foldexpr
--   Default foldlevel=99 (all folds open by default)
-- ============================================================================

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" }, -- 遅延ロードを有効にする
  init = function()
    -- 遅延ロード前に折りたたみ設定を追加
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lua", "python", "php", "javascript", "html", "css", "scss" },
      callback = function()
        vim.defer_fn(function()
          local bufnr = vim.api.nvim_get_current_buf()
          local filetype = vim.bo[bufnr].filetype

          -- Treesitter folding setup
          local ok, parser = pcall(vim.treesitter.get_parser, bufnr, filetype)
          if ok and parser then
            vim.cmd("setlocal foldmethod=expr")
            vim.cmd("setlocal foldexpr=nvim_treesitter#foldexpr()")
            vim.cmd("setlocal foldenable")
            vim.cmd("setlocal foldlevel=99")
          else
            -- Fallback to indent folding
            vim.cmd("setlocal foldmethod=indent")
            vim.cmd("setlocal foldenable")
            vim.cmd("setlocal foldlevel=99")
          end
        end, 500)
      end,
    })
  end,
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "lua", "python", "php", "javascript", "html", "css" },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      fold = {
        enable = true
      },
    }

  end,
}
