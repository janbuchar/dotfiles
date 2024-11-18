local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "nord"
config.window_background_opacity = 0.97
config.enable_tab_bar = false

config.font = wezterm.font("Fira Code")
config.font_size = 9
config.line_height = 1.1
config.freetype_load_target = "Light"

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

wezterm.on("window-resized", function(window, pane)
  local overrides = window:get_config_overrides() or {}

  local tabsz = window:active_tab():get_size()
  local cellheight = tabsz.pixel_height / tabsz.rows
  local cellwidth = tabsz.pixel_width / tabsz.cols

  local window_height = window:get_dimensions().pixel_height
  local pane_height = (window_height // cellheight) * cellheight

  local window_width = window:get_dimensions().pixel_width
  local pane_width = (window_width // cellwidth) * cellwidth

  local new_padding = {
    left = (window_width - pane_width) / 2,
    right = 0,
    top = (window_height - pane_height) / 2,
    bottom = 0,
  }

  if
    not overrides.window_padding
    or new_padding.top ~= overrides.window_padding.top
    or new_padding.left ~= overrides.window_padding.left
  then
    overrides.window_padding = new_padding
    window:set_config_overrides(overrides)
  end
end)

return config
