-- ============================================================================
-- Plugin: nvim-treesitter (main branch)
-- Repository: nvim-treesitter/nvim-treesitter
-- Category: Syntax & Parsing
--
-- Purpose:
--   Tree-sitter parsers for syntax-aware highlighting, folding, indentation.
--
-- Supported Languages:
--   lua, python, php, javascript, html, css, markdown, markdown_inline
-- ============================================================================

local langs = {
  "lua",
  "python",
  "php",
  "javascript",
  "html",
  "css",
  "markdown",
  "markdown_inline",
}

local hl_filetypes = {
  "lua",
  "python",
  "php",
  "javascript",
  "html",
  "css",
  "scss",
  "markdown",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()
    require("nvim-treesitter").install(langs)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = hl_filetypes,
      callback = function()
        pcall(vim.treesitter.start)

        if pcall(vim.treesitter.get_parser, 0) then
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        else
          vim.wo[0][0].foldmethod = "indent"
        end
        vim.wo[0][0].foldlevel = 99

        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
