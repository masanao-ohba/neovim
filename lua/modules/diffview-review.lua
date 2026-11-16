-- Overlay "reviewed" marks and per-folder stats on the diffview.nvim file panel
--   - Files:   if reviewed, overlay ✓ right of the status symbol and dim the line
--   - Folders: +added -removed and reviewed/total files beneath (✓ at the left edge if all reviewed)
--   - Header:  total reviewed count
-- Reviewed state is saved per "repository + comparison range" in stdpath('data')/diffview_viewed.json.
-- If the current content differs from the hash saved at review time (changed after review), it reverts to unreviewed.
local M = {}

local ns = vim.api.nvim_create_namespace('diffview_review')
local store_path = vim.fn.stdpath('data') .. '/diffview_viewed.json'
local store
local hash_cache = {} -- abs_path -> { mtime, size, hash }

local function load_store()
  if store then return store end
  local f = io.open(store_path, 'r')
  local ok, data = pcall(vim.json.decode, f and f:read('*a') or '')
  if f then f:close() end
  store = ok and type(data) == 'table' and data or {}
  return store
end

local function save_store()
  local f = io.open(store_path, 'w')
  if f then
    f:write(vim.json.encode(store))
    f:close()
  end
end

local function file_hash(abs)
  local stat = vim.uv.fs_stat(abs)
  if not stat then return 'deleted' end
  local cached = hash_cache[abs]
  if cached and cached.mtime == stat.mtime.sec and cached.nsec == stat.mtime.nsec and cached.size == stat.size then
    return cached.hash
  end
  local f = io.open(abs, 'rb')
  local hash = f and vim.fn.sha256(f:read('*a')) or 'unreadable'
  if f then f:close() end
  hash_cache[abs] = { mtime = stat.mtime.sec, nsec = stat.mtime.nsec, size = stat.size, hash = hash }
  return hash
end

local function view_of(panel)
  for _, view in ipairs(require('diffview.lib').views) do
    if view.panel == panel then return view end
  end
end

local function bucket(panel)
  local view = view_of(panel)
  local key = panel.adapter.ctx.toplevel .. '|' .. ((view and view.rev_arg) or panel.rev_pretty_name or 'working')
  local s = load_store()
  s[key] = s[key] or {}
  return s[key], panel.adapter.ctx.toplevel
end

local function is_viewed(marks, toplevel, file)
  local saved = marks[file.path]
  return saved ~= nil and saved == file_hash(toplevel .. '/' .. file.path)
end

-- Enumerate files (FileEntry) under a component tree
local function collect_files(comp, out)
  out = out or {}
  if comp.name == 'file' then
    table.insert(out, comp.context)
  end
  for _, child in ipairs(comp.components or {}) do
    collect_files(child, out)
  end
  return out
end

local function set_eol(buf, line, chunks)
  if line >= 0 then
    vim.api.nvim_buf_set_extmark(buf, ns, line, 0, { virt_text = chunks, virt_text_pos = 'eol', priority = 200 })
  end
end

-- Recursively decorate files/folders and return {added, removed, reviewed count, file count}
local function decorate_comp(buf, comp, marks, toplevel, visible)
  if comp.name == 'file' then
    local file = comp.context
    local stats = file.stats or {}
    local viewed = is_viewed(marks, toplevel, file)
    if visible and viewed and comp.lstart >= 0 then
      -- Overlay ✓ on the blank after the leading "M " (no text shift, so the tree layout stays intact)
      vim.api.nvim_buf_set_extmark(buf, ns, comp.lstart, 1, {
        virt_text = { { '✓', 'DiffviewFilePanelInsertions' } },
        virt_text_pos = 'overlay', priority = 200,
      })
      vim.api.nvim_buf_set_extmark(buf, ns, comp.lstart, 2, {
        end_row = comp.lstart + 1, hl_group = 'Comment', hl_eol = false, priority = 200,
      })
    end
    return stats.additions or 0, stats.deletions or 0, viewed and 1 or 0, 1
  end

  -- Children of collapsed folders aren't rendered and keep a stale lstart, so skip decorating them
  local child_visible = visible and not (comp.name == 'directory' and comp.context and comp.context.collapsed)
  local adds, dels, viewed, total = 0, 0, 0, 0
  for _, child in ipairs(comp.components or {}) do
    local a, d, v, t = decorate_comp(buf, child, marks, toplevel, child_visible)
    adds, dels, viewed, total = adds + a, dels + d, viewed + v, total + t
  end

  if visible and comp.name == 'directory' then
    local dir_line = comp.components[1] and comp.components[1].lstart or -1
    local done = viewed == total
    set_eol(buf, dir_line, {
      { ' +' .. adds, 'DiffviewFilePanelInsertions' },
      { ' -' .. dels, 'DiffviewFilePanelDeletions' },
      { string.format('  %d/%d', viewed, total), done and 'DiffviewFilePanelInsertions' or 'Comment' },
    })
    if done and dir_line >= 0 then
      vim.api.nvim_buf_set_extmark(buf, ns, dir_line, 1, {
        virt_text = { { '✓', 'DiffviewFilePanelInsertions' } },
        virt_text_pos = 'overlay', priority = 200,
      })
    end
  end
  return adds, dels, viewed, total
end

function M.decorate(panel)
  local buf = panel.bufid
  if not (buf and vim.api.nvim_buf_is_valid(buf) and panel.components) then return end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local marks, toplevel = bucket(panel)

  for _, section in ipairs({ 'conflicting', 'working', 'staged' }) do
    local sec = panel.components[section]
    if sec and sec.files then
      local _, _, viewed, total = decorate_comp(buf, sec.files.comp, marks, toplevel, true)
      if total > 0 then
        set_eol(buf, sec.title.comp.lstart, { { string.format('  ✓ %d/%d viewed', viewed, total), 'Comment' } })
      end
    end
  end
end

-- Toggle reviewed state of the file under the cursor (all files beneath, if a folder)
function M.toggle_at_cursor()
  local view = require('diffview.lib').get_current_view()
  local panel = view and view.panel
  if not panel then return end

  local files
  if vim.api.nvim_get_current_buf() == panel.bufid then
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local comp = panel.components.comp:get_comp_on_line(line)
    if comp and comp.name == 'dir_name' then comp = comp.parent end
    files = comp and collect_files(comp) or {}
  else
    files = { view.cur_entry }
  end
  if #files == 0 then return end

  local marks, toplevel = bucket(panel)
  local all_viewed = true
  for _, file in ipairs(files) do
    if not is_viewed(marks, toplevel, file) then all_viewed = false break end
  end
  for _, file in ipairs(files) do
    marks[file.path] = (not all_viewed) and file_hash(toplevel .. '/' .. file.path) or nil
  end
  save_store()
  panel:redraw()
end

function M.setup()
  local FilePanel = require('diffview.scene.views.diff.file_panel').FilePanel
  local Panel = require('diffview.ui.panel').Panel
  FilePanel.redraw = function(self)
    Panel.redraw(self)
    M.decorate(self)
  end
end

return M
