-- 基本設定
vim.o.number = true
vim.o.relativenumber = false
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
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
vim.keymap.set('n', ',vd', ':vertical diffsplit ', { noremap = true })
vim.keymap.set('n', ',sd', ':diffsplit ', { noremap = true })

-- カーソルカラムの表示をトグルする関数
function ToggleCursorColumn()
  vim.o.cursorcolumn = not vim.o.cursorcolumn
end
-- <LEADER>cc にマッピング（例: <Leader> が '\' の場合、\cc でトグル）
vim.keymap.set('n', '<Leader>cc', ToggleCursorColumn, { noremap = true, silent = true, desc = "Toggle cursorcolumn" })

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

