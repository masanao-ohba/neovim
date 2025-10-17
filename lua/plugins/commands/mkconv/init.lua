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
-- ============================================================================

return {
  dir = vim.fn.stdpath("config") .. "/lua/plugins/commands/mkconv",
  name = "Markdown Converter",
  cmd = { "MkConv" },
  dependencies = { "ibhagwan/fzf-lua" },
  config = function()
    local function markdown_to_backlog(text)
      text = text:gsub("```.-\n(.-)\n```", "{code}\n%1\n{/code}")
      text = text:gsub("`(.-)`", "{code}%1{/code}")
      text = text:gsub("%*%*(.-)%*%*", "''%1''")
      text = text:gsub("%[(.-)%]%((.-)%)", "[[%1:%2]]")

      local indent_levels = {}
      local result = {}

      for line in text:gmatch("[^\r\n]+") do
        local hashes, title = line:match("^(#+)%s+(.*)")
        if hashes then
          table.insert(result, string.rep("*", #hashes) .. " " .. title)

        elseif line:match("^%s*%d+%.%s+") then
          local indent, content = line:match("^(%s*)%d+%.%s+(.*)")
          local current_indent = #indent

          local level = 1
          for i, v in ipairs(indent_levels) do
            if v == current_indent then
              level = i
              break
            elseif v > current_indent then
              break
            end
            level = i + 1
          end
          if not vim.tbl_contains(indent_levels, current_indent) then
            table.insert(indent_levels, level, current_indent)
          end

          table.insert(result, string.rep("+", level) .. " " .. content)

        elseif line:match("^%s*%-%s+") then
          local indent, content = line:match("^(%s*)%-%s+(.*)")
          local current_indent = #indent

          local level = 1
          for i, v in ipairs(indent_levels) do
            if v == current_indent then
              level = i
              break
            elseif v > current_indent then
              break
            end
            level = i + 1
          end
          if not vim.tbl_contains(indent_levels, current_indent) then
            table.insert(indent_levels, level, current_indent)
          end

          table.insert(result, string.rep("-", level) .. " " .. content)

        else
          table.insert(result, line)
        end
      end

      return table.concat(result, "\n")
    end

    local function backlog_to_markdown(text)
      text = text:gsub("{code}\n(.-)\n{/code}", "```\n%1\n```")
      text = text:gsub("{code}(.-){/code}", "`%1`")
      text = text:gsub("''(.-)''", "**%1**")
      text = text:gsub("%[%[(.-):(.-)%]%]", "[%1](%2)")

      local result = {}

      for line in text:gmatch("[^\r\n]+") do
        local stars, title = line:match("^(%*+)%s+(.*)")
        if stars then
          table.insert(result, string.rep("#", #stars) .. " " .. title)

        elseif line:match("^%++%s+") then
          local pluses, content = line:match("^(%++)%s+(.*)")
          local level = #pluses
          local indent = string.rep("  ", level - 1)
          table.insert(result, indent .. "1. " .. content)

        elseif line:match("^%-+%s+") then
          local dashes, content = line:match("^(%-+)%s+(.*)")
          local level = #dashes
          local indent = string.rep("  ", level - 1)
          table.insert(result, indent .. "- " .. content)

        else
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
