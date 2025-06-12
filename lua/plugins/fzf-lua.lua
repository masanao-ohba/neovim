return {
  "ibhagwan/fzf-lua",
  opts = {
    winopts = {
      height = 0.85,
      width = 0.85,
      preview = {
        default = "bat",
        theme = "moonlight",
        layout = "horizontal",
        vertical = "right:60%",
      },
    },
    grep = {
      prompt = "*Rg> ",
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --with-filename",
      actions = {
        ["default"] = function(selected)
          for _, item in ipairs(selected) do
            local item = item:gsub("[^%g%s/]", ""):gsub("^%s+", ""):gsub("%s+$", "")
            item = vim.trim(item)
            local file, line_num = item:match("^([^:]+):(%d+):%d+:")
            if not file then
              file, line_num = item:match("^([^:]+):(%d+):")
            end
            if file and line_num then
              vim.cmd("tabedit " .. vim.fn.fnameescape(file))
              vim.cmd("e")
              vim.cmd(line_num)
            else
              print("Error: Could not parse grep result -> " .. item)
            end
          end
        end,
      },
    },
  },
  -- setup 実行後に追加マッピングや関数を定義します
  config = function(_, opts)
    local fzf_lua = require("fzf-lua")
    fzf_lua.setup(opts)

    function _G.search_with_highlight()
      local query = vim.fn.expand("<cword>")
      if query == "" then
        print("No highlighted text found for search")
        return
      end
      fzf_lua.grep({ search = query, prompt = "*Rg> " })
    end

    vim.keymap.set("n", "<F12>", _G.search_with_highlight, { noremap = true, silent = true })
    vim.keymap.set("n", ",f", function()
      fzf_lua.files({
        actions = {
          ["default"] = function(selected)
            if #selected == 0 then
              print("No file selected.")
              return
            end
            for _, file in ipairs(selected) do
              local cleaned = file:gsub("[^%g%s/]", ""):gsub("^%s+", ""):gsub("%s+$", "")
              local full = vim.fn.fnamemodify(cleaned, ":p")
              if vim.fn.filereadable(full) == 1 then
                vim.cmd("tabedit " .. vim.fn.fnameescape(full))
              else
                print("Error: File not readable -> " .. full)
              end
            end
          end,
        },
      })
    end, { noremap = true, silent = true })

    vim.o.hidden = true
  end,
}
