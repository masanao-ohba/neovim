return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Git操作に必要
  },
  config = function()
    require("claude-code").setup({
      -- ターミナルウィンドウ設定
      window = {
        split_ratio = 0.3,      -- ターミナルウィンドウの画面占有率（水平分割では高さ、垂直分割では幅）
        position = "botright",  -- ウィンドウの位置："botright", "topleft", "vertical", "rightbelow vsplit" など
        enter_insert = true,    -- Claude Code起動時にインサートモードに入るかどうか
        hide_numbers = true,    -- ターミナルウィンドウで行番号を非表示にする
        hide_signcolumn = true, -- ターミナルウィンドウでサインカラムを非表示にする
      },
      -- ファイル更新設定
      refresh = {
        enable = true,           -- ファイル変更検出を有効にする
        updatetime = 100,        -- Claude Code動作中のupdatetime（ミリ秒）
        timer_interval = 1000,   -- ファイル変更チェック間隔（ミリ秒）
        show_notifications = true, -- ファイル再読み込み時に通知を表示する
      },
      -- Gitプロジェクト設定
      git = {
        use_git_root = true,     -- Claude Code起動時にCWDをgitルートに設定（gitプロジェクト内の場合）
      },
      -- シェル固有設定
      shell = {
        separator = '&&',        -- シェルコマンドで使用するコマンド区切り文字
        pushd_cmd = 'pushd',     -- ディレクトリをスタックにプッシュするコマンド（例：bash/zshでは'pushd'、nushellでは'enter'）
        popd_cmd = 'popd',       -- ディレクトリをスタックからポップするコマンド（例：bash/zshでは'popd'、nushellでは'exit'）
      },
      -- コマンド設定
      command = "claude",        -- Claude Code起動に使用するコマンド
      -- コマンドバリエーション
      command_variants = {
        -- 会話管理
        continue = "--continue", -- 最新の会話を再開
        resume = "--resume",     -- インタラクティブな会話選択画面を表示

        -- 出力オプション
        verbose = "--verbose",   -- ターンごとの詳細出力を含む詳細ログを有効にする
      },
      -- キーマップ
      keymaps = {
        toggle = {
          normal = "<C-_>",       -- Claude Code切り替え用ノーマルモードキーマップ、無効にするにはfalse
          terminal = "<C-_>",     -- Claude Code切り替え用ターミナルモードキーマップ、無効にするにはfalse
          variants = {
            continue = "<leader>acC", -- continueフラグ付きClaude Code用ノーマルモードキーマップ
            verbose = false,  -- verboseフラグ無効化
          },
        },
        window_navigation = true, -- ウィンドウナビゲーションキーマップを有効にする（<C-h/j/k/l>）
        scrolling = true,         -- ページアップ/ダウン用スクロールキーマップを有効にする（<C-f/b>）
      }
    })
  end
}
