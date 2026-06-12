local function escape_path(path)
  return path:gsub("^%s+", ""):gsub("%s+$", ""):gsub("/", "%%")
end

local function get_socket_dir()
  local xdg = os.getenv("XDG_RUNTIME_DIR")
  if xdg and xdg ~= "" then
    return xdg
  end
  local tmpdir = os.getenv("TMPDIR")
  if tmpdir and tmpdir ~= "" then
    return tmpdir
  end
  return "/tmp"
end

local function get_project_root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local result = handle:read("*a"):gsub("^%s+", ""):gsub("%s+$", "")
    handle:close()
    if result ~= "" then
      return result
    end
  end
  return vim.fn.getcwd()
end

-- Unix domain socket paths are limited to ~108 bytes (sizeof sun_path).
-- Stay safely under it so serverstart() doesn't silently truncate the name
-- (which would also break lookup by the nvim-mcp Python server).
local SOCKET_PATH_LIMIT = 108
-- Reserve a fixed pid width so producer and consumer agree on the threshold
-- regardless of the actual pid.
local PID_RESERVE = 10

-- sha256 of `s`, returned as a lowercase hex string. Used to keep the
-- variable segment of the socket name bounded for long project roots.
local function sha256_hex(s)
  if vim.fn and vim.fn.sha256 then
    return vim.fn.sha256(s)
  end
  -- Fallback: shell out (sha256sum). Should never be needed on modern nvim.
  local handle = io.popen("printf %s " .. vim.fn.shellescape(s) .. " | sha256sum")
  local out = handle:read("*a")
  handle:close()
  return (out:match("^(%x+)"))
end

-- Build the variable middle segment of the socket filename for a given root.
-- Must stay byte-for-byte identical to the nvim-mcp Python server's logic.
local function socket_segment(socket_dir, escaped)
  -- Fixed overhead: "<dir>/nvim-mcp." + "." + <pid> + ".sock"
  local overhead = #socket_dir + #("/nvim-mcp.") + 1 + PID_RESERVE + #(".sock")
  local max_escaped = SOCKET_PATH_LIMIT - overhead
  if #escaped <= max_escaped then
    return escaped
  end
  -- Too long: keep a readable prefix plus a hash suffix "<prefix>~<8hex>".
  local hash = sha256_hex(escaped):sub(1, 8)
  local keep = max_escaped - 1 - 8 -- room for "~" and the 8 hex chars
  if keep < 0 then
    keep = 0
  end
  return escaped:sub(1, keep) .. "~" .. hash
end

local function rpc_socket_path()
  local root = get_project_root()
  local escaped = escape_path(root)
  local socket_dir = get_socket_dir()
  local segment = socket_segment(socket_dir, escaped)
  local pid = vim.fn.getpid()
  return string.format("%s/nvim-mcp.%s.%d.sock", socket_dir, segment, pid)
end

local function has_rpc_socket()
  local expected = rpc_socket_path()
  for _, addr in ipairs(vim.fn.serverlist()) do
    if addr == expected then
      return true
    end
  end
  return false
end

-- Expose for lualine / other consumers
_G.rpc_has_socket = has_rpc_socket

vim.api.nvim_create_user_command("RpcStart", function()
  if has_rpc_socket() then
    vim.notify("RPC socket already active", vim.log.levels.WARN)
    return
  end
  local path = rpc_socket_path()
  vim.fn.serverstart(path)
  vim.notify("Listening on " .. path, vim.log.levels.INFO)
end, { desc = "Start Neovim RPC socket for nvim-mcp" })

vim.api.nvim_create_user_command("RpcStop", function()
  local path = rpc_socket_path()
  if not has_rpc_socket() then
    vim.notify("RPC socket not active", vim.log.levels.WARN)
    return
  end
  vim.fn.serverstop(path)
  vim.notify("Stopped listening on " .. path, vim.log.levels.INFO)
end, { desc = "Stop Neovim RPC socket for nvim-mcp" })
