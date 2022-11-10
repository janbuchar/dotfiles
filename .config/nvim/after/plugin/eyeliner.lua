eyeliner = require("eyeliner")
eyeliner.disable() -- eyeliner gets autoconfigured by vim-plug somehow - we need to disable it before changing config

eyeliner.setup {
  highlight_on_key = true
}

eyeliner.enable()

vim.api.nvim_set_hl(0, "EyelinerPrimary", {bold = true, underline = true})
vim.api.nvim_set_hl(0, "EyelinerSecondary", {underline = true})
