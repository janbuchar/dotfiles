local autotag = require("nvim-ts-autotag")
autotag.setup()

local remap = vim.api.nvim_set_keymap
local npairs = require("nvim-autopairs")

npairs.setup({})

_G.MUtils = {}

MUtils.completion_confirm = function()
  return npairs.autopairs_cr()
end

remap("i", "<CR>", "v:lua.MUtils.completion_confirm()", {expr = true, noremap = true})
