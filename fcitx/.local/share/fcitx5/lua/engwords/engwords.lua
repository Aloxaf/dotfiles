function exists(file)
  local _, rst = pcall(function() return io.open(file, "r") end)
  return rst ~= nil
end

local dir = "/home/aloxaf/.local/share/fcitx5/spell/en/"

-- 文件不存在则新建一个
if not exists(dir.."user.txt") then
  io.open(dir.."user.txt", "w+")
end
if not exists(dir.."history.txt") then
  io.open(dir.."history.txt", "w+")
end

-- 读取历史数据
local file = assert(io.open(dir.."history.txt", "r"))
local lines = {}
if file ~= nil then
  for line in file:lines() do
    local match = string.gmatch(line, "[^ ]+")
    local times, str = match(), match()
    lines[str] = tonumber(times)
  end
end

-- 记录 last commit 的新词
function commit_logger(text)
  if text:match("%W") ~= nil then
    return
  end
  if lines[text] == nil then
    lines[text] = 1
  elseif lines[text] < 65535 then
    lines[text] = lines[text] + 1
  end
end

-- 记录出现次数高的单词
function rebuild_cache()
  local users = assert(io.open(dir.."user.txt", "w+"))
  local history = assert(io.open(dir.."history.txt", "w+"))
  for k,v in pairs(lines) do
    if v >= 3 then
      users:write(string.format("%d %s\n", v, k))
    end
    history:write(string.format("%d %s\n", v, k))
  end
  local size = users:seek("end")
  if size ~= 0 then
    io.popen(string.format("%s --comp-dict %s %s", "/usr/lib/fcitx5/libexec/comp-spell-dict", dir.."user.txt", dir.."user.fscd"))
  end
end

-- 重启 fcitx
local enable_shuangpin = false
function restart_fcitx(name)
  if name == "shuangpin" then
    enable_shuangpin = true
  elseif enable_shuangpin then
    enable_shuangpin = false
    io.popen("fcitx5 -r")
  end
end

local fcitx = require("fcitx")
fcitx.watchEvent("CommitEvent", "commit_logger")
fcitx.watchEvent("FocusOutEvent", "rebuild_cache")
-- fcitx.watchEvent("InputMethodDeactivatedEvent", "restart_fcitx")
