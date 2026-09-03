--- @sync entry
return {
  entry = function()
    local active = cx.active
    local current = active.current

    local esc = not active.mode.is_normal
      or #active.selected > 0
      or current.files.filter
      or current.cwd.spec.is_search
    ya.emit(esc and "escape" or "quit", {})
  end,
}
