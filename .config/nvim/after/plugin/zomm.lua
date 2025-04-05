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
  aerial_width = 0,
}

local state = vim.tbl_deep_extend("keep", {}, default_state)

local calculate_zomm_geometry = function()
  local ui = vim.api.nvim_list_uis()[1]

  local width = config.width
  local padding = (ui.width - width) / 2

  local col = (function()
    if state.side == "left" then
      return 0
    end
    if state.side == "right" then
      return math.floor(padding)
    end
    if state.side == "center" then
      return padding
    end
  end)()

  local final_width = (function()
    if state.side == "center" then
      return width
    end
    if state.side == "right" then
      return width + math.ceil(padding) - state.aerial_width
    end

    return width + math.ceil(padding)
  end)()

  return {
    width = final_width,
    height = ui.height - 2,
    col = col,
    row = 1,
  }
end

local set_background = function()
  if
    state.code_win ~= nil
    and vim.api.nvim_win_is_valid(state.code_win)
    and vim.api.nvim_get_current_win() == state.code_win
  then
    vim.api.nvim_set_option_value(
      "winhl",
      "Normal:Normal,FloatBorder:Normal",
      { scope = "local", win = state.code_win }
    )
  end
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
  state.backdrop_win = vim.api.nvim_tabpage_list_wins(state.tabpage)[1]
  state.backdrop_buf = vim.api.nvim_win_get_buf(state.backdrop_win)

  if
    state.backdrop_win ~= nil and vim.api.nvim_win_is_valid(state.backdrop_win)
  then
    vim.api.nvim_set_option_value(
      "number",
      false,
      { scope = "local", win = state.backdrop_win }
    )
    vim.api.nvim_set_option_value(
      "relativenumber",
      false,
      { scope = "local", win = state.backdrop_win }
    )
    vim.api.nvim_set_option_value(
      "cursorline",
      false,
      { scope = "local", win = state.backdrop_win }
    )
  end

  vim.api.nvim_set_option_value(
    "buflisted",
    false,
    { scope = "local", buf = state.backdrop_buf }
  )

  local geometry = calculate_zomm_geometry()

  state.code_win = vim.api.nvim_open_win(code_buf, true, {
    relative = "editor",
    width = geometry.width,
    height = geometry.height,
    col = geometry.col,
    row = geometry.row,
    anchor = "NW",
    zindex = 40,
  })

  set_background()
end

local unzomm = function()
  local tabpage = state.tabpage
  if tabpage ~= nil and vim.api.nvim_tabpage_is_valid(tabpage) then
    state = vim.tbl_deep_extend("keep", {}, default_state)
    pcall(
      vim.cmd("tabclose " .. tostring(vim.api.nvim_tabpage_get_number(tabpage)))
    )
  end
end

local function resize()
  if state.code_win and vim.api.nvim_win_is_valid(state.code_win) then
    local geometry = calculate_zomm_geometry()
    vim.api.nvim_win_set_config(state.code_win, {
      relative = "editor",
      width = geometry.width,
      height = geometry.height,
      col = geometry.col,
      row = geometry.row,
      anchor = "NW",
      zindex = 40,
    })
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

  -- Maintain window highlight when buffer changes in code_win
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    callback = set_background,
  })

  -- Close the tabpage before exitting
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      unzomm()
    end,
  })

  -- Adjust window dimensions when terminal is resized
  vim.api.nvim_create_autocmd("VimResized", {
    callback = resize,
  })

  -- Detect when aerial opens and shrink the code window
  vim.api.nvim_create_autocmd({ "WinEnter", "WinClosed" }, {
    callback = function()
      vim.defer_fn(function()
        local aerial_util = require("aerial.util")

        if require("aerial.window").is_open({ winid = state.code_win }) then
          state.aerial_width = vim.api.nvim_win_get_width(
            aerial_util.get_aerial_win(state.code_win)
          ) + 1
        else
          state.aerial_width = 0
        end
        resize()
      end, 100)
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
