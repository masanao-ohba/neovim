return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" }, -- 遅延ロードを有効にする
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "lua", "python", "javascript", "html", "css" },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    }
  end,
}
