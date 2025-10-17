-- ============================================================================
-- Plugin: fzf-lua
-- Repository: ibhagwan/fzf-lua
-- Category: Fuzzy Finder / File Management
--
-- Purpose:
--   Fast fuzzy finder for files, buffers, and text using fzf and ripgrep.
--   Provides comprehensive search capabilities with preview windows.
--
-- Key Features:
--   - File searching with bat preview
--   - Ripgrep integration for text search across project
--   - Buffer and tab navigation
--   - Horizontal preview layout (60% width)
--   - Custom search functions (word-under-cursor search)
--   - Smart-case searching
--   - Customizable actions (tabedit by default)
--
-- Keybindings:
--   <F12> - Search word under cursor with ripgrep
--
-- Configuration:
--   Window size: 85% width x 85% height
--   Preview: bat_native with syntax highlighting
--   Search: ripgrep with column/line numbers
-- ============================================================================

return {
  "ibhagwan/fzf-lua",
  opts = {
    winopts = {
      height = 0.85,
      width = 0.85,
      preview = {
        default = "bat_native",
        layout = "horizontal",
        vertical = "right:60%",
      },
    },
    grep = {
      prompt = "*Rg> ",
      rg_opts = "--column --line-number --no-heading --color=never --smart-case --with-filename",
    },
  },
  -- setup 実行後に追加マッピングや関数を定義します
  config = function(_, opts)
    local fzf_lua = require("fzf-lua")
    fzf_lua.setup(opts)

    function _G.search_with_highlight()
      local query = vim.fn.expand("<cword>")
      if query == "" then
        print("No highlighted text found for search")
        return
      end

      -- カスタム実装: rgコマンドを直接実行してfzfに結果を渡す
      local cmd = string.format('rg "%s" --column --line-number --no-heading --color=always --smart-case --with-filename', query)

      fzf_lua.fzf_exec(cmd, {
        prompt = "*Rg> ",
        actions = {
          ["default"] = fzf_lua.actions.file_tabedit,
        },
        fzf_opts = {
          ['--delimiter'] = ':',
          ['--preview-window'] = 'right:60%,+{2}+3/3,~3',
        },
        preview = "bat --style=numbers --color=always --highlight-line={2} {1}",
      })
    end

    vim.keymap.set("n", "<F12>", _G.search_with_highlight, { noremap = true, silent = true })
    -- FZF files機能を無効化（使用頻度低いため）
    -- vim.keymap.set("n", ",f", function()
    --   fzf_lua.files({
    --     actions = {
    --       ["default"] = function(selected)
    --         if #selected == 0 then
    --           print("No file selected.")
    --           return
    --         end
    --         for _, file in ipairs(selected) do
    --           local cleaned = file:gsub("[^%g%s/]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    --           local full = vim.fn.fnamemodify(cleaned, ":p")
    --           if vim.fn.filereadable(full) == 1 then
    --             vim.cmd("tabedit " .. vim.fn.fnameescape(full))
    --           else
    --             print("Error: File not readable -> " .. full)
    --           end
    --         end
    --       end,
    --     },
    --   })
    -- end, { noremap = true, silent = true })

    vim.o.hidden = true
  end,
}
