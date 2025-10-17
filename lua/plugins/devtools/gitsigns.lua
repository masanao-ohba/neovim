-- ============================================================================
-- Plugin: gitsigns.nvim
-- Repository: lewis6991/gitsigns.nvim
-- Category: Git Integration / Development Tools
--
-- Purpose:
--   Git decorations and hunk management displayed in the sign column.
--   Provides visual indicators for git changes and interactive git operations.
--
-- Key Features:
--   - Visual git diff indicators in sign column (add, change, delete, untracked)
--   - Navigate between git hunks with keybindings
--   - Stage, reset, and preview individual hunks
--   - Inline blame information display
--   - Integration with diffview for file history
--   - Per-buffer attachment with custom keymaps
--   - Current line blame (optional)
--
-- Keybindings:
--   <C-n>        - Next hunk (global)
--   <C-p>        - Previous hunk (global)
--   [c / ]c      - Navigate hunks (buffer-local)
--   <leader>gp   - Preview hunk
--   <leader>gd   - Diff this file
--   <leader>gs   - Stage hunk
--   <leader>gr   - Reset hunk
--   <leader>gS   - Stage entire buffer
--   <leader>gu   - Undo stage hunk
--   <leader>gR   - Reset entire buffer
--   <leader>gb   - Git blame/history (current file)
--   <leader>gB   - Git history (project)
--   <leader>gt   - Test/refresh gitsigns
-- ============================================================================

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gitsigns = require('gitsigns')

    -- Global keymaps for navigation (works even before buffer attach)
    vim.keymap.set('n', '<C-n>', function()
      if vim.wo.diff then return '<C-n>' end
      vim.schedule(function() gitsigns.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = 'Next git hunk' })

    vim.keymap.set('n', '<C-p>', function()
      if vim.wo.diff then return '<C-p>' end
      vim.schedule(function() gitsigns.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = 'Previous git hunk' })

    gitsigns.setup({
      base = 'HEAD', -- Compare against HEAD instead of index (shows staged changes)
      current_line_blame = false, -- お好みで true にすると常時表示
      signs = {
        add          = { text = '▊' },  -- Wider block character for better visibility
        change       = { text = '▊' },  -- Alternative options: '█', '▌', '●', '║'
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Git blame表示
        vim.keymap.set('n', '<leader>gb', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Git blame/history for current file' })
        vim.keymap.set('n', '<leader>gB', '<cmd>DiffviewFileHistory<cr>', { desc = 'Git history for project' })

        -- コミット間の移動
        vim.keymap.set('n', '[c', gs.prev_hunk, { buffer = bufnr, desc = 'Previous hunk' })
        vim.keymap.set('n', ']c', gs.next_hunk, { buffer = bufnr, desc = 'Next hunk' })
        -- Alternative with Ctrl
        vim.keymap.set('n', '<C-S-p>', gs.prev_hunk, { buffer = bufnr, desc = 'Previous hunk' })
        vim.keymap.set('n', '<C-S-n>', gs.next_hunk, { buffer = bufnr, desc = 'Next hunk' })

        -- その他便利なキーマップ
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, { buffer = bufnr, desc = 'Diff this' })
        vim.keymap.set('n', '<leader>gs', gs.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
        vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
        vim.keymap.set('n', '<leader>gS', gs.stage_buffer, { buffer = bufnr, desc = 'Stage buffer' })
        vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk, { buffer = bufnr, desc = 'Undo stage hunk' })
        vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { buffer = bufnr, desc = 'Reset buffer' })

        -- デバッグ用コマンド
        vim.keymap.set('n', '<leader>gt', function()
          vim.notify('Gitsigns attached: ' .. tostring(vim.api.nvim_buf_is_valid(bufnr)), vim.log.levels.INFO)
          gs.refresh()
        end, { buffer = bufnr, desc = 'Test/refresh gitsigns' })
      end
    })
  end
}
