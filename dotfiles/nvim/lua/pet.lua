
local M = {}

function M.search()
  if vim.fn.executable("pet") ~= 1 then
    vim.notify("pet not found", vim.log.levels.ERROR)
    return
  end

  local source_win = vim.api.nvim_get_current_win()
  local source_buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(source_win)
  local outfile = vim.fn.tempname()

  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.6)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  })

  vim.bo[buf].bufhidden = "wipe"

  vim.fn.termopen({
    "sh", "-c",
    "pet search > " .. vim.fn.shellescape(outfile)
  }, {
    on_exit = function(_, code)
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end

        local lines = {}

        if vim.fn.filereadable(outfile) == 1 then
          lines = vim.fn.readfile(outfile)
        end

        vim.fn.delete(outfile)

        if vim.api.nvim_win_is_valid(source_win) then
          vim.api.nvim_set_current_win(source_win)
        end

        if code ~= 0 or #lines == 0 then
          return
        end

        if vim.api.nvim_buf_is_valid(source_buf) then
          vim.api.nvim_buf_set_lines(
            source_buf,
            cursor[1],
            cursor[1],
            false,
            lines
          )
        end
      end)
    end,
  })

  vim.cmd("startinsert")
end

return M
