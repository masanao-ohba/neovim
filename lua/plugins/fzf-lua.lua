local fzf_lua = require('fzf-lua')

-- fzf-luaの設定
fzf_lua.setup({
  winopts = {
    height = 0.85,
    width = 0.85,
    preview = {
      default = 'bat', -- プレビューツール
      theme = 'moonlight', -- テーマ
      layout = 'horizontal', -- プレビューのレイアウト
      vertical = 'right:60%', -- プレビューの高さ
    },
  },
  grep = {
    -- prompt = "*Rg> ", -- プロンプトを固定表示
    -- rg_opts = "--line-number --no-heading --color=always --smart-case --with-filename", -- 列番号を非表示
    prompt = "*Rg> ",
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --with-filename",

    actions = {
      ["default"] = function(selected)
        for _, item in ipairs(selected) do
          -- 不可視文字・特殊文字を削除
          local item = item:gsub("[^%g%s/]", "") -- 非表示文字を除去
                                          :gsub("^%s+", "")       -- 先頭の空白を削除
                                          :gsub("%s+$", "")       -- 末尾の空白を削除
          print("Selected Item:", vim.inspect(item))
          item = vim.trim(item)

          -- 正規表現で "ファイル名:行番号:列番号:検索結果" のフォーマットを処理
          local file, line_num, _ = item:match("^([^:]+):(%d+):%d+:.*$")

          -- 行番号が取得できなかった場合のフォールバック
          if not file or not line_num then
            file, line_num = item:match("^([^:]+):(%d+):.*$")
          end

          if file and line_num then
            local full_path = vim.fn.fnamemodify(file, ":p")
            print("Full Path:", full_path)
            -- ファイルをタブで開く
            vim.cmd('tabedit ' .. vim.fn.fnameescape(file))
            vim.cmd('e') -- 明示的に再読み込み
            vim.cmd(line_num)
          else
            print("Error: Could not parse grep result -> " .. item)
          end
        end
      end,
    },
    -- actions = {
    --   ["default"] = function(selected)
    --     for _, item in ipairs(selected) do
    --       local parts = vim.split(item, ':', { plain = true })
    --       if #parts >= 2 then
    --         local file = parts[1]
    --         local line_num = parts[2]
    --         -- 結果を別タブで開く
    --         vim.cmd('tabedit ' .. vim.fn.fnameescape(file))
    --         vim.cmd('e')
    --         vim.cmd(line_num)
    --         print(vim.inspect(selected))
    --       end
    --     end
    --   end,
    -- },
  },
})

-- ハイライト文字列で検索を実行
function _G.search_with_highlight()
  local query = vim.fn.expand('<cword>') -- 現在のハイライト文字列を取得
  if query == "" then
    print("No highlighted text found for search")
    return
  end

  -- 検索クエリをfzf-luaに渡す
  fzf_lua.grep({
    search = query, -- 初期絞り込みクエリ
    prompt = "*Rg> ", -- プロンプトを固定表示
  })
end

vim.keymap.set('n', '<F12>', search_with_highlight, { noremap = true, silent = true })

vim.keymap.set('n', ',f', function()
  fzf_lua.files({
    actions = {
      ['default'] = function(selected)
        if #selected == 0 then
          print("No file selected.")
          return
        end

        for _, file in ipairs(selected) do
          -- 不可視文字や特殊文字を削除
          local cleaned_file = file:gsub("[^%g%s/]", ""):gsub("^%s+", ""):gsub("%s+$", "")

          -- フルパスを取得
          local full_path = vim.fn.fnamemodify(cleaned_file, ":p")

          -- ファイルを開く
          if vim.fn.filereadable(full_path) == 1 then
            vim.cmd('tabedit ' .. vim.fn.fnameescape(full_path))
          else
            print("Error: File does not exist or is not readable:", full_path)
          end
        end
      end,
    },
  })
end, { noremap = true, silent = true })

vim.o.hidden = true

