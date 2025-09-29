-- 基本設定
vim.o.number = true
vim.o.relativenumber = false
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.cursorline = true
vim.o.cursorcolumn = false
vim.o.showmatch = true
vim.o.backup = false
vim.o.swapfile = false
vim.o.hlsearch = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.clipboard = 'unnamedplus'
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.backspace = 'start,eol,indent'
vim.o.foldmethod = 'syntax'
vim.o.foldlevel = 99      -- 初期状態で全て展開
vim.o.foldlevelstart = 99 -- ファイルを開いた時に全て展開

vim.g.php_folding = 0
vim.o.conceallevel = 0
vim.o.laststatus = 2
vim.o.hidden = true
vim.o.wrap = false

-- カラースキーム
vim.cmd('syntax on')
vim.g.nvcode_termcolors = 256
vim.cmd('colorscheme nord')

vim.cmd [[
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
]]

-- キーマッピング
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', 'gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', 'gT', { noremap = true, silent = true })
vim.keymap.set('n', ',vdv', ':vertical diffsplit ', { noremap = true, desc = 'Vertical diff split' })
vim.keymap.set('n', ',vdh', ':diffsplit ', { noremap = true, desc = 'Horizontal diff split' })

-- ウィンドウ間の移動をCtrl+hjklで行う
-- vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
-- vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to window below' })
-- vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to window above' })
-- vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- カーソルカラムの表示をトグルする関数
function ToggleCursorColumn()
  vim.o.cursorcolumn = not vim.o.cursorcolumn
end
-- <LEADER>cc にマッピング（例: <Leader> が '\' の場合、\cc でトグル）
vim.keymap.set('n', ',vc', ToggleCursorColumn, { noremap = true, silent = true, desc = "Toggle cursor column" })

-- ファイルタイプ別インデント
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'css', 'hcl', 'html', 'javascript', 'lua', 'perl',
    'ruby', 'slim', 'sql', 'terraform', 'tf', 'twig', 'yaml',
  },
  callback = function()
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
  end,
})

local replace = require("modules/word-replace")
vim.keymap.set("n", "<Leader>R", replace.replace_with_input, { noremap = true, silent = true })

require("modules/code-block")
-- ノーマルモードでコードブロック挿入
vim.keymap.set("n", "<leader>`", function()
  require("modules.code-block").insert_code_block()
end, { desc = "コードブロック挿入" })

-- ビジュアルモードで選択範囲をバッククォートで括る
vim.keymap.set("v", "`", function()
  require("modules.code-block").wrap_selection_with_backtick()
end, { desc = "選択範囲をバッククォートで括る" })

-- ノーマルモードでカーソル下の単語をバッククォートで括る
vim.keymap.set("n", "`", function()
  require("modules.code-block").wrap_word_under_cursor()
end, { desc = "カーソル下の単語をバッククォートで括る" })

-- 相対パスと行番号を取得してクリップボードにコピー
vim.keymap.set("n", "<C-c>", function()
  require("modules.path-info").get_relative_path_and_line()
end, { desc = "相対パスと行番号をコピー (@path Lline形式)" })

-- GitHub URLをクリップボードにコピー
vim.keymap.set({"n", "v"}, "<Leader>gy", function()
  require("modules.github-url").copy_github_url()
end, { desc = "GitHub URLをコピー" })

