-- ============================================================================
-- Plugin: GitHub Copilot Account Switch
-- Category: Custom Command / Utility
--
-- Purpose:
--   Switch between multiple GitHub Copilot accounts by managing
--   configuration files in ~/.config/github-copilot/ directory.
--
-- Key Features:
--   - Fuzzy search interface for account selection (fzf-lua)
--   - Automatic configuration file switching (apps.*.json → apps.json)
--   - Visual feedback for successful account switching
--   - Supports multiple account configurations
--
-- Commands:
--   :CopilotAccount - Launch account switcher
--
-- Configuration:
--   Place account-specific configs as:
--   ~/.config/github-copilot/apps.{account-name}.json
-- ============================================================================

return {
  dir = vim.fn.stdpath("config") .. "/lua/plugins/commands/copilot-account",
  name = "GitHub Copilot Account Switch",
  -- 実行コマンド名
  cmd = { "CopilotAccount" },
  dependencies = { "ibhagwan/fzf-lua" },
  config = function()
    print("CopilotAccount plugin loaded")
    vim.api.nvim_create_user_command("CopilotAccount", function()
      local fzf = require("fzf-lua")
      local config_path = vim.fn.expand("~/.config/github-copilot/")
      local pattern = config_path .. "apps.*.json"

      local files = vim.fn.glob(pattern, true, true)
      local choices = {}
      for _, path in ipairs(files) do
        local filename = vim.fn.fnamemodify(path, ":t")
        local account = filename:match("^apps%.(.-)%.json$")
        if account then
          table.insert(choices, account)
        end
      end

      if #choices == 0 then
        print("❌ No account configs found in ~/.config/github-copilot/")
        return
      end

      fzf.fzf_exec(choices, {
        prompt = "Select Copilot account > ",
        actions = {
          ["default"] = function(selected)
            local account = selected[1]
            local src = string.format("%s/apps.%s.json", config_path, account)
            local dst = string.format("%s/apps.json", config_path)

            local cmd = string.format("cp %s %s", vim.fn.shellescape(src), vim.fn.shellescape(dst))
            vim.fn.system(cmd)
            print("✅ Switched Copilot account to: " .. account)
          end
        }
      })
    end, {
      desc = "Switch GitHub Copilot account config"
    })
  end
}
