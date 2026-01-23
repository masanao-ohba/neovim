local M = {}

-- Insert code block (language selection via fzf-lua with direct input support)
function M.insert_code_block()
  local languages = {
    "python", "javascript", "typescript", "bash", "shell",
    "sh", "go", "ruby", "php", "java", "c", "cpp", "json", "yaml", "toml", "markdown"
  }

  -- Require fzf-lua, error if not found
  local ok, fzf = pcall(require, 'fzf-lua')
  if not ok then
    vim.notify("fzf-lua not found", vim.log.levels.ERROR)
    return
  end

  fzf.fzf_exec(languages, {
    prompt = "Select language or type directly: ",
    actions = {
      ["default"] = function(selected, opts)
        local lang = selected[1]
        -- Support free input beyond predefined options
        if not vim.tbl_contains(languages, lang) then
          lang = opts._fzf_query or ""
        end
        -- Insert after current line
        local row = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, row, row, false, {
          "```" .. lang,
          "",
          "```"
        })
        -- Move cursor to empty line
        vim.api.nvim_win_set_cursor(0, {row + 1, 0})
      end
    }
  })
end

-- Wrap visual selection with backticks
function M.wrap_selection_with_backtick()
  -- Get start/end positions of visual selection (byte positions)
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  local start_row = start_pos[2] - 1  -- 0-indexed
  local start_col = start_pos[3] - 1  -- 0-indexed, byte position
  local end_row = end_pos[2] - 1      -- 0-indexed
  local end_col = end_pos[3] - 1      -- 0-indexed, byte position

  -- Adjust start and end to correct order
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  -- Multi-line selection: wrap with code block (```)
  if start_row ~= end_row then
    -- Get entire lines (regardless of cursor position within line)
    local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

    -- Wrap with code block
    local new_lines = { "```" }
    for _, line in ipairs(lines) do
      table.insert(new_lines, line)
    end
    table.insert(new_lines, "```")

    -- Replace entire lines
    vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, new_lines)
    return
  end

  -- Single line: wrap with backticks
  -- Adjust end_col to next byte position after selection end
  local end_line = vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, false)[1]
  if end_line then
    local char_idx = vim.fn.charidx(end_line, end_col)
    end_col = vim.fn.byteidx(end_line, char_idx + 1)
    if end_col == -1 then
      end_col = #end_line
    end
  end

  -- Get selected text
  local text = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})

  if #text == 0 then
    return
  end

  local new_text = "`" .. text[1] .. "`"
  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, {new_text})
end

-- Wrap word under cursor with backticks
function M.wrap_word_under_cursor()
  -- Save current cursor position
  local current_pos = vim.api.nvim_win_get_cursor(0)

  -- Get word at cursor using expand('<cword>')
  local word = vim.fn.expand('<cword>')

  if word == "" then
    return
  end

  -- Get current line
  local row = current_pos[1] - 1  -- 0-indexed
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

  if not line then
    return
  end

  -- Find word start position from cursor
  local col = current_pos[2]  -- 0-indexed

  -- Find word start (backward search from cursor)
  local word_start = col
  while word_start > 0 do
    local char = line:sub(word_start, word_start)
    if not char:match('[%w_]') then
      break
    end
    word_start = word_start - 1
  end

  -- Adjust word boundary
  if word_start > 0 or not line:sub(1, 1):match('[%w_]') then
    word_start = word_start + 1
  end

  -- Find word end (forward search from start)
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

  -- Verify found word matches expected word
  local found_word = line:sub(word_start, word_end)
  if found_word ~= word then
    return
  end

  -- Create new line with word wrapped in backticks
  local new_line = line:sub(1, word_start - 1) .. "`" .. word .. "`" .. line:sub(word_end + 1)

  -- Update line
  vim.api.nvim_buf_set_lines(0, row, row + 1, false, {new_line})

  -- Adjust cursor position (maintain relative position within word)
  local offset_in_word = col - (word_start - 1)
  local new_col = word_start - 1 + 1 + offset_in_word  -- Add +1 for backtick
  vim.api.nvim_win_set_cursor(0, {row + 1, new_col})
end

return M
