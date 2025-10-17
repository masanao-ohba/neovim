-- ============================================================================
-- Plugin: conform.nvim
-- Repository: stevearc/conform.nvim
-- Category: Code Formatting / File Management
--
-- Purpose:
--   Unified formatting interface with support for multiple formatters.
--   Automatically formats code on save with fallback to LSP formatting.
--
-- Key Features:
--   - Multi-formatter support with priority ordering
--   - Format-on-save capability with configurable timeout
--   - Filetype-specific formatter selection
--   - Stop-after-first-success behavior for web formatters
--   - LSP formatting fallback when no formatter available
--
-- Supported Formatters:
--   Lua:       stylua
--   Go:        goimports
--   Bash:      shfmt
--   Web files: biome, prettierd (tries in order, stops after first success)
--     - TypeScript, JavaScript, React variants
--     - JSON, JSONC, JSONL
--     - YAML, HTML, CSS, SCSS, LESS
--     - Python
--
-- Configuration:
--   format_on_save: enabled
--   timeout: 500ms
-- ============================================================================

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
