-- ============================================================================
-- Plugin: snacks.nvim (image module)
-- Repository: folke/snacks.nvim
-- Category: Markdown Enhancement / Diagram Rendering
--
-- Purpose:
--   Rendering of images and Mermaid diagrams in markdown buffers
--   using the Kitty Graphics Protocol.
--
-- Prerequisites:
--   - npm install -g @mermaid-js/mermaid-cli  (mmdc)
--   - ImageMagick (for non-PNG image conversion)
--   - Terminal with Kitty Graphics Protocol (WezTerm, Kitty)
--
-- Keybindings:
--   ,vi - Toggle image/diagram rendering
--
-- Note:
--   WezTerm は inline rendering 非対応のため doc.inline=false を設定
--   (snacks.nvim 公式ドキュメント: "Inline image rendering is not supported")
--
-- Patches:
--   1. snacks_image style intercept: row/col=nil でセンタリング維持
--      (image module 遅延ロード時のデフォルト復元を防止)
--   2. Win.dim override: relative="win" の float で content+border <= parent を保証
--      (snacks.nvim の dim() は border を考慮しないため)
--   3. render_fallback cursor fix: relative="win" の float で正しい絶対座標を計算
--      (nvim_win_get_position は float に対して不正な値を返す - Neovim Issue #11935)
-- ============================================================================

--- row/col を nil にしてセンタリングを維持する
local function clear_centering(style)
  if style then
    style.row = nil
    style.col = nil
  end
end

--- [Patch 1] snacks_image style のセンタリング維持
--- image module 遅延ロード時に row/col がデフォルト復元されるのを防止する
local function patch_style_intercept()
  local orig_config_style = Snacks.config.style
  Snacks.config.style = function(name, defaults)
    local result = orig_config_style(name, defaults)
    if name == "snacks_image" then
      clear_centering(Snacks.config.styles.snacks_image)
    end
    return result
  end
  clear_centering(Snacks.config.styles.snacks_image)
end

--- [Patch 2] Float の content+border が親ウィンドウに収まるよう制約する
local function patch_dim_override()
  local Win = require("snacks.win")
  local orig_dim = Win.dim
  function Win:dim(parent)
    if self.opts.relative ~= "win" then
      return orig_dim(self, parent)
    end

    parent = parent or self:parent_size()
    local border = self:border_size()
    local saved_max_w, saved_max_h = self.opts.max_width, self.opts.max_height
    local ratio_w = parent.width < 100 and 0.95 or 0.8
    local usable_w = math.floor(parent.width * ratio_w) - border.left - border.right
    local usable_h = parent.height - border.top - border.bottom
    self.opts.max_width = math.min(saved_max_w or usable_w, usable_w)
    self.opts.max_height = math.min(saved_max_h or usable_h, usable_h)
    local original_w = self.opts.width
    local ret = orig_dim(self, parent)
    self.opts.max_width, self.opts.max_height = saved_max_w, saved_max_h
    -- 幅の縮小に比例して高さも縮小（アスペクト比維持）
    if original_w and original_w > 0 and ret.width < original_w then
      ret.height = math.max(1, math.floor(ret.height * ret.width / original_w))
    end
    return ret
  end
end

--- relative="win" の float ウィンドウについてカーソル位置の補正値を計算する
--- nvim_win_get_position は float に対して不正な値を返すため、
--- 親ウィンドウの絶対座標 + float の相対オフセットから正しい位置を導出する
local function calc_cursor_fix(wins)
  for _, wid in ipairs(wins) do
    if not vim.api.nvim_win_is_valid(wid) then
      goto continue
    end
    local cfg = vim.api.nvim_win_get_config(wid)
    if cfg.relative ~= "win" or not cfg.win or not vim.api.nvim_win_is_valid(cfg.win) then
      goto continue
    end
    local parent_pos = vim.api.nvim_win_get_position(cfg.win)
    local wrong_pos = vim.api.nvim_win_get_position(wid)
    local row_fix = (parent_pos[1] + (cfg.row or 0)) - wrong_pos[1]
    local col_fix = (parent_pos[2] + (cfg.col or 0)) - wrong_pos[2]
    if col_fix ~= 0 or row_fix ~= 0 then
      return row_fix, col_fix
    end
    ::continue::
  end
  return 0, 0
end

--- [Patch 3] render_fallback のカーソル位置修正
local function patch_render_fallback_cursor()
  local ok_p, placement = pcall(require, "snacks.image.placement")
  local ok_t, terminal = pcall(require, "snacks.image.terminal")
  if not (ok_p and ok_t and placement and placement.render_fallback) then
    return
  end

  local orig_render_fallback = placement.render_fallback
  function placement.render_fallback(self, state)
    local row_fix, col_fix = calc_cursor_fix(state.wins)
    if col_fix == 0 and row_fix == 0 then
      return orig_render_fallback(self, state)
    end

    local orig_set_cursor = terminal.set_cursor
    terminal.set_cursor = function(pos)
      orig_set_cursor({ pos[1] + row_fix, pos[2] + col_fix })
    end
    local result = orig_render_fallback(self, state)
    terminal.set_cursor = orig_set_cursor
    return result
  end
end

return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    styles = {
      snacks_image = {
        relative = "win",
      },
    },
    image = {
      enabled = true,
      doc = {
        enabled = true,
        inline = false,
        float = true,
        max_width = 200,
        max_height = 80,
      },
      convert = {
        notify = true,
        mermaid = function()
          local theme = vim.o.background == "light" and "neutral" or "dark"
          return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "4" }
        end,
      },
      math = {
        enabled = false,
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    patch_style_intercept()
    patch_dim_override()
    patch_render_fallback_cursor()

    -- ウィンドウリサイズ時にプレビューを再描画
    vim.api.nvim_create_autocmd("WinResized", {
      callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].filetype == "markdown" then
            Snacks.image.placement.clean(buf)
            vim.b[buf].snacks_image_attached = false
            Snacks.image.doc.attach(buf)
          end
        end
      end,
    })
  end,
  keys = {
    {
      ",vi",
      function()
        local config = Snacks.image.config
        config.doc.enabled = not config.doc.enabled
        Snacks.image.placement.clean(vim.api.nvim_get_current_buf())
        if config.doc.enabled then
          vim.b.snacks_image_attached = false
          Snacks.image.doc.attach(vim.api.nvim_get_current_buf())
        end
        vim.notify("Snacks Image: " .. (config.doc.enabled and "ON" or "OFF"), vim.log.levels.INFO)
      end,
      ft = "markdown",
      desc = "Toggle image/diagram rendering",
    },
  },
}
