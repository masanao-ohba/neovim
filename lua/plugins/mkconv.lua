return {
  "ibhagwan/fzf-lua",
  cmd = { "MkConv" },
  config = function()
    local function markdown_to_backlog(text)
      -- コードブロック
      text = text:gsub("```.-\n(.-)\n```", "{code}\n%1\n{/code}")
      -- インラインコード
      text = text:gsub("`(.-)`", "{code}%1{/code}")
      -- 強調
      text = text:gsub("%*%*(.-)%*%*", "''%1''")
      -- リンク
      text = text:gsub("%[(.-)%]%((.-)%)", "[[%1:%2]]")

      -- 行処理（見出し・リスト）
      local indent_levels = {}
      local result = {}

      for line in text:gmatch("[^\r\n]+") do
        -- 見出し (# -> *)
        local hashes, title = line:match("^(#+)%s+(.*)")
        if hashes then
          table.insert(result, string.rep("*", #hashes) .. " " .. title)

        -- 番号付きリスト（スペース可変 -> + 段階）
        elseif line:match("^%s*%d+%.%s+") then
          local indent, content = line:match("^(%s*)%d+%.%s+(.*)")
          local current_indent = #indent

          -- ネストレベル推定
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

        else
          table.insert(result, line)
        end
      end

      return table.concat(result, "\n")
    end

    local function backlog_to_markdown(text)
      -- コードブロック
      text = text:gsub("{code}\n(.-)\n{/code}", "```\n%1\n```")
      -- インラインコード
      text = text:gsub("{code}(.-){/code}", "`%1`")
      -- 強調
      text = text:gsub("''(.-)''", "**%1**")
      -- リンク
      text = text:gsub("%[%[(.-):(.-)%]%]", "[%1](%2)")

      local result = {}

      for line in text:gmatch("[^\r\n]+") do
        -- 見出し (* -> #)
        local stars, title = line:match("^(%*+)%s+(.*)")
        if stars then
          table.insert(result, string.rep("#", #stars) .. " " .. title)

        -- リスト (+ -> 1.)
        elseif line:match("^%++%s+") then
          local pluses, content = line:match("^(%++)%s+(.*)")
          local level = #pluses
          local indent = string.rep("  ", level - 1)  -- 2スペースずつ
          table.insert(result, indent .. "1. " .. content)

        else
          table.insert(result, line)
        end
      end

      return table.concat(result, "\n")
    end

    vim.api.nvim_create_user_command("MkConv", function()
      require("fzf-lua").fzf_exec({ "MarkDown -> Backlog", "Backlog -> MarkDown" }, {
        prompt = "記法の変換: ",
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
