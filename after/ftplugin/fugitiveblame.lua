-- Reuse Fugitive's parent-blame navigation, only in the blame buffer.
vim.keymap.set('n', '<CR>', '~', {
  buffer = true,
  remap = true,
  silent = true,
  desc = 'Blame before this change',
})
