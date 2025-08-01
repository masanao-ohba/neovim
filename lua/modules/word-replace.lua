-- ファイル: lua/plugins/custom/word-replace.lua

local M = {}

function M.replace_with_input()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    print("No word under cursor.")
    return
  end

  local new = vim.fn.input("Replace '" .. word .. "' with: ")
  if new == "" or new == word then
    print("No replacement made.")
    return
  end

  local handle = io.popen("rg -l '\\b" .. word .. "\\b'")
  if not handle then
    print("Failed to run rg.")
    return
  end
  local result = handle:read("*a")
  handle:close()

  if result == "" then
    print("No matches found.")
    return
  end

  local files = {}
  for file in result:gmatch("[^\r\n]+") do
    table.insert(files, vim.fn.fnameescape(file))
  end
  vim.cmd("args " .. table.concat(files, " "))
  vim.cmd(string.format("argdo %%s/\\<%s\\>/%s/gc | update", word, new))
end

return M
