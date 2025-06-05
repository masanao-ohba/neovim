vim.g.mapleader = ","  -- 好きなキーに設定

-- 共通設定をロード
vim.schedule(function()
  require("settings")
end)

-- Lazy.nvimプラグインマネージャを読み込む
require("config.lazy")

-- プラグイン固有設定
require('toggleterm')
