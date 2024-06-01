return {
  {
    "willothy/nvim-cokeline",
    config = function()
      local theme_name = require("lualine").get_config().options.theme
      local theme = require("lualine.themes." .. theme_name)
      local Color = require("nightfox.lib.color")

      local buffers = require("cokeline.buffers")
      local compute_unique_prefixes = buffers.compute_unique_prefixes

      buffers.compute_unique_prefixes = function(buffer_names)
        -- TODO shrink the prefixes
        return compute_unique_prefixes(buffer_names)
      end

      require("cokeline").setup({
        components = {
          {
            text = function(buffer)
              return " " .. buffer.index
            end,
            bold = true,
          },
          {
            text = function(buffer)
              return " " .. buffer.unique_prefix
            end,
            fg = function(buffer)
              return buffer.is_focused and theme.normal.a.fg
                or Color.from_hex(theme.normal.b.fg)
                  :blend(Color.from_hex(theme.normal.c.bg), 0.3)
                  :to_css()
            end,
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
              if #status > 0 then
                status = status .. " "
              end
              return buffer.filename .. " " .. status
            end,
          },
        },
        default_hl = {
          bg = function(buffer)
            return buffer.is_focused and theme.normal.a.bg or theme.normal.c.bg
          end,
          fg = function(buffer)
            return buffer.is_focused and theme.normal.a.fg or theme.normal.b.fg
          end,
          bold = function(buffer)
            return buffer.is_focused
          end,
        },
      })

      vim.api.nvim_set_hl(0, "TabLineFill", { bg = theme.normal.b.bg })
    end,
  },
}
