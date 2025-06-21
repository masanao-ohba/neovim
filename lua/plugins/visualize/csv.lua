return {
  "chrisbra/csv.vim",
  ft = { "csv" },  -- CSVファイルのときだけ読み込み
  config = function()
    -- デリミタの設定
    vim.g.csv_delim = ','

    -- ファイル読み込み・ウィンドウ表示時に整列
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
      pattern = "*.csv",
      callback = function()
        local ok, _ = pcall(vim.cmd, "%ArrangeColumn")
        if not ok then
          print("ArrangeColumn command failed to execute. Check csv.vim plugin.")
        else
          print("ArrangeColumn executed successfully.")
        end

        -- 現在の列をハイライトする設定
        vim.g.csv_highlight_column = 'y'
      end,
    })

    -- 保存時に整形を解除
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.csv",
      callback = function()
        local ok, _ = pcall(vim.cmd, "%CSVUnArrange")
        if not ok then
          print("CSVUnArrange command failed to execute. Check csv.vim plugin.")
        else
          print("CSVUnArrange executed successfully.")
        end
      end,
    })
  end
}
