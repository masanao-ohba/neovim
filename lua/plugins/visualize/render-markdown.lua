return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    enabled = true,
    render_modes = { "n", "c", "t" },
    debounce = 100,
    max_file_size = 10.0,
    win_options = {
      conceallevel = { default = vim.o.conceallevel, rendered = 3 },
      concealcursor = { default = vim.o.concealcursor, rendered = "" },
    },
    code = {
      border = "none",
      sign = true,
      style = 'full',
      language_icon = true,
      language_name = true,
      language_pad = 2,
      width = 'block',
      left_pad = 2,
      right_pad = 2,
      inline_pad = 1,
      highlight = 'RenderMarkdownCode',
    },
    heading = {
      enabled = true,
      above = '▄',
      atx = true,
      below = '▀',
      border = false,
      border_prefix = false,
      border_virtual = true,
      icons = '',
      left_margin = 0,
      left_pad = 0,
      min_width = 0,
      position = 'overlay',
      render_modes = false,
      right_pad = { 2, 2, 2, 2, 2, 2 },
      setext = true,
      sign = true,
      signs = { '󰫎 ' },
      width = 'block',
      backgrounds = {
        'RenderMarkdownH1Bg',
        'RenderMarkdownH2Bg',
        'RenderMarkdownH3Bg',
        'RenderMarkdownH4Bg',
        'RenderMarkdownH5Bg',
        'RenderMarkdownH6Bg',
      },
      foregrounds = {
        'RenderMarkdownH1',
        'RenderMarkdownH2',
        'RenderMarkdownH3',
        'RenderMarkdownH4',
        'RenderMarkdownH5',
        'RenderMarkdownH6',
      },
      custom = {},
    },
    dash = {
      enabled = true,
      render_modes = false,
      icon = '─',
      width = 'full',
      left_margin = 0,
      highlight = 'RenderMarkdownDash',
    },
    bullet = {
      enabled = true,
      render_modes = false,
      icons = { '●', '○', '◆', '◇' },
      ordered_icons = function(ctx)
        local value = vim.trim(ctx.value)
        local index = tonumber(value:sub(1, #value - 1))
        return ('%d.'):format(index > 1 and index or ctx.index)
      end,
      left_pad = 0,
      right_pad = 0,
      highlight = 'RenderMarkdownBullet',
      scope_highlight = {},
    },
    checkbox = {
      checked = { scope_highlight = "@markup.strikethrough" },
      custom = {
        -- デフォルトの`[-]`であるtodoは削除
        todo = { raw = "", rendered = "", highlight = "" },
        canceled = {
          raw = "[-]",
          rendered = "󱘹",
          scope_highlight = "@markup.strikethrough",
        },
      },
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)

    -- HEX → RGB
    local function hex_to_rgb(hex)
      hex = hex:gsub("#", "")
      return tonumber("0x"..hex:sub(1,2)),
      tonumber("0x"..hex:sub(3,4)),
      tonumber("0x"..hex:sub(5,6))
    end

    -- RGB → HEX
    local function rgb_to_hex(r, g, b)
      return string.format("#%02x%02x%02x", r, g, b)
    end

    -- アルファブレンド（fg over bg）
    local function alpha_blend(fg, bg, alpha)
      local r1, g1, b1 = hex_to_rgb(fg)
      local r2, g2, b2 = hex_to_rgb(bg)
      local blend = function(a, b)
        return math.floor((alpha * a) + ((1 - alpha) * b) + 0.5)
      end
      return rgb_to_hex(blend(r1, r2), blend(g1, g2), blend(b1, b2))
    end

    -- 色定義
    local base_bg = "#002030"
    local alpha = 0.50
    local hl = vim.api.nvim_set_hl

    local colors = {
      H1 = "#008cff",  -- 鮮やかで明るい赤
      H2 = "#339be3",  -- 明るい橙
      H3 = "#66a8c7",  -- 明るい黄土
      H4 = "#99b28c",  -- 明るい緑
      H5 = "#cc9b40",  -- 明るい青緑
      H6 = "#ff8700",  -- 明るい青
    }

    local fg_colors = {
      H1 = "#f0f0f0",
      H2 = "#f0f0f0",
      H3 = "#f0f0f0",
      H4 = "#f0f0f0",
      H5 = "#f0f0f0",
      H6 = "#f0f0f0",
    }

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        for i = 1, 6 do
          local key = "H" .. i
          local bg_blend = alpha_blend(colors[key], base_bg, alpha)

          hl(0, "RenderMarkdown" .. key .. "Bg", {
            bg = bg_blend,
            fg = fg_colors[key],
            underline = true,
          })

          hl(0, "RenderMarkdown" .. key, {
            fg = fg_colors[key],
            bold = (i <= 4),
          })
        end
      end,
    })

    vim.cmd("doautocmd ColorScheme")

    vim.keymap.set("n", "<leader>mr", require("render-markdown").toggle, { desc = "Toggle Render Markdown" })
  end,
}
