local M = {}

function M.get_relative_path_and_line()
  local current_file = vim.fn.expand('%')
  local current_line = vim.fn.line('.')
  local cwd = vim.fn.getcwd()

  -- Get relative path
  local relative_path = vim.fn.fnamemodify(current_file, ':.')

  -- Format: @{{relative path}} L{{line number}}
  local formatted_text = string.format("@%s L%d", relative_path, current_line)

  -- Copy to clipboard
  vim.fn.setreg('+', formatted_text)

  -- Show message
  vim.notify(string.format("Copied: %s", formatted_text), vim.log.levels.INFO)

  return formatted_text
end

return M
