local saga = require "lspsaga"

saga.init_lsp_saga {
  use_saga_diagnostic_sign = false,
  code_action_prompt = {
    enable = false
  },
  error_sign = "",
  warn_sign = "",
  infor_sign = "",
  hint_sign = "",
  border_style = "round",
  diagnostic_header_icon = "",
  code_action_icon = "",
  finder_definition_icon = "",
  finder_reference_icon = "",
  definition_preview_icon = ""
}
