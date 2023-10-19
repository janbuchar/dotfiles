local theme_name = require("lualine").get_config().options.theme
local theme = require("lualine.themes." .. theme_name)

local buffers = require("cokeline.buffers")
local compute_unique_prefixes = buffers.compute_unique_prefixes

buffers.compute_unique_prefixes = function(buffers)
  -- TODO shrink the prefixes
  return compute_unique_prefixes(buffers)
end

require("cokeline").setup(
  {
    components = {
      {
        text = function(buffer)
          return " " .. buffer.index
        end
      },
      {
        text = function(buffer)
          return " " .. buffer.unique_prefix
        end
      },
      {
        text = function(buffer)
          return buffer.filename .. " "
        end
      },
      {
        text = function(buffer)
          local status = ""
          if buffer.is_modified then
            status = status .. "[+]"
          end
          if buffer.is_readonly then
            status = status .. "[-]"
          end
          return status .. " "
        end
      }
    },
    default_hl = {
      bg = function(buffer)
        return buffer.is_focused and theme.normal.a.bg or theme.normal.b.bg
      end,
      fg = function(buffer)
        return buffer.is_focused and theme.normal.a.fg or theme.normal.b.fg
      end,
      bold = function(buffer)
        return buffer.is_focused
      end
    }
  }
)

vim.api.nvim_set_hl(0, "TabLineFill", {bg = theme.normal.c.bg})
