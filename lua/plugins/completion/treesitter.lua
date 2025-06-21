return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" }, -- 遅延ロードを有効にする
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "lua", "python", "php", "javascript", "html", "css" },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    }

    -- 折りたたみ設定を追加
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lua", "python", "php", "javascript", "html", "css", "scss" },
      callback = function()
        if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
          vim.o.foldmethod = "expr"
          vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        else
          vim.o.foldmethod = "syntax"
        end
      end,
    })
  end,
}
