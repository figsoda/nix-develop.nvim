---@mod nix-develop `nix develop` for neovim
---@tag nix-develop.nvim
---@tag :NixDevelop
---@brief [[
---https://github.com/figsoda/nix-develop.nvim
--->
---:NixDevelop
---:NixDevelop .#dev-shell
---:NixDevelop --impure
---<
---@brief ]]

local M = {}

local levels = vim.log.levels
local loop = vim.loop

--->lua
---require("nix-develop").ignored_variables["SHELL"] = false
---<
---@class ignored_variables
M.ignored_variables = {
  HOME = true,
  TEMP = true,
  TEMPDIR = true,
  TMP = true,
  TMPDIR = true,
  TZ = true,
  SHELL = true,
}

--->lua
---require("nix-develop").separated_variables["LUA_PATH"] = ":"
---<
---@class separated_variables
M.separated_variables = {
  PATH = ":",
  XDG_DATA_DIRS = ":",
}

local function setenv(name, value)
  if M.ignored_variables[name] then
    return
  end

  local sep = M.separated_variables[name]
  if sep then
    local path = loop.os_getenv(name)
    if path then
      loop.os_setenv(name, value .. sep .. path)
      return
    end
  end

  loop.os_setenv(name, value)
end

---Enter a development environment
---@param cmd string
---@param args string[]
---@return nil
---@usage `require("nix-develop").enter_dev_env("nix", {"print-dev-env", "--json"})`
function M.enter_dev_env(cmd, args)
  local stdout = loop.new_pipe()
  local data = ""

  loop.spawn(cmd, {
    args = args,
    stdio = { nil, stdout, nil },
  }, function(code, signal)
    if code ~= 0 then
      table.insert(args, 1, cmd)
      vim.notify(
        string.format(
          "`%s` exited with exit code %d",
          table.concat(args, " "),
          signal
        ),
        levels.WARN
      )
      return
    end

    if signal ~= 0 then
      table.insert(args, 1, cmd)
      vim.notify(
        string.format(
          "`%s` interrupted with signal %d",
          table.concat(args, " "),
          signal
        ),
        levels.WARN
      )
      return
    end

    for name, value in pairs(vim.json.decode(data)["variables"]) do
      if value.type == "exported" then
        setenv(name, value.value)
      end
    end
    vim.notify("successfully entered development environment", levels.INFO)
  end)

  loop.read_start(stdout, function(err, chunk)
    if err then
      vim.notify("Error when reading stdout: " .. err, levels.WARN)
    end
    if chunk then
      data = data .. chunk
    end
  end)
end

---Enter a development environment a la `nix develop`
---@param args string[] Extra arguments to pass to `nix print-dev-env`
---@return nil
---@usage `require("nix-develop").nix_develop({".#dev-shell", "--impure"})`
function M.nix_develop(args)
  M.enter_dev_env("nix", {
    "print-dev-env",
    "--json",
    unpack(args),
  })
end

return M
