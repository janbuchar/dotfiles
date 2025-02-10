--- @sync entry
return {
  entry = function()
    local active = cx.active
    local current = active.current

    local esc = active.mode.is_visual
      or #active.selected > 0
      or current.files.filter
      or current.cwd.is_search
    ya.manager_emit(esc and "escape" or "quit", {})
  end,
}
