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
        max_width = 80,
        max_height = 40,
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

    -- [Patch 1] センタリング維持
    local orig_config_style = Snacks.config.style
    Snacks.config.style = function(name, defaults)
      local result = orig_config_style(name, defaults)
      if name == "snacks_image" then
        local s = Snacks.config.styles.snacks_image
        if s then s.row = nil; s.col = nil end
      end
      return result
    end
    local style = Snacks.config.styles.snacks_image
    if style then style.row = nil; style.col = nil end

    -- [Patch 2] Float content+border が親ウィンドウに収まるよう制約
    local Win = require("snacks.win")
    local orig_dim = Win.dim
    function Win:dim(parent)
      if self.opts.relative == "win" then
        parent = parent or self:parent_size()
        local border = self:border_size()
        local saved_max_w, saved_max_h = self.opts.max_width, self.opts.max_height
        self.opts.max_width = math.min(saved_max_w or parent.width, parent.width - border.left - border.right)
        self.opts.max_height = math.min(saved_max_h or parent.height, parent.height - border.top - border.bottom)
        local ret = orig_dim(self, parent)
        self.opts.max_width, self.opts.max_height = saved_max_w, saved_max_h
        return ret
      end
      return orig_dim(self, parent)
    end

    -- [Patch 3] render_fallback のカーソル位置修正
    -- nvim_win_get_position は relative="win" の float に不正な値を返す
    -- 親ウィンドウの絶対座標 + float の相対オフセットから正しい位置を計算する
    local ok_p, placement = pcall(require, "snacks.image.placement")
    local ok_t, terminal = pcall(require, "snacks.image.terminal")
    if ok_p and ok_t and placement and placement.render_fallback then
      local orig_render_fallback = placement.render_fallback
      function placement.render_fallback(self, state)
        -- カーソル位置補正値を計算
        local row_fix, col_fix = 0, 0
        for _, wid in ipairs(state.wins) do
          if vim.api.nvim_win_is_valid(wid) then
            local cfg = vim.api.nvim_win_get_config(wid)
            if cfg.relative == "win" and cfg.win and vim.api.nvim_win_is_valid(cfg.win) then
              local parent_pos = vim.api.nvim_win_get_position(cfg.win)
              local wrong_pos = vim.api.nvim_win_get_position(wid)
              col_fix = (parent_pos[2] + (cfg.col or 0)) - wrong_pos[2]
              row_fix = (parent_pos[1] + (cfg.row or 0)) - wrong_pos[1]
            end
          end
        end

        -- 補正値がある場合、terminal.set_cursor を一時的にラップ
        if col_fix ~= 0 or row_fix ~= 0 then
          local orig_set_cursor = terminal.set_cursor
          terminal.set_cursor = function(pos)
            orig_set_cursor({ pos[1] + row_fix, pos[2] + col_fix })
          end
          local result = orig_render_fallback(self, state)
          terminal.set_cursor = orig_set_cursor
          return result
        end

        return orig_render_fallback(self, state)
      end
    end
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
