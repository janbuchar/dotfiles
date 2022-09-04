require("lualine").setup {
  options = {
    icons_enabled = false,
    theme = "auto",
    component_separators = {left = "", right = ""},
    section_separators = {left = "", right = ""},
    disabled_filetypes = {
      statusline = {},
      winbar = {}
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000
    }
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
        end
      }
    },
    lualine_b = {{"filename", path = 1}, "diff"},
    lualine_c = {},
    lualine_x = {"diagnostics"},
    lualine_y = {"encoding", "filetype", "progress"},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {{"filename", path = 1}, "diff"},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_b = {
      {
        "buffers",
        mode = 2,
        symbols = {modified = " +", alternate_file = "", directory = ""},
        max_length = vim.o.columns,
        buffers_color = {
          active = "lualine_a_normal",
          inactive = "lualine_c_normal"
        }
      }
    }
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
