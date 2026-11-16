-- ============================================================================
-- Plugin: fzf-lua
-- Repository: ibhagwan/fzf-lua
-- Category: Fuzzy Finder / File Management
--
-- Purpose:
--   Fast fuzzy finder for files, buffers, and text using fzf and ripgrep.
--   Provides comprehensive search capabilities with preview windows.
--
-- Key Features:
--   - File searching with bat preview
--   - Ripgrep integration for text search across project
--   - Buffer and tab navigation
--   - Horizontal preview layout (60% width)
--   - Custom search functions (word-under-cursor search)
--   - Smart-case searching
--   - Customizable actions (tabedit by default)
--
-- Keybindings:
--   <F12> - Search word under cursor with ripgrep
--           (in diffview: sorted as + changed line / ~ changed file / others)
--
-- Configuration:
--   Window size: 85% width x 85% height
--   Preview: bat_native with syntax highlighting
--   Search: ripgrep with column/line numbers
-- ============================================================================

return {
  "ibhagwan/fzf-lua",
  opts = {
    winopts = {
      height = 0.85,
      width = 0.85,
      preview = {
        default = "bat_native",
        layout = "horizontal",
        vertical = "right:60%",
      },
    },
    grep = {
      prompt = "*Rg> ",
      rg_opts = "--column --line-number --no-heading --color=never --smart-case --with-filename",
    },
  },
  -- Define extra mappings and functions after setup
  config = function(_, opts)
    local fzf_lua = require("fzf-lua")
    fzf_lua.setup(opts)

    -- Return lines changed in the diffview range as { [path] = { [lnum] = true } } (paths relative to cwd)
    local function changed_lines(rev_arg)
      local cmd = { "git", "diff", "-U0", "-w", "--relative", "--no-color", "--no-ext-diff" }
      if rev_arg and rev_arg ~= "" then
        vim.list_extend(cmd, vim.split(rev_arg, "%s+", { trimempty = true }))
      end
      local result, current = {}, nil
      for _, line in ipairs(vim.fn.systemlist(cmd)) do
        local path = line:match("^%+%+%+ b/(.+)$")
        if path then
          current = path
          result[current] = result[current] or {}
        elseif current then
          local start, count = line:match("^@@ %-%S+ %+(%d+),?(%d*) @@")
          if start then
            start, count = tonumber(start), count == "" and 1 or tonumber(count)
            for lnum = start, start + count - 1 do result[current][lnum] = true end
          end
        end
      end
      return result
    end

    -- While diffview is open, order as "changed lines -> other lines in changed files -> outside diff", distinguished by mark and color
    local function rg_search_ranked(escaped, view)
      local changed = changed_lines(view.rev_arg)
      local marks = {
        { mark = "+", color = "\27[1;32m" }, -- changed line (green, bold)
        { mark = "~", color = "" }, -- other line in a changed file (normal color)
        { mark = " ", color = "\27[90m" }, -- outside diff (gray)
      }
      local buckets = { {}, {}, {} }
      local rg = "rg " .. escaped .. " --column --line-number --no-heading --color=never --smart-case --with-filename"
      for _, line in ipairs(vim.fn.systemlist(rg)) do
        local file, lnum = line:match("^(.-):(%d+):%d+:")
        if file then
          local file_changes = changed[file:gsub("^%./", "")]
          local rank = (file_changes and file_changes[tonumber(lnum)]) and 1 or (file_changes and 2 or 3)
          local m = marks[rank]
          table.insert(buckets[rank], m.color .. m.mark .. "\27[0m:" .. m.color .. file .. "\27[0m" .. line:sub(#file + 1))
        end
      end
      local entries = vim.list_extend(vim.list_extend(buckets[1], buckets[2]), buckets[3])
      fzf_lua.fzf_exec(entries, {
        prompt = "*Rg(diff: " .. (view.rev_arg or "working tree") .. ")> ",
        fzf_opts = { ["--ansi"] = true, ["--no-sort"] = true,
          ["--header"] = "\27[1;32m+ 変更行\27[0m   ~ 変更ファイル内の既存行   \27[90m差分外\27[0m", ["--delimiter"] = ":", ["--preview-window"] = "right:60%,+{3}+3/3,~3" },
        preview = "bat --style=numbers --color=always --highlight-line={3} {2}",
        actions = {
          ["default"] = function(selected)
            local entry = selected[1] and require("fzf-lua.utils").strip_ansi_coloring(selected[1])
            local file, lnum, col = entry and entry:match("^.:(.-):(%d+):(%d+):")
            if not file then return end
            vim.cmd("tabedit " .. vim.fn.fnameescape(file))
            vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
          end,
        },
      })
    end

    local function rg_search(query)
      if query == "" then return end
      local escaped = vim.fn.shellescape(vim.fn.escape(query, "\\[]{}()^$.*+?|"))
      local ok, diffview_lib = pcall(require, "diffview.lib")
      local view = ok and diffview_lib.get_current_view()
      if view and view:instanceof(require("diffview.scene.views.diff.diff_view").DiffView) then
        return rg_search_ranked(escaped, view)
      end
      fzf_lua.fzf_exec("rg " .. escaped .. " --column --line-number --no-heading --color=always --smart-case --with-filename", {
        prompt = "*Rg> ",
        actions = { ["default"] = fzf_lua.actions.file_tabedit },
        fzf_opts = { ["--delimiter"] = ":", ["--preview-window"] = "right:60%,+{2}+3/3,~3" },
        preview = "bat --style=numbers --color=always --highlight-line={2} {1}",
      })
    end

    vim.keymap.set("n", "<F12>", function() 
      local save_isk = vim.bo.iskeyword
      vim.bo.iskeyword = save_isk .. ",-"
      rg_search(vim.fn.expand("<cword>")) 
      vim.bo.iskeyword = save_isk
    end, { silent = true })
    vim.keymap.set("v", "<F12>", function()
      local query = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() }), "\n")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
      rg_search(query)
    end, { silent = true })
    -- Disable FZF files (rarely used)
    -- vim.keymap.set("n", ",f", function()
    --   fzf_lua.files({
    --     actions = {
    --       ["default"] = function(selected)
    --         if #selected == 0 then
    --           print("No file selected.")
    --           return
    --         end
    --         for _, file in ipairs(selected) do
    --           local cleaned = file:gsub("[^%g%s/]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    --           local full = vim.fn.fnamemodify(cleaned, ":p")
    --           if vim.fn.filereadable(full) == 1 then
    --             vim.cmd("tabedit " .. vim.fn.fnameescape(full))
    --           else
    --             print("Error: File not readable -> " .. full)
    --           end
    --         end
    --       end,
    --     },
    --   })
    -- end, { noremap = true, silent = true })

    vim.o.hidden = true
  end,
}
