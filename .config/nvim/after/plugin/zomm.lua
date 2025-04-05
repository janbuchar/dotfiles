local config = {
  width = 140,
  side = "center",
}

local default_state = {
  side = "center",
  tabpage = nil,
  code_win = nil,
  backdrop_buf = nil,
  backdrop_win = nil,
}

local state = vim.tbl_deep_extend("keep", {}, default_state)

local calculate_zomm_geometry = function()
  local ui = vim.api.nvim_list_uis()[1]

  local padding = ui.width / 2 - config.width / 2
  local col = (function()
    if state.side == "left" then
      return 0
    end
    if state.side == "right" then
      return 2 * padding
    end
    if state.side == "center" then
      return padding
    end
  end)()

  return {
    width = config.width,
    height = ui.height - 2,
    col = col,
    row = 1,
  }
end

local zomm = function(opts)
  -- Apply option for side if provided
  local side = opts.args
  if not (side == "left" or side == "right" or side == "center") then
    side = config.side
  end

  state.side = side

  local code_buf = vim.api.nvim_get_current_buf()

  vim.cmd("tabnew")
  state.tabpage = vim.api.nvim_get_current_tabpage()
  state.backdrop_win = vim.api.nvim_get_current_win()
  state.backdrop_buf = vim.api.nvim_get_current_buf()

  vim.wo[state.backdrop_win].number = false
  vim.wo[state.backdrop_win].relativenumber = false
  vim.wo[state.backdrop_win].cursorline = false
  vim.bo[state.backdrop_buf].buflisted = false

  local geometry = calculate_zomm_geometry()

  state.code_win = vim.api.nvim_open_win(code_buf, true, {
    relative = "editor",
    width = geometry.width,
    height = geometry.height,
    col = geometry.col,
    row = geometry.row,
    anchor = "NW",
  })

  vim.wo[state.code_win].winhl = "Normal:Normal,FloatBorder:Normal"
end

local unzomm = function()
  local tabpage = state.tabpage
  if tabpage ~= nil then
    state = vim.tbl_deep_extend("keep", {}, default_state)
    pcall(vim.cmd("tabclose " .. tostring(tabpage)))
  end
end

local setup = function()
  -- When the code window is closed, close the tabpage
  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
      if tonumber(args.match) == state.code_win then
        unzomm()
      end
    end,
  })

  -- When the backdrop window is entered, switch focus back to the code window
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

  -- Close the tabpage before exitting
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      unzomm()
    end,
  })

  vim.api.nvim_create_user_command("Zomm", zomm, {
    nargs = "?",
    complete = function(_, _, _)
      return { "left", "center", "right" }
    end,
    desc = "Open current buffer in a zoomed window (optional position: left, center, right)",
  })
end

setup()

-- TODO aerial?
-- TODO handle resizing
