local fcitx = require("fcitx")

fcitx.watchEvent(fcitx.EventType.KeyEvent, "switch_key_event")

local fcitx_enable = false

function switch_key_event(sym, state, release)
  if state == fcitx.KeyState.Ctrl_Alt and sym == 32 and not release then
    -- Ctrl + Alt + Space
    -- for cdda
    fcitx_enable = not fcitx_enable
    if fcitx_enable then
      io.popen("fcitx5-remote -o")
      io.popen("notify-send '输入法激活'")
    else
      io.popen("fcitx5-remote -c")
      io.popen("notify-send '输入法禁用'")
    end
    print(string.format("change state of ime: %s", fcitx_enable))
    return true
  end
  return false
end
