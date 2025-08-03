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
