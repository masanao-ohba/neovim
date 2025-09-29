local M = {}

-- コードブロック挿入（fzf-luaで言語選択＆直接入力可）
function M.insert_code_block()
  local languages = {
    "python", "javascript", "typescript", "bash", "shell",
    "sh", "go", "ruby", "php", "java", "c", "cpp", "json", "yaml", "toml", "markdown"
  }

  -- fzf-lua必須、なければエラー
  local ok, fzf = pcall(require, 'fzf-lua')
  if not ok then
    vim.notify("fzf-luaが見つかりません", vim.log.levels.ERROR)
    return
  end

  fzf.fzf_exec(languages, {
    prompt = "言語を選択 or 直接入力: ",
    actions = {
      ["default"] = function(selected, opts)
        local lang = selected[1]
        -- 選択肢以外の自由入力にも対応
        if not vim.tbl_contains(languages, lang) then
          lang = opts._fzf_query or ""
        end
        -- 現在行の直後に挿入
        local row = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, row, row, false, {
          "```" .. lang,
          "",
          "```"
        })
        -- カーソルを空行に移動
        vim.api.nvim_win_set_cursor(0, {row + 1, 0})
      end
    }
  })
end

-- Visual選択範囲をバッククォートで括る
function M.wrap_selection_with_backtick()
  -- Visual選択の開始・終了位置を取得（現在の選択範囲）
  local start_row = vim.fn.line("v") - 1    -- 0-indexed
  local start_col = vim.fn.col("v") - 1     -- 0-indexed
  local end_row = vim.fn.line(".") - 1      -- 0-indexed
  local end_col = vim.fn.col(".")           -- 1-indexed維持

  -- 開始と終了を正しい順序に調整
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col - 1, start_col + 1
  end

  -- 選択されたテキストを取得
  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

  if #lines == 0 then
    return
  end

  -- 単一行の場合
  if #lines == 1 then
    local line = lines[1]
    local selected_text = line:sub(start_col + 1, end_col)
    local new_text = "`" .. selected_text .. "`"
    local new_line = line:sub(1, start_col) .. new_text .. line:sub(end_col + 1)
    vim.api.nvim_buf_set_lines(0, start_row, start_row + 1, false, {new_line})
  else
    -- 複数行の場合
    local first_line = lines[1]:sub(start_col + 1)
    local last_line = lines[#lines]:sub(1, end_col)
    local middle_lines = {}

    for i = 2, #lines - 1 do
      table.insert(middle_lines, lines[i])
    end

    -- 最初の行にバッククォートを追加
    local new_first_line = lines[1]:sub(1, start_col) .. "`" .. first_line

    -- 最後の行にバッククォートを追加
    local new_last_line = last_line .. "`" .. lines[#lines]:sub(end_col + 1)

    -- 新しい行配列を作成
    local new_lines = {new_first_line}
    for _, line in ipairs(middle_lines) do
      table.insert(new_lines, line)
    end
    table.insert(new_lines, new_last_line)

    vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, new_lines)
  end
end

-- カーソル下の単語をバッククォートで括る
function M.wrap_word_under_cursor()
  -- 現在のカーソル位置を保存
  local current_pos = vim.api.nvim_win_get_cursor(0)

  -- expand('<cword>') を使って現在のカーソル位置の単語を取得
  local word = vim.fn.expand('<cword>')

  if word == "" then
    return
  end

  -- 現在行を取得
  local row = current_pos[1] - 1  -- 0-indexed
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

  if not line then
    return
  end

  -- 現在のカーソル位置から単語の開始位置を見つける
  local col = current_pos[2]  -- 0-indexed

  -- 単語の開始位置を見つける（カーソル位置から後方検索）
  local word_start = col
  while word_start > 0 do
    local char = line:sub(word_start, word_start)
    if not char:match('[%w_]') then
      break
    end
    word_start = word_start - 1
  end

  -- 単語の境界調整
  if word_start > 0 or not line:sub(1, 1):match('[%w_]') then
    word_start = word_start + 1
  end

  -- 単語の終了位置を見つける（開始位置から前方検索）
  local word_end = word_start
  while word_end <= #line do
    local char = line:sub(word_end, word_end)
    if not char:match('[%w_]') then
      word_end = word_end - 1
      break
    end
    word_end = word_end + 1
  end

  if word_end > #line then
    word_end = #line
  end

  -- 見つかった単語が期待する単語と一致するかチェック
  local found_word = line:sub(word_start, word_end)
  if found_word ~= word then
    return
  end

  -- 新しい行を作成（単語をバッククォートで括る）
  local new_line = line:sub(1, word_start - 1) .. "`" .. word .. "`" .. line:sub(word_end + 1)

  -- 行を更新
  vim.api.nvim_buf_set_lines(0, row, row + 1, false, {new_line})

  -- カーソル位置を調整（単語内の相対位置を維持）
  local offset_in_word = col - (word_start - 1)
  local new_col = word_start - 1 + 1 + offset_in_word  -- バッククォート分(+1)を追加
  vim.api.nvim_win_set_cursor(0, {row + 1, new_col})
end

return M
