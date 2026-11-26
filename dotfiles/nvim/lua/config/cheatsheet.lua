
local M = {}

function M.open()
  -- 表示するコマンド一覧（手動で管理）
  local lines = {
    "",
    "  [ Pet ]",
    "  <leader>ps    Open snippet list",
    "",
    "  [ Telescope / Search ]",
    "  <leader>ff    Find files",
    "  <leader>fg    Live grep",
    "  <leader>fb    Find buffers",
    "  <leader>fh    Search help tags",
    "  <leader>fd    Find files in a directory",
    "  <leader>fm    Find files in multiple directories",
    "",
    "      [ Multi-directory browser (fm) ]",
    "      Enter         Open directory",
    "      Ctrl-a        Add current directory",
    "      Ctrl-f        Search selected directories",
    "      Ctrl-l        List selected directories",
    "      Ctrl-r        Clear selected directories",
    "",
    "      [ Buffer picker (fb) ]",
    "      Ctrl-d        Delete selected buffer (i/n)",
    "      dd            Delete selected buffer (n)",
    "",
    "  [ Editing ]",
    "  ga            EasyAlign (n/x)",
    "  Tab           Expand snippet / jump forward (i/s)",
    "  Shift-Tab     Jump backward (i/s)",
    "",
    "  [ Terminal ]",
    "  Ctrl-\\       Toggle terminal",
    "",
    "  [ LaTeX ]",
    "  <leader>ll    Toggle LaTeX compilation",
    "",
    "  [ Maintenance ]",
    "  :Telescope    Open Telescope command",
    "  :TSUpdate     Update Treesitter parsers",
    ""
  }

  -- 一時バッファを作成
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  -- ウィンドウサイズ
  local width = math.min(60, vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 4)

  -- フローティングウィンドウを中央に表示
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " My Keymaps ",
    title_pos = "center",
    footer = " q / Esc : Close ",
    footer_pos = "center",
  })

  vim.wo[win].cursorline = false
  vim.wo[win].wrap = false

  -- q または Esc で閉じる
  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, function()
      vim.api.nvim_win_close(win, true)
    end, { buffer = buf, silent = true })
  end
end

return M

