return {
  "lambdalisue/fern.vim",
  dependencies = {
    "lambdalisue/fern-renderer-nerdfont.vim",
    "lambdalisue/fern-hijack.vim",
    "lambdalisue/nerdfont.vim",
    "lambdalisue/glyph-palette.vim",
  },
  init = function()
    vim.g["fern#renderer"] = "nerdfont"
    vim.g["fern#default_hidden"] = 1
    vim.g["fern#default_expand"] = 1

    vim.cmd([[
      augroup FernCustomKeymaps
        autocmd!
        autocmd FileType fern nmap <buffer> <CR> <Plug>(fern-action-open:tabedit)
        autocmd FileType fern nmap <buffer> a <Plug>(fern-action-open:tabedit)
        autocmd FileType fern nmap <buffer> x <Plug>(fern-action-close)
        autocmd FileType fern nmap <buffer> d <Plug>(fern-action-remove)
        autocmd FileType fern call glyph_palette#apply()
      augroup END
    ]])
  end,
  config = function()
    vim.keymap.set('n', '<C-o>', ':Fern . -reveal=% -drawer -toggle -width=45<CR>', { noremap = true, silent = true })
  end
}
