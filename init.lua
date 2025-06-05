-- Lazy.nvimプラグインマネージャを読み込む
require("config.lazy")

-- 共通設定をロード
vim.schedule(function()
  require("settings")
end)

-- プラグイン固有設定
require('toggleterm')
