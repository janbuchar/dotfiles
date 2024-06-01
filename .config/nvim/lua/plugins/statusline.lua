local function recording_status()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "REC @" .. reg .. ""
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        theme = "nord",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              if str == "V-BLOCK" then
                return "VB"
              elseif str == "V-LINE" then
                return "VL"
              else
                return str:sub(1, 1)
              end
            end,
          },
        },
        lualine_b = { { "filename", path = 1 }, "diff" },
        lualine_c = { recording_status },
        lualine_x = { "diagnostics" },
        lualine_y = { "encoding", "filetype", "progress" },
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { { "filename", path = 1 }, "diff" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
}
