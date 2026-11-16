-- ============================================================================
-- Plugin: diffview.nvim
-- Repository: sindrets/diffview.nvim
-- Category: Git Integration / Development Tools
--
-- Purpose:
--   Advanced git diff viewer with side-by-side comparison and file history.
--   Provides comprehensive diff viewing and navigation capabilities.
--
-- Key Features:
--   - Side-by-side diff viewing for file changes
--   - File history browser with commit navigation
--   - Interactive diff navigation with custom keybindings
--   - Integration with gitsigns for unified git workflow
--   - Merge conflict resolution interface
--
-- Keybindings (File History Panel):
--   <S-P> - Previous commit entry
--   <S-N> - Next commit entry
--
-- Keybindings (Global):
--   <leader>gv - Prompt for range (default origin/dev...HEAD) and open diffview
--   <leader>gV - Close diffview
--
-- Keybindings (Diffview view / file panel; shown in g? help):
--   gu        - Toggle unified / split diff in the same tab (Tab / S-Tab work in unified)
--   yy        - (file panel) Copy relative path of file / folder
--   Disabled defaults: [F ]F L X <C-w><C-f> <C-w>gf g<C-x>, panel: <down> <up> o <2-LeftMouse> f i R <c-f> <c-b>
--   zO / zC   - (file panel) Expand / collapse all folders (replaces zR / zM)
--   <C-d>/<C-u> - (file panel) Scroll the diff pane by 2 lines (same as lazygit gui.scrollHeight)
--   v         - (file panel) Toggle viewed mark on file / all files in folder
--   <leader>v - Toggle viewed mark on current file
--   File panel shows ✓ for viewed files and "+adds -dels viewed/total" per folder
--   (state: stdpath('data')/diffview_viewed.json, reset when file content changes)
--
-- Commands:
--   :DiffviewFileHistory % - Show current file history (via gitsigns <leader>gb)
--   :DiffviewFileHistory   - Show project history (via gitsigns <leader>gB)
-- ============================================================================

return {
  "sindrets/diffview.nvim",
  config = function()
    local review = require('modules.diffview-review')
    review.setup()

    -- Unified mode: within the diffview tab, replace the left/right diff windows with a single unified diff
    local unified = false
    local hidden_wins = {} -- windows shrunk to width 0 while unified view is shown

    local function unified_lines(view, path)
      local cmd = { 'git', 'diff', '-w', '--no-color', '--no-ext-diff' }
      if view.rev_arg and view.rev_arg ~= '' then
        vim.list_extend(cmd, vim.split(view.rev_arg, '%s+', { trimempty = true }))
      end
      vim.list_extend(cmd, { '--', path })
      local lines = vim.fn.systemlist(cmd, nil, false)
      return #lines > 0 and lines or { '(差分なし)' }
    end

    local toggle_unified

    local function render_unified()
      local view = require('diffview.lib').get_current_view()
      local layout = view and view.cur_layout
      local entry = view and view.cur_entry
      if not (layout and entry and layout.b and vim.api.nvim_win_is_valid(layout.b.id)) then return end

      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, unified_lines(view, entry.path))
      vim.bo[buf].bufhidden, vim.bo[buf].modifiable, vim.bo[buf].filetype = 'wipe', false, 'diff'

      local actions = require('diffview.actions')
      local maps = {
        { 'gu', toggle_unified, 'Diffview: back to split' },
        { '<tab>', actions.select_next_entry, 'Diffview: next file' },
        { '<s-tab>', actions.select_prev_entry, 'Diffview: prev file' },
        { '<leader>e', actions.toggle_files, 'Diffview: toggle file panel' },
        { 'g?', actions.help('view'), 'Diffview: help' },
        { '<leader>v', review.toggle_at_cursor, 'Diffview: toggle viewed' },
      }
      for _, m in ipairs(maps) do
        vim.keymap.set('n', m[1], m[2], { buffer = buf, desc = m[3] })
      end

      local win = layout.b.id
      vim.api.nvim_win_set_buf(win, buf)
      vim.wo[win].diff, vim.wo[win].scrollbind, vim.wo[win].cursorbind, vim.wo[win].foldenable = false, false, false, false
      vim.wo[win].winbar = ' Unified: ' .. entry.path .. '  (gu: split / Tab: 次のファイル)'
      -- Closing the other window breaks diffview, so give it an empty buffer and shrink it to width 0
      for _, w in ipairs(layout.windows) do
        if w ~= layout.b and vim.api.nvim_win_is_valid(w.id) then
          vim.api.nvim_win_set_buf(w.id, vim.api.nvim_create_buf(false, true))
          vim.wo[w.id].diff, vim.wo[w.id].winbar = false, ''
          vim.wo[w.id].number, vim.wo[w.id].relativenumber, vim.wo[w.id].signcolumn = false, false, 'no'
          vim.wo[w.id].fillchars = 'vert: ,eob: '
          vim.o.winminwidth = 0
          vim.api.nvim_win_set_width(w.id, 0)
          hidden_wins[w.id] = win
        end
      end
    end

    toggle_unified = function()
      local view = require('diffview.lib').get_current_view()
      if not view then return end
      unified = not unified
      hidden_wins = {}
      if unified then
        render_unified()
      else
        view:set_file(view.cur_entry, false)
        vim.schedule(function()
          vim.o.winminwidth = 1
          vim.cmd('wincmd =')
        end)
      end
    end

    -- When entering a zero-width window (e.g. <C-w>l), move to the unified window
    vim.api.nvim_create_autocmd('WinEnter', {
      callback = function()
        local target = unified and hidden_wins[vim.api.nvim_get_current_win()]
        if target and vim.api.nvim_win_is_valid(target) then
          vim.schedule(function() vim.api.nvim_set_current_win(target) end)
        end
      end,
    })

    -- Redraw on every file switch while in unified mode
    vim.api.nvim_create_autocmd('User', {
      pattern = 'DiffviewDiffBufWinEnter',
      callback = function()
        if unified then vim.schedule(render_unified) end
      end,
    })

    -- Disable unused default keys (also removed from g? help)
    local function disabled(keys)
      local maps = {}
      for _, key in ipairs(keys) do table.insert(maps, { 'n', key, false }) end
      return maps
    end
    local common_disabled = { '[F', ']F', 'L', 'X', '<C-w><C-f>', '<C-w>gf', 'g<C-x>' }
    local panel_disabled = {
      '<down>', '<up>', 'o', '<2-LeftMouse>', -- duplicates of j/k/<CR>/l
      'f', 'i', 'R', '<c-f>', '<c-b>',
    }

    local function copy_path()
      local view = require('diffview.lib').get_current_view()
      local item = view and view.panel:get_item_at_cursor()
      local path = item and item.path
      if not path then return end
      vim.fn.setreg('+', path)
      vim.notify('Copied: ' .. path, vim.log.levels.INFO)
    end

    -- Scroll the diff window by `lines` lines (matches lazygit's <c-d>/<c-u> = gui.scrollHeight, default 2)
    -- diffview.actions.scroll_view with a negative count becomes "norm! -2<c-y>" and moves the cursor, so implement it ourselves
    local function scroll_diff(lines)
      return function()
        local view = require('diffview.lib').get_current_view()
        local layout = view and view.cur_layout
        if not layout then return end
        local target, max = nil, -1
        for _, w in ipairs(layout.windows) do
          if vim.api.nvim_win_is_valid(w.id) then
            local h = require('diffview.utils').win_content_height(w.id)
            if h > max then target, max = w.id, h end
          end
        end
        if target then
          local key = lines < 0 and '\25' or '\5' -- <C-y> / <C-e>
          vim.api.nvim_win_call(target, function()
            vim.cmd('normal! ' .. math.abs(lines) .. key)
          end)
        end
      end
    end

    local unified_map = { 'n', 'gu', function() toggle_unified() end, { desc = 'Toggle unified / split diff' } }
    local viewed_map = { 'n', '<leader>v', review.toggle_at_cursor, { desc = 'Toggle viewed (reviewed) mark' } }
    require('diffview').setup({
      file_panel = {
        win_config = { position = 'left', width = 45 },
      },
      keymaps = {
        view = vim.list_extend({ unified_map, viewed_map }, disabled(common_disabled)),
        file_panel = vim.list_extend(vim.list_extend({
          { 'n', 'yy', copy_path, { desc = 'Copy relative path of file / folder' } },
          unified_map,
          viewed_map,
          { 'n', '<C-d>', scroll_diff(2), { desc = 'Scroll diff down (2 lines, as lazygit)' } },
          { 'n', '<C-u>', scroll_diff(-2), { desc = 'Scroll diff up (2 lines, as lazygit)' } },
          { 'n', 'zR', false },
          { 'n', 'zM', false },
          { 'n', 'zO', require('diffview.actions').open_all_folds, { desc = 'Expand all folders' } },
          { 'n', 'zC', require('diffview.actions').close_all_folds, { desc = 'Collapse all folders' } },
          { 'n', 'v', review.toggle_at_cursor, { desc = 'Toggle viewed (file / all files in folder)' } },
        }, disabled(common_disabled)), disabled(panel_disabled)),
        file_history_panel = {
          ["<S-P>"] = "prev_entry",
          ["<S-N>"] = "next_entry",
        }
      }
    })
    -- Prompt for a revision range and open diffview (e.g. origin/dev...HEAD, abc123..HEAD, main)
    vim.keymap.set('n', '<leader>gv', function()
      vim.ui.input({ prompt = 'Diffview range: ', default = 'origin/dev...HEAD' }, function(range)
        if range and range ~= '' then
          vim.opt.diffopt:append('iwhiteall')
          vim.cmd('DiffviewOpen ' .. range)
        end
      end)
    end, { desc = 'Diffview: compare range' })
    vim.keymap.set('n', '<leader>gV', '<cmd>DiffviewClose<cr>', { desc = 'Diffview: close' })

    -- Commented out: Git blame/history is handled by gitsigns
    -- vim.keymap.set('n', '<leader>gb', '<cmd>DiffviewFileHistory %<cr>')
  end
}
