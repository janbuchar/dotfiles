return {
  {
    "ibhagwan/fzf-lua",
    branch = "main",
    dependencies = {"willothy/nvim-cokeline", "famiu/bufdelete.nvim"},
    config = function()
      local fzf = require("fzf-lua")
      local make_entry = require("fzf-lua.make_entry")
      local buffers = require("cokeline.buffers")
      local builtin_previewer = require("fzf-lua.previewer.builtin")
      local bufdelete = require("bufdelete")

      _G.buffers = function(opts)
        local entries = {}
        local entry2element = {}

        -- Gather information about buffers
        for _, buffer in ipairs(buffers.get_visible()) do
          local element = {
            index = buffer.index,
            bufnr = buffer.number,
            file = fzf.path.relative_to(vim.api.nvim_buf_get_name(buffer.number), vim.loop.cwd()),
            info = vim.fn.getbufinfo(buffer.number)[1]
          }
          local entry = ("[%d] %s"):format(buffer.index, element.file)
          table.insert(entries, entry)
          entry2element[entry] = element
        end

        -- Sort entries in MRU order
        table.sort(
          entries,
          function(a, b)
            return entry2element[a].info.lastused > entry2element[b].info.lastused
          end
        )

        opts = opts or {}
        opts = fzf.config.normalize_opts(opts, fzf.config.globals.buffers)

        local Previewer = builtin_previewer.buffer_or_file:extend()
        function Previewer:parse_entry(entry_str)
          local element = entry2element[entry_str]
          return fzf.path.entry_to_file(make_entry.file(("%s:%d"):format(element.file, element.info.lnum)), self.opts)
        end
        opts.previewer = Previewer

        opts.actions = {
          ["default"] = function(selected)
            vim.api.nvim_set_current_buf(entry2element[selected[1]].bufnr)
          end,
          ["ctrl-x"] = function(selected)
            bufdelete.bufdelete(entry2element[selected[1]].bufnr)
          end
        }

        fzf.fzf_exec(entries, opts)
      end

      _G.macros = function(opts)
        opts = opts or {}
        opts.prompt = "Macros> "

        local entries = {}

        local get_macro = function(reg)
          return vim.api.nvim_replace_termcodes(vim.fn.keytrans(vim.fn.getreg(reg)), true, true, true)
        end

        for i = 97, 122 do
          table.insert(entries, ("[%s] %s"):format(string.char(i), get_macro(string.char(i))))
        end

        fzf.fzf_exec(entries, opts)
      end
    end
  }
}
