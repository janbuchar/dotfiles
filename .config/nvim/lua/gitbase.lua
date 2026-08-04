-- Single source of truth for "the base I am working against".
--
-- Stores a ref the way you typed it ("main", "origin/develop") and resolves it to
-- the *fork point* -- `git merge-base <ref> HEAD` -- not to the ref's tip. That
-- distinction is the entire point: with the base set to `main`, every commit that
-- lands on main after you branched shows up in your gutter as lines *you deleted*.
-- The merge base is immune to that.
--
-- Deliberately knows nothing about any plugin. It announces changes by firing
-- `User GitBaseChanged` (data: `{ base = <sha?>, ref = <name?> }`), and consumers
-- subscribe from their own setup files:
--
--   * lua/plugins/git.lua -- pushes the base into gitsigns (and so into difftsigns),
--                            and asks us to re-resolve when it sees HEAD move
--   * lua/plugins/fzf.lua -- _G.git_changes(), the picker bound to <leader>m
--
-- Corollary: switch the base with `:GitBase`, never with `Gitsigns change_base`.
-- The latter writes gitsigns' copy without telling us, and the two then disagree
-- silently -- precisely the drift this module exists to prevent.

local M = {}

--- Ref as the user gave it. nil means the index, i.e. gitsigns' default.
local ref = nil
--- Commit that `ref` currently resolves to. Recomputed by M.refresh().
local resolved = nil

--- Run git, in `cwd` or the editor's. Trimmed stdout, or nil on failure/no output.
local function git(args, cwd)
  local res = vim.system(vim.list_extend({ "git" }, args), {
    text = true,
    cwd = cwd or vim.fn.getcwd(),
  }):wait()
  local out = res.code == 0 and vim.trim(res.stdout or "") or ""
  return out ~= "" and out or nil
end

--- Fork point of `r` and HEAD. Falls back to the ref's own tip when there is no
--- common ancestor -- shallow clones, grafted or unrelated histories. That is a
--- different comparison, not an equivalent one, but it beats showing nothing.
local function fork_point(r)
  return git({ "merge-base", "HEAD", r }) or git({ "rev-parse", "--verify", r })
end

--- Announce the current base. Consumers subscribe to the event rather than being
--- called directly, so this module needs no knowledge of them and they stay free to
--- load whenever they like.
local function announce()
  vim.api.nvim_exec_autocmds("User", {
    pattern = "GitBaseChanged",
    modeline = false,
    data = { base = resolved, ref = ref },
  })
end

--- Best guess at this repo's integration branch, for `:GitBase` with no argument.
--- origin/HEAD is the correct answer but is often simply absent: it gets written by
--- a fresh clone or an explicit `git remote set-head origin -a`, and by nothing else.
function M.default_ref()
  local remote_head = git({ "rev-parse", "--abbrev-ref", "origin/HEAD" })
  if remote_head then
    return remote_head
  end
  for _, name in ipairs({ "main", "master" }) do
    if git({ "rev-parse", "--verify", "--quiet", name }) then
      return name
    end
  end
end

--- Set the base, or reset to the index when `r` is nil. Resolves before storing, so
--- a typo leaves the old base intact instead of silently dropping you to the index.
function M.set(r)
  if r == nil or r == "" then
    ref, resolved = nil, nil
    announce()
    vim.notify("git base: index")
    return true
  end

  local point = fork_point(r)
  if not point then
    vim.notify(("git base: cannot resolve '%s'"):format(r), vim.log.levels.ERROR)
    return false
  end

  ref, resolved = r, point
  announce()
  vim.notify(("git base: %s (%s)"):format(r, point:sub(1, 8)))
  return true
end

--- Re-resolve the stored ref, announcing only if the fork point actually moved.
--- Call this whenever HEAD may have changed: the stored ref is stable, but the
--- commit it forks from is not -- rebase, or switch branches, and yesterday's merge
--- base is a commit you never branched from.
function M.refresh()
  if not ref then
    return
  end
  local point = fork_point(ref)
  if not point or point == resolved then
    return
  end
  resolved = point
  announce()
end

--- Commit the base resolves to, or nil for the index.
function M.get()
  return resolved
end

--- The ref as typed, for display purposes. nil for the index.
function M.name()
  return ref
end

--- @class GitBase.Change
--- @field x string Status of base->index: this branch's commits, plus whatever is staged
--- @field y string Status of index->worktree: unstaged edits. " " when unchanged
--- @field path string Path, relative to the repo root
--- @field orig string? Previous path, when the change is a rename

--- The working tree as it stands relative to the base, sorted by path, or nil when
--- the base is the index.
---
--- `git status` cannot be given a base, so this reconstructs what it would report if
--- it could: X is base->index, Y is index->worktree -- precisely porcelain's own
--- split, with the base substituted for HEAD. Untracked files are folded in from
--- ls-files, because `git diff` has no concept of them.
--- @return GitBase.Change[]?
function M.changes()
  if not resolved then
    return nil
  end

  -- Run from the repo root so every path is root-relative. From a subdirectory,
  -- `ls-files --others` would otherwise both scope itself to that subdirectory and
  -- print paths relative to it.
  local cwd = git({ "rev-parse", "--show-toplevel" })
  local found = {}

  -- Fold one `--name-status` run into column `col`, dropping similarity scores
  -- ("R100" -> "R"). Renames name both paths and are keyed by the new one; only the
  -- staged side can carry one, since an unstaged edit keeps the name.
  local function scan(col, args)
    for line in vim.gsplit(git(args, cwd) or "", "\n", { trimempty = true }) do
      local status, from, to = unpack(vim.split(line, "\t", { trimempty = true }))
      local path = to or from
      local change = found[path] or { x = " ", y = " ", path = path }
      change[col], change.orig = status:sub(1, 1), to and from or change.orig
      found[path] = change
    end
  end

  scan("x", { "diff", "--name-status", "--cached", resolved })
  scan("y", { "diff", "--name-status" })
  local others = git({ "ls-files", "--others", "--exclude-standard" }, cwd) or ""
  for path in vim.gsplit(others, "\n", { trimempty = true }) do
    found[path] = { x = "?", y = "?", path = path }
  end

  -- Sort by path, as git status does.
  local changes = vim.tbl_values(found)
  table.sort(changes, function(a, b)
    return a.path < b.path
  end)
  return changes
end

vim.api.nvim_create_user_command("GitBase", function(opts)
  if opts.bang then
    M.set(nil)
    return
  end

  local r = opts.args ~= "" and opts.args or M.default_ref()
  if not r then
    vim.notify(
      "git base: no default branch found, pass a ref explicitly",
      vim.log.levels.ERROR
    )
    return
  end
  M.set(r)
end, {
  nargs = "?",
  bang = true,
  desc = "Set the comparison base (bare: this repo's default branch; !: the index)",
  complete = function(arglead)
    local refs = git({ "for-each-ref", "--format=%(refname:short)" }) or ""
    return vim.tbl_filter(function(r)
      return vim.startswith(r, arglead)
    end, vim.split(refs, "\n", { trimempty = true }))
  end,
})

return M
