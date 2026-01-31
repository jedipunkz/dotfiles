return {
  {
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      -- NES (Next Edit Suggestion) のデバウンス時間
      vim.g.copilot_nes_debounce = 500

      -- copilot LSP を有効化
      vim.lsp.enable("copilot_ls")

      -- Tab キーで NES 補完を受け入れる
      vim.keymap.set("n", "<tab>", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local state = vim.b[bufnr].nes_state
        if state then
          -- サジェストの開始位置にジャンプを試みる
          -- すでに開始位置にいる場合は、サジェストを適用して編集の終了位置にジャンプ
          local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
            or (
              require("copilot-lsp.nes").apply_pending_nes()
              and require("copilot-lsp.nes").walk_cursor_end_edit()
            )
          return nil
        else
          -- NES がない場合は通常の <C-i> (ジャンプリスト) として動作
          return "<C-i>"
        end
      end, { desc = "Accept Copilot NES suggestion", expr = true })

      -- Insert モードでも Tab で補完を受け入れる
      vim.keymap.set("i", "<tab>", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local state = vim.b[bufnr].nes_state
        if state then
          local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
            or (
              require("copilot-lsp.nes").apply_pending_nes()
              and require("copilot-lsp.nes").walk_cursor_end_edit()
            )
          return nil
        else
          -- NES がない場合は通常のタブ文字を挿入
          return "<tab>"
        end
      end, { desc = "Accept Copilot NES suggestion", expr = true })

      -- Escape でサジェストをクリア
      vim.keymap.set("n", "<esc>", function()
        if not require("copilot-lsp.nes").clear() then
          -- サジェストがない場合は通常の Escape 動作 (ハイライトクリアなど)
          vim.cmd("nohlsearch")
        end
      end, { desc = "Clear Copilot suggestion or fallback" })
    end,
  },
}
