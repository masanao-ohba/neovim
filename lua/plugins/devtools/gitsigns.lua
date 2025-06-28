return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup({
      current_line_blame = false, -- お好みで true にすると常時表示
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Git blame表示
        vim.keymap.set('n', '<leader>gb', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Git blame/history for current file' })
        vim.keymap.set('n', '<leader>gB', '<cmd>DiffviewFileHistory<cr>', { desc = 'Git history for project' })

        -- コミット間の移動
        vim.keymap.set('n', '<S-P>', gs.prev_hunk, { buffer = bufnr, desc = 'Previous hunk' })
        vim.keymap.set('n', '<S-N>', gs.next_hunk, { buffer = bufnr, desc = 'Next hunk' })

        -- その他便利なキーマップ
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, { buffer = bufnr, desc = 'Diff this' })
      end
    })
  end
}
