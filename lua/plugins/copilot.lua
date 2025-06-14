return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  config = function()
    require("copilot").setup({
      -- suggestion = {enabled = false},
      -- panel = {enabled = false},
      -- copilot_node_command = 'node'

      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<S-]>",
          prev = "<S-[>",
          dismiss = "<C-c>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },

      filetypes = {
        markdown = true,
        gitcommit = true,
        ['*'] = function()
          -- disable for files with specific names
          local fname = vim.fs.basename(vim.api.nvim_buf_get_name(0))
          local disable_patterns = { 'env', 'conf', 'local', 'private' }
          return vim.iter(disable_patterns):all(function(pattern)
            return not string.match(fname, pattern)
          end)
        end,
      },

    })
  end,
}
