local fcitx = require("fcitx")

fcitx.watchEvent("KeyEvent", "key_event")
fcitx.addConverter("konge")

local enable = false

function key_event(sym, state, release)
  -- Ctrl + Shift + Space
  if state == fcitx.KeyState.Ctrl_Shift and sym == 32 and not release then
    enable = not enable
    if enable then
      io.popen("notify-send '空格模式开启'")
    else
      io.popen("notify-send '空格模式关闭'")
    end
    print(string.format("change state of konge: %s", enable))
  end
  return false
end

function konge(str)
  print(string.format("call konge: %s", enable))
  if enable then
    local tmp = string.gsub(str, utf8.charpattern, "%1 ")
    if tmp ~= nil then
      str = tmp
    end
  end
  return str
end
