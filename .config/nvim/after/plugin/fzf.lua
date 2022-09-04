local fzf = require("fzf-lua")
local fzf_actions = require("fzf-lua.actions")
local make_entry = require("fzf-lua.make_entry")
local buffers = require("lualine.components.buffers")
local builtin_previewer = require("fzf-lua.previewer.builtin")
local bufdelete = require("bufdelete")

fzf.setup {}

_G.buffers = function(opts)
  local entries = {}
  local entry2element = {}

  -- Bail out if lualine buffers are not initialized
  if buffers.bufpos2nr == nil then
    return
  end

  -- Gather information about buffers
  for index, bufnr in ipairs(buffers.bufpos2nr) do
    local element = {
      index = index,
      bufnr = bufnr,
      file = fzf.path.relative(vim.api.nvim_buf_get_name(bufnr), vim.loop.cwd()),
      info = vim.fn.getbufinfo(bufnr)[1]
    }
    local entry = ("[%d] %s"):format(index, element.file)
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
