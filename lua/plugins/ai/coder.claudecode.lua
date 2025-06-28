return {
  "coder/claudecode.nvim",
  -- 依存関係の設定
  dependencies = {
    "folke/snacks.nvim", -- オプショナル: 強化されたターミナル機能のため
  },
  -- プラグインのオプション設定
  opts = {
    -- WebSocketサーバーのポート範囲（デフォルト: 10000-65535）
    port_range = { min = 10000, max = 65535 },
    
    -- プラグインロード時にWebSocketサーバーを自動開始
    -- 注意: lazy-loading使用時、最初のプラグインコマンドが使用されたときに開始
    auto_start = true,
    
    -- Claude起動時に使用するカスタムターミナルコマンド
    -- nilまたは空の場合、デフォルトで "claude" を使用
    terminal_cmd = nil, -- 例: "my_claude_wrapper_script" または "claude --project-foo"
    
    -- ログレベル（trace, debug, info, warn, error）
    log_level = "info",
    
    -- Claudeへの選択範囲更新送信を有効化
    track_selection = true,
    
    -- ビジュアルモード終了時に選択範囲をカーソル/ファイル選択に「降格」するまでの待機時間（ミリ秒）
    -- Claudeターミナルへの素早い切り替え時にビジュアルコンテキストを保持するのに役立つ
    visual_demotion_delay_ms = 50,
    
    -- openDiff MCPツール用のDiffプロバイダー設定
    diff_provider = "auto", -- "auto", "native", または "diffview"（実装時）
    diff_opts = {
      auto_close_on_accept = true,   -- 変更受諾時にdiffを自動クローズ
      show_diff_stats = true,        -- diff統計を表示
      vertical_split = true,         -- diffビューで垂直分割を使用
      open_in_current_tab = true,    -- 新しいタブではなく現在のタブでdiffを開く（混雑を軽減）
    },
    
    -- インタラクティブターミナルの設定
    terminal = {
      split_side = "right",             -- 垂直分割の位置（"left"または"right"）
      split_width_percentage = 0.30,    -- エディタ全体幅に対するターミナル幅の割合（0.0〜1.0）
      provider = "snacks",              -- ターミナルプロバイダー（"snacks"または"native"）
      show_native_term_exit_tip = true, -- ネイティブターミナルモード終了のヒント表示（Ctrl-\\ Ctrl-N）
    }
  },
  
  -- setup関数を自動的に呼び出す
  config = true,
  
  -- 便利なキーマップの設定（オプショナル）
  keys = {
    -- AI/Claude Codeのプレフィックスキー
    -- { "<leader>C-c", nil, mode = { "n", "v" }, desc = "AI/Claude Code" },
    
    -- Claudeターミナルをトグル（開閉切り替え）
    { "<leader>cc", "<cmd>ClaudeCode<cr>", mode = { "n", "v" }, desc = "Toggle Claude Terminal" },
    
    -- 選択範囲をClaude Codeに送信（ビジュアルモードのみ）
    { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = { "v" }, desc = "Send to Claude Code" },
    
    -- Claudeターミナルを開く/フォーカス
    { "<leader>co", "<cmd>ClaudeCodeOpen<cr>", mode = { "n", "v" }, desc = "Open/Focus Claude Terminal" },
    
    -- Claudeターミナルを閉じる
    { "<leader>cq", "<cmd>ClaudeCodeClose<cr>", mode = { "n", "v" }, desc = "Close Claude Terminal" },
  },
}

