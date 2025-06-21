return {
  "stevearc/conform.nvim",
  config = function()
    local web_formatter = { "biome", "prettierd", stop_after_first = true }
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports" },
        bash = { "shfmt" },
        -- Web
        typescript      = web_formatter,
        javascript      = web_formatter,
        typescriptreact = web_formatter,
        javascriptreact = web_formatter,
        json            = web_formatter,
        jsonc           = web_formatter,
        jsonl           = web_formatter,
        yaml            = web_formatter,
        html            = web_formatter,
        css             = web_formatter,
        scss            = web_formatter,
        less            = web_formatter,
        python          = web_formatter,
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}
