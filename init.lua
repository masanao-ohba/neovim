vim.g.mapleader = " "  -- 好きなキーに設定

-- vim.tbl_flatten: 非推奨呼び出しの起動時通知を抑止（依存プラグインが多用）
vim.tbl_flatten = function(t)
  local result = {}
  local function flatten(arr)
    for _, v in ipairs(arr) do
      if type(v) == "table" then
        flatten(v)
      else
        result[#result + 1] = v
      end
    end
  end
  flatten(t)
  return result
end

-- 共通設定をロード
require("settings")

-- Lazy.nvimプラグインマネージャを読み込む
require("config.lazy")

