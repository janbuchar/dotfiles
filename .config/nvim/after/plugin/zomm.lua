local config = {
  width = 140,
  side = "center",
}

local default_state = {
  tabpage = nil,
  code_win = nil,
  backdrop_buf = nil,
  backdrop_win = nil,
}

local state = vim.tbl_deep_extend("keep", {}, default_state)

local zomm = function(opts)
  local code_buf = vim.api.nvim_get_current_buf()
  local ui = vim.api.nvim_list_uis()[1]

  -- Apply option for side if provided
  local side = opts.args
  if not (side == "left" or side == "right" or side == "center") then
    side = config.side
  end

  vim.cmd("tabnew")
  state.tabpage = vim.api.nvim_get_current_tabpage()
  state.backdrop_win = vim.api.nvim_get_current_win()
  state.backdrop_buf = vim.api.nvim_get_current_buf()

  vim.wo[state.backdrop_win].number = false
  vim.wo[state.backdrop_win].relativenumber = false
  vim.wo[state.backdrop_win].cursorline = false
  vim.bo[state.backdrop_buf].buflisted = false

  local padding = ui.width / 2 - config.width / 2
  local col = (function()
    if side == "left" then
      return 0
    end
    if side == "right" then
      return 2 * padding
    end
    if side == "center" then
      return padding
    end
  end)()

  state.code_win = vim.api.nvim_open_win(code_buf, true, {
    relative = "editor",
    width = config.width,
    height = ui.height - 2,
    col = col,
    row = 1,
    anchor = "NW",
  })

  vim.wo[state.code_win].winhl = "Normal:Normal,FloatBorder:Normal"
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(args)
    if tonumber(args.match) == state.code_win then
      local tabpage = state.tabpage
      if tabpage ~= nil then
        state = vim.tbl_deep_extend("keep", {}, default_state)
        vim.cmd("tabclose " .. tostring(tabpage))
      end
    end
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  callback = function(args)
    if
      state.backdrop_win ~= nil
      and vim.api.nvim_get_current_win() == state.backdrop_win
      and state.code_win ~= nil
    then
      vim.api.nvim_set_current_win(state.code_win)
    end
  end,
})

vim.api.nvim_create_user_command("Zomm", zomm, {
  nargs = "?",
  complete = function(_, _, _)
    return { "left", "center", "right" }
  end,
  desc = "Open current buffer in a zoomed window (optional position: left, center, right)",
})
