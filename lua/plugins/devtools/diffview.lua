return {
  "sindrets/diffview.nvim",
  config = function()
    require('diffview').setup({
      keymaps = {
        file_history_panel = {
          ["<S-P>"] = "prev_entry",
          ["<S-N>"] = "next_entry",
        }
      }
    })
    vim.keymap.set('n', '<leader>gb', '<cmd>DiffviewFileHistory %<cr>')
  end
}
