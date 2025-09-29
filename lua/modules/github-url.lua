local M = {}

function M.get_github_url()
  local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return nil
  end

  local remote_url = vim.fn.system("git config --get remote.origin.url 2>/dev/null"):gsub("\n", "")
  if remote_url == "" then
    vim.notify("No remote origin found", vim.log.levels.ERROR)
    return nil
  end

  local repo_info
  if remote_url:match("^git@github.com:") then
    repo_info = remote_url:match("^git@github.com:(.+)%.git$") or remote_url:match("^git@github.com:(.+)$")
  elseif remote_url:match("^https://github.com/") then
    repo_info = remote_url:match("^https://github.com/(.+)%.git$") or remote_url:match("^https://github.com/(.+)$")
  elseif remote_url:match("^ssh://git@github.com/") then
    repo_info = remote_url:match("^ssh://git@github.com/(.+)%.git$") or remote_url:match("^ssh://git@github.com/(.+)$")
  else
    vim.notify("Not a GitHub repository", vim.log.levels.ERROR)
    return nil
  end

  if not repo_info then
    vim.notify("Could not parse GitHub repository URL", vim.log.levels.ERROR)
    return nil
  end

  local current_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("\n", "")
  if current_branch == "" then
    current_branch = "main"
  end

  local current_file = vim.fn.expand("%:p")
  local relative_path = current_file:sub(#git_root + 2)

  local current_line = vim.fn.line(".")
  local mode = vim.fn.mode()

  local url
  if mode == "v" or mode == "V" or mode == "\22" then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    url = string.format("https://github.com/%s/blob/%s/%s#L%d-L%d",
      repo_info, current_branch, relative_path, start_line, end_line)
  else
    url = string.format("https://github.com/%s/blob/%s/%s#L%d",
      repo_info, current_branch, relative_path, current_line)
  end

  return url
end

function M.copy_github_url()
  local url = M.get_github_url()
  if url then
    vim.fn.setreg("+", url)
    vim.notify("GitHub URL copied: " .. url, vim.log.levels.INFO)
  end
end

return M
