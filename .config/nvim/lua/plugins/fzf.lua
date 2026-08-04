return {
  {
    "ibhagwan/fzf-lua",
    branch = "main",
    dependencies = { "willothy/nvim-cokeline" },
    enabled = not vim.g.vscode,
    config = function()
      local fzf = require("fzf-lua")
      local actions = require("fzf-lua.actions")
      local make_entry = require("fzf-lua.make_entry")
      local buffers = require("cokeline.buffers")
      local builtin_previewer = require("fzf-lua.previewer.builtin")

      fzf.setup({
        actions = {
          files = {
            ["enter"] = actions.file_edit,
          },
        },
      })

      _G.buffers = function(opts)
        local entries = {}
        local entry2element = {}

        -- Gather information about buffers
        for _, buffer in ipairs(buffers.get_visible()) do
          local element = {
            index = buffer.index,
            bufnr = buffer.number,
            file = fzf.path.relative_to(
              vim.api.nvim_buf_get_name(buffer.number),
              vim.uv.cwd()
            ),
            info = vim.fn.getbufinfo(buffer.number)[1],
          }
          local entry = ("[%d] %s"):format(buffer.index, element.file)
          table.insert(entries, entry)
          entry2element[entry] = element
        end

        -- Sort entries in MRU order
        table.sort(entries, function(a, b)
          return entry2element[a].info.lastused > entry2element[b].info.lastused
        end)

        opts = opts or {}
        opts = fzf.config.normalize_opts(opts, fzf.config.globals.buffers)

        local Previewer = builtin_previewer.buffer_or_file:extend()
        function Previewer:parse_entry(entry_str)
          local element = entry2element[entry_str]
          return fzf.path.entry_to_file(
            make_entry.file(("%s:%d"):format(element.file, element.info.lnum)),
            self.opts
          )
        end
        opts.previewer = Previewer

        opts.actions = {
          ["default"] = function(selected)
            vim.api.nvim_set_current_buf(entry2element[selected[1]].bufnr)
          end,
          ["ctrl-x"] = function(selected)
            Snacks.bufdelete(entry2element[selected[1]].bufnr)
          end,
        }

        fzf.fzf_exec(entries, opts)
      end

      -- Changed files relative to the base held in lua/gitbase.lua.
      -- Deliberately fzf-lua's *git_status* picker rather than its git_diff one:
      -- git_diff accepts a ref but renders bare filenames, whereas git_status'
      -- fn_transform is what draws the status letters, colours and devicons. It just
      -- insists on `git status --porcelain` input, which is what porcelain() below
      -- reshapes the store's records into. With the base at the index there is
      -- nothing to reconstruct, so the stock picker is handed the job untouched.
      --
      -- The `XY path` shape (renames spelled "old -> new") is required by fzf-lua.
      --- @param change GitBase.Change
      local function porcelain(change)
        local path = change.orig
            and ("%s -> %s"):format(change.orig, change.path)
          or change.path
        return ("%s%s %s"):format(change.x, change.y, path)
      end

      _G.git_changes = function()
        local gitbase = require("gitbase")
        if not gitbase.get() then
          return fzf.git_status()
        end

        fzf.git_status({
          -- A function rather than a table, so fzf-lua re-invokes it on `reload` and
          -- the stage/unstage/reset actions keep working. Lines must be delivered
          -- through the *table* callback: fn_transform, and hence every icon and
          -- colour, is applied to batches only, never to individually written lines.
          cmd = function(_, cb_lines)
            cb_lines(vim.tbl_map(porcelain, gitbase.changes() or {}))
            cb_lines(nil)
          end,
          -- fn_transform runs in-process; there is no external command to parallelise.
          multiprocess = false,
          -- Re-aim the diff preview at the base, or the pane contradicts the list it
          -- came from. Safe to interpolate unquoted: the base is always a bare SHA.
          previewer = vim.tbl_extend(
            "force",
            fzf.config.globals.previewers.git_diff,
            {
              cmd_modified = "git diff --color " .. gitbase.get(),
              cmd_deleted = "git diff --color " .. gitbase.get() .. " --",
            }
          ),

          prompt = ("%s❯ "):format(gitbase.name()),
        })
      end

      _G.macros = function(opts)
        opts = opts or {}
        opts.prompt = "Macros> "

        local entries = {}

        local get_macro = function(reg)
          return vim.api.nvim_replace_termcodes(
            vim.fn.keytrans(vim.fn.getreg(reg)),
            true,
            true,
            true
          )
        end

        for i = 97, 122 do
          table.insert(
            entries,
            ("[%s] %s"):format(string.char(i), get_macro(string.char(i)))
          )
        end

        fzf.fzf_exec(entries, opts)
      end
    end,
  },
}
