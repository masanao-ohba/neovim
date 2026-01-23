local M = {}

function M.get_relative_path_and_line()
  local current_file = vim.fn.expand('%')
  local current_line = vim.fn.line('.')

  -- Get relative path
  local relative_path = vim.fn.fnamemodify(current_file, ':.')

  -- Format: @{{relative path}}#L{{line number}}
  local formatted_text = string.format("@%s#L%d", relative_path, current_line)

  -- Copy to clipboard
  vim.fn.setreg('+', formatted_text)

  -- Show message
  vim.notify(string.format("Copied: %s", formatted_text), vim.log.levels.INFO)

  return formatted_text
end

function M.get_relative_path_and_line_range()
  local current_file = vim.fn.expand('%')

  -- Get relative path
  local relative_path = vim.fn.fnamemodify(current_file, ':.')

  -- Get visual selection range
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Format: @{{relative path}}#L{{start}}-L{{end}} or single line if same
  local formatted_text
  if start_line == end_line then
    formatted_text = string.format("@%s#L%d", relative_path, start_line)
  else
    formatted_text = string.format("@%s#L%d-L%d", relative_path, start_line, end_line)
  end

  -- Copy to clipboard
  vim.fn.setreg('+', formatted_text)

  -- Show message
  vim.notify(string.format("Copied: %s", formatted_text), vim.log.levels.INFO)

  return formatted_text
end

return M
