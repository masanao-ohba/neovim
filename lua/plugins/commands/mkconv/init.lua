-- ============================================================================
-- Plugin: Markdown Converter
-- Category: Custom Command / Text Processing
--
-- Purpose:
--   Bidirectional converter between Markdown and Backlog wiki syntax.
--   Enables easy content migration between different documentation systems.
--
-- Key Features:
--   - Markdown → Backlog conversion (headers, lists, code blocks, links)
--   - Backlog → Markdown conversion
--   - Preserves code blocks and inline code formatting
--   - Handles nested lists with proper indentation
--   - Interactive conversion selector with fzf-lua
--   - In-place buffer content replacement
--
-- Commands:
--   :MkConv - Launch conversion mode selector
--
-- Supported Conversions:
--   Headers:      # → * (and vice versa)
--   Ordered List: 1. → + (and vice versa)
--   Bullet List:  - → - (preserves but adjusts nesting)
--   Code Blocks:  ``` → {code} (and vice versa)
--   Links:        [text](url) → [[text:url]] (and vice versa)
--   Bold:         **text** → ''text'' (and vice versa)
--   Strikethrough: ~~text~~ → %%text%% (and vice versa)
--   Table:        | h |\n| - | → | h |h (header row uses trailing "h";
--                 the Markdown separator row is dropped / regenerated)
-- ============================================================================

return {
  dir = vim.fn.stdpath("config") .. "/lua/plugins/commands/mkconv",
  name = "Markdown Converter",
  cmd = { "MkConv" },
  dependencies = { "ibhagwan/fzf-lua" },
  config = function()
    -- A table row is any line wrapped in pipes, e.g. "| a | b |".
    local function is_table_row(line)
      return line:match("^%s*|.*|%s*$") ~= nil
    end

    -- A Markdown separator row contains only pipes, spaces, colons and dashes
    -- and has at least one dash, e.g. "| --- |" or "|:---:|".
    local function is_table_separator(line)
      return line:match("^%s*|[%s:%-|]*$") ~= nil and line:match("%-") ~= nil
    end

    local function markdown_to_backlog(text)
      text = text:gsub("```.-\n(.-)\n```", "{code}\n%1\n{/code}")
      text = text:gsub("`(.-)`", "{code}%1{/code}")
      text = text:gsub("%*%*(.-)%*%*", "''%1''")
      text = text:gsub("~~(.-)~~", "%%%%%1%%%%")
      text = text:gsub("%[(.-)%]%((.-)%)", "[[%1:%2]]")

      local indent_levels = {}
      local result = {}

      local lines = {}
      for line in text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
      end

      local i = 1
      while i <= #lines do
        local line = lines[i]
        local hashes, title = line:match("^(#+)%s+(.*)")

        -- Markdown header row (followed by a separator) → Backlog header row
        -- ("| A | B |h"); drop the separator row entirely.
        if is_table_row(line) and lines[i + 1] and is_table_separator(lines[i + 1]) then
          table.insert(result, (line:gsub("%s*$", "")) .. "h")
          i = i + 2

        elseif hashes then
          table.insert(result, string.rep("*", #hashes) .. " " .. title)
          i = i + 1

        elseif line:match("^%s*%d+%.%s+") then
          local indent, content = line:match("^(%s*)%d+%.%s+(.*)")
          local current_indent = #indent

          local level = 1
          for j, v in ipairs(indent_levels) do
            if v == current_indent then
              level = j
              break
            elseif v > current_indent then
              break
            end
            level = j + 1
          end
          if not vim.tbl_contains(indent_levels, current_indent) then
            table.insert(indent_levels, level, current_indent)
          end

          table.insert(result, string.rep("+", level) .. " " .. content)
          i = i + 1

        elseif line:match("^%s*%-%s+") then
          local indent, content = line:match("^(%s*)%-%s+(.*)")
          local current_indent = #indent

          local level = 1
          for j, v in ipairs(indent_levels) do
            if v == current_indent then
              level = j
              break
            elseif v > current_indent then
              break
            end
            level = j + 1
          end
          if not vim.tbl_contains(indent_levels, current_indent) then
            table.insert(indent_levels, level, current_indent)
          end

          table.insert(result, string.rep("-", level) .. " " .. content)
          i = i + 1

        else
          table.insert(result, line)
          i = i + 1
        end
      end

      return table.concat(result, "\n")
    end

    local function backlog_to_markdown(text)
      text = text:gsub("{code}\n(.-)\n{/code}", "```\n%1\n```")
      text = text:gsub("{code}(.-){/code}", "`%1`")
      text = text:gsub("''(.-)''", "**%1**")
      text = text:gsub("%%%%(.-)%%%%", "~~%1~~")
      text = text:gsub("%[%[(.-):(.-)%]%]", "[%1](%2)")

      local result = {}
      -- Emit a Markdown separator row ("| --- | --- |") matching a table row's
      -- column count (number of pipes minus one).
      local function insert_separator(row)
        local cols = select(2, row:gsub("|", "")) - 1
        table.insert(result, "|" .. string.rep(" --- |", cols))
      end

      local in_table = false

      for line in text:gmatch("[^\r\n]+") do
        local stars, title = line:match("^(%*+)%s+(.*)")

        -- Backlog header row ("| A | B |h") → Markdown header + separator row.
        if line:match("^%s*|.*|h%s*$") then
          local header = line:gsub("|h(%s*)$", "|%1")
          table.insert(result, header)
          insert_separator(header)
          in_table = true

        elseif is_table_row(line) then
          -- A header-less Backlog table: promote its first row to a Markdown
          -- header by inserting a separator right after it.
          table.insert(result, line)
          if not in_table then
            insert_separator(line)
            in_table = true
          end

        elseif stars then
          in_table = false
          table.insert(result, string.rep("#", #stars) .. " " .. title)

        elseif line:match("^%++%s+") then
          in_table = false
          local pluses, content = line:match("^(%++)%s+(.*)")
          local level = #pluses
          local indent = string.rep("  ", level - 1)
          table.insert(result, indent .. "1. " .. content)

        elseif line:match("^%-+%s+") then
          in_table = false
          local dashes, content = line:match("^(%-+)%s+(.*)")
          local level = #dashes
          local indent = string.rep("  ", level - 1)
          table.insert(result, indent .. "- " .. content)

        else
          in_table = false
          table.insert(result, line)
        end
      end

      return table.concat(result, "\n")
    end

    vim.api.nvim_create_user_command("MkConv", function()
      require("fzf-lua").fzf_exec({ "MarkDown -> Backlog", "Backlog -> MarkDown" }, {
        prompt = "記法の切り替え: ",
        actions = {
          ["default"] = function(selected)
            local buf = vim.api.nvim_get_current_buf()
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local text = table.concat(lines, "\n")
            local result = text
            if selected[1] == "MarkDown -> Backlog" then
              result = markdown_to_backlog(text)
            elseif selected[1] == "Backlog -> MarkDown" then
              result = backlog_to_markdown(text)
            end
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
          end,
        },
      })
    end, {})
  end,
}
