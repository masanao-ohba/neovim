return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x", -- 最新のv3ブランチを使用
  dependencies = {
    "nvim-lua/plenary.nvim",     -- 必須依存関係
    "nvim-tree/nvim-web-devicons", -- ファイルアイコン用
    "MunifTanjim/nui.nvim",      -- UI コンポーネント
  },
  config = function()
    require("neo-tree").setup({
      -- ウィンドウの閉じ方設定
      close_if_last_window = false, -- neo-treeが最後のウィンドウの場合に自動で閉じない
      popup_border_style = "rounded", -- ポップアップのボーダースタイル
      enable_git_status = true,      -- Gitステータスの表示を有効化
      enable_diagnostics = true,     -- LSP診断情報の表示を有効化

      -- デフォルトのソース設定
      default_component_configs = {
        -- インデント設定
        indent = {
          indent_size = 2,           -- インデントサイズ
          padding = 1,               -- パディング
          with_markers = true,       -- インデントマーカーを表示
          indent_marker = "│",       -- インデントマーカー文字
          last_indent_marker = "└",  -- 最後のインデントマーカー文字
          highlight = "NeoTreeIndentMarker", -- ハイライトグループ
        },

        -- アイコン設定
        icon = {
          folder_closed = "📁",        -- 閉じたフォルダアイコン（Unicode絵文字）
          folder_open = "📂",          -- 開いたフォルダアイコン（Unicode絵文字）
          folder_empty = "📁",         -- 空フォルダアイコン
          default = "📄",              -- デフォルトファイルアイコン
          highlight = "NeoTreeFileIcon", -- アイコンのハイライト
        },

        -- 修正マーカー設定
        modified = {
          symbol = "[+]",            -- 修正されたファイルのマーカー
          highlight = "NeoTreeModified", -- ハイライトグループ
        },

        -- ファイル名設定
        name = {
          trailing_slash = false,    -- ディレクトリ名の末尾にスラッシュを付けない
          use_git_status_colors = true, -- Gitステータスの色を使用
          highlight = "NeoTreeFileName", -- ファイル名のハイライト
        },

        -- Gitステータス設定
        git_status = {
          symbols = {
            added     = "✅",         -- 追加されたファイル（緑のチェックマーク）
            modified  = "📝",         -- 変更されたファイル（編集アイコン）
            deleted   = "🗑️",         -- 削除されたファイル（ゴミ箱）
            renamed   = "🔄",         -- リネームされたファイル（循環矢印）
            untracked = "❓",         -- 未追跡ファイル（疑問符）
            ignored   = "🚫",         -- 無視されたファイル（禁止マーク）
            unstaged  = "⚠️",         -- ステージされていない変更（警告）
            staged    = "✔️",         -- ステージされた変更（チェックマーク）
            conflict  = "⚡",         -- コンフリクト（稲妻）
          }
        },
      },

      -- ウィンドウ設定
      window = {
        position = "left",           -- 左側に表示
        width = 30,                  -- ウィンドウ幅
        mapping_options = {
          noremap = true,            -- キーマッピングのnoremap設定
          nowait = true,             -- キーマッピングのnowait設定
        },

        -- キーマッピング設定
        mappings = {
          ["<space>"] = {
            "toggle_node",
            nowait = false,          -- スペースキーでノードの開閉
          },
          ["<2-LeftMouse>"] = "open", -- ダブルクリックでファイルを開く
          ["<cr>"] = "open",          -- Enterキーでファイルを開く
          ["<esc>"] = "cancel",       -- Escキーでキャンセル
          ["P"] = { "toggle_preview", config = { use_float = true } }, -- プレビュー表示
          ["l"] = "open_node",        -- lキーでノードを開く（ファイルは開かない）
          ["h"] = "close_node",       -- hキーでノードを閉じる
          ["j"] = "next_node",        -- jキーで下のノードに移動
          ["k"] = "prev_node",        -- kキーで上のノードに移動
          ["S"] = "open_split",       -- 水平分割で開く
          ["s"] = "open_vsplit",      -- 垂直分割で開く
          ["t"] = "open_tabnew",      -- 新しいタブで開く
          ["w"] = "open_with_window_picker", -- ウィンドウピッカーで開く
          ["z"] = "close_all_nodes",  -- すべてのノードを閉じる
          ["a"] = {
            "add",
            config = {
              show_path = "none"      -- 新規ファイル作成時のパス表示
            }
          },
          ["A"] = "add_directory",    -- ディレクトリ作成
          ["d"] = "delete",           -- ファイル/ディレクトリ削除
          ["r"] = "rename",           -- ファイル/ディレクトリ名変更
          ["y"] = "copy_to_clipboard", -- クリップボードにコピー
          ["x"] = "cut_to_clipboard",  -- クリップボードに切り取り
          ["p"] = "paste_from_clipboard", -- クリップボードから貼り付け
          ["c"] = "copy",             -- ファイルコピー
          ["m"] = "move",             -- ファイル移動
          ["q"] = "close_window",     -- ウィンドウを閉じる
          ["R"] = "refresh",          -- 表示を更新
          ["?"] = "show_help",        -- ヘルプ表示
          ["<"] = "prev_source",      -- 前のソースに切り替え
          [">"] = "next_source",      -- 次のソースに切り替え
          ["i"] = "show_file_details", -- ファイル詳細表示
        }
      },

      -- ファイルシステム設定
      filesystem = {
        visible = true,              -- ファイルシステムビューを表示
        hide_dotfiles = false,       -- ドットファイルを表示
        hide_gitignored = false,     -- gitignoreされたファイルを表示
        hide_hidden = false,         -- 隠しファイルを表示

        -- 隠すファイル/ディレクトリのパターン
        hide_by_name = {
          ".DS_Store",
          "thumbs.db"
        },

        -- 隠すファイルの拡張子
        hide_by_pattern = {
          "*.meta",
          "*/src/*/tsconfig.json",
        },

        -- 常に表示するファイル
        always_show = {
          ".gitignored",
        },

        -- ファイル数制限設定（要求された機能）
        max_items = 10,              -- ディレクトリ内の最大表示アイテム数

        -- ディレクトリを最初に表示
        group_dirs_by = "first",

        -- ファイルを開いた時の動作
        follow_current_file = {
          enabled = false,           -- 現在のファイルに自動フォーカスしない
          leave_dirs_open = false,   -- ディレクトリを開いたままにしない
        },

        -- ファイルマネージャーとして使用する際の設定
        use_libuv_file_watcher = false, -- libuvファイルウォッチャーを使用しない

        -- ウィンドウ設定
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",  -- バックスペースで上の階層に移動
            ["."] = "set_root",        -- 現在のディレクトリをルートに設定
            ["H"] = "toggle_hidden",   -- 隠しファイルの表示切り替え
            ["/"] = "fuzzy_finder",    -- ファジーファインダー
            ["D"] = "fuzzy_finder_directory", -- ディレクトリのファジーファインダー
            ["#"] = "fuzzy_sorter",    -- ファジーソーター
            ["f"] = "filter_on_submit", -- フィルター実行
            ["<c-x>"] = "clear_filter", -- フィルタークリア
            ["[g"] = "prev_git_modified", -- 前のGit変更ファイルに移動
            ["]g"] = "next_git_modified", -- 次のGit変更ファイルに移動
            ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
            ["oc"] = { "order_by_created", nowait = false }, -- 作成日時順
            ["od"] = { "order_by_diagnostics", nowait = false }, -- 診断順
            ["og"] = { "order_by_git_status", nowait = false }, -- Gitステータス順
            ["om"] = { "order_by_modified", nowait = false }, -- 更新日時順
            ["on"] = { "order_by_name", nowait = false }, -- 名前順
            ["os"] = { "order_by_size", nowait = false }, -- サイズ順
            ["ot"] = { "order_by_type", nowait = false }, -- タイプ順
          },

          -- ファジーファインダー設定
          fuzzy_finder_mappings = {
            ["<down>"] = "move_cursor_down",
            ["<C-n>"] = "move_cursor_down",
            ["<up>"] = "move_cursor_up",
            ["<C-p>"] = "move_cursor_up",
          },
        },

        -- コマンド設定
        commands = {}
      },

      -- バッファ設定
      buffers = {
        follow_current_file = {
          enabled = true,            -- 現在のファイルに自動フォーカス
          leave_dirs_open = false,   -- ディレクトリを開いたままにしない
        },
        group_empty_dirs = false,    -- 空のディレクトリをグループ化しない
        show_unloaded = true,        -- アンロードされたバッファも表示
        window = {
          mappings = {
            ["bd"] = "buffer_delete", -- バッファ削除
            ["<bs>"] = "navigate_up", -- 上の階層に移動
            ["."] = "set_root",       -- ルート設定
            ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          }
        },
      },

      -- Gitステータス設定
      git_status = {
        window = {
          position = "float",        -- フロートウィンドウで表示
          mappings = {
            ["A"]  = "git_add_all",   -- すべてのファイルをステージング
            ["gu"] = "git_unstage_file", -- ファイルのステージング解除
            ["ga"] = "git_add_file",  -- ファイルをステージング
            ["gr"] = "git_revert_file", -- ファイルの変更を元に戻す
            ["gc"] = "git_commit",    -- コミット
            ["gp"] = "git_push",      -- プッシュ
            ["gg"] = "git_commit_and_push", -- コミット＆プッシュ
            ["o"]  = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          }
        }
      }
    })

    -- キーマッピング設定
    vim.keymap.set('n', '<C-o>', ':Neotree filesystem toggle left<CR>', { desc = 'Neo-tree toggle' })
    vim.keymap.set('n', '<leader>bf', ':Neotree buffers reveal float<CR>', { desc = 'Neo-tree buffers' })
    vim.keymap.set('n', '<leader>gs', ':Neotree git_status<CR>', { desc = 'Neo-tree git status' })
  end,
}
