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

    -- Custom colors for git signs
    vim.api.nvim_set_hl(0, 'GitSignsAdd',          { fg = '#ff6800', bold = true }) -- Bright  green for additions
    vim.api.nvim_set_hl(0, 'GitSignsChange',       { fg = '#ff6800', bold = true }) -- Orange  for   changes
    vim.api.nvim_set_hl(0, 'GitSignsDelete',       { fg = '#ff0000', bold = true }) -- Red     for   deletions
    vim.api.nvim_set_hl(0, 'GitSignsTopdelete',    { fg = '#ff0000', bold = true }) -- Red     for   top delete
    vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { fg = '#ff00ff', bold = true }) -- Magenta for   change+delete
    vim.api.nvim_set_hl(0, 'GitSignsUntracked',    { fg = '#808080', bold = true }) -- Gray    for   untracked

    -- Global keymaps for navigation (works even before buffer attach)
    vim.keymap.set('n', '<C-n>', function()
      if vim.wo.diff then return '<C-n>' end
      vim.schedule(function()
        gitsigns.nav_hunk('next', {target = 'all'})
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Next git hunk (including staged)' })

    vim.keymap.set('n', '<C-p>', function()
      if vim.wo.diff then return '<C-p>' end
      vim.schedule(function()
        gitsigns.nav_hunk('prev', {target = 'all'})
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Previous git hunk (including staged)' })
    
    gitsigns.setup({
      debug_mode = false, -- Enable for verbose logging
      current_line_blame = false, -- お好みで true にすると常時表示
      base = "HEAD", -- Show ALL changes including staged (HEAD = compare with last commit, nil = only unstaged changes)
      signs = {
        add          = { text = '██', hl = 'GitSignsAdd' },     -- Split blocks - HIGH impact for unstaged additions
        change       = { text = '▓█', hl = 'GitSignsChange' },  -- Shaded + solid - MAXIMUM impact for unstaged changes
        delete       = { text = '▁_', hl = 'GitSignsDelete' },  -- Low impact for deletions
        topdelete    = { text = '‾▔', hl = 'GitSignsTopdelete' },
        changedelete = { text = '~_', hl = 'GitSignsChangedelete' },
        untracked    = { text = '░░', hl = 'GitSignsUntracked' }, -- Light blocks - MEDIUM impact for untracked
      },
      signs_staged = {
        add          = { text = '++', hl = 'GitSignsAdd' },
        change       = { text = '++', hl = 'GitSignsChange' },
        delete       = { text = '--', hl = 'GitSignsDelete' },
        topdelete    = { text = '--', hl = 'GitSignsTopdelete' },
        changedelete = { text = '~~', hl = 'GitSignsChangedelete' },
        untracked    = { text = '++', hl = 'GitSignsUntracked' },
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
          local info = {}
          table.insert(info, 'Gitsigns Debug Info:')
          table.insert(info, '  Attached: ' .. tostring(vim.api.nvim_buf_is_valid(bufnr)))
          table.insert(info, '  Base: ' .. vim.inspect(gs.get_config().base))

          -- Show hunk information
          local hunks = gs.get_hunks(bufnr)
          if hunks and #hunks > 0 then
            table.insert(info, '  Hunks found: ' .. #hunks)
            for i, hunk in ipairs(hunks) do
              table.insert(info, string.format('    Hunk %d: lines %d-%d (type: %s)',
                i, hunk.added.start, hunk.added.start + hunk.added.count - 1, hunk.type))
            end
          else
            table.insert(info, '  Hunks found: 0 (no changes detected)')
          end

          -- Print to command line (more reliable than notify)
          print(table.concat(info, '\n'))
          gs.refresh()
        end, { buffer = bufnr, desc = 'Test/refresh gitsigns' })
      end
    })
  end
}
