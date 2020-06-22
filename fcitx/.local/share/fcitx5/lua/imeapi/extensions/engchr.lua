local fcitx = require("fcitx")

fcitx.watchEvent(fcitx.EventType.KeyEvent, "eng_chr_key_event")
fcitx.addConverter("eng_chr")

local enable = false

function eng_chr_key_event(sym, state, release)
  -- print(string.format("%d %d %s", sym, state, release))
  if sym == 65513 then
    enable = not release
  end
end

local tb = {
  ["、"] = "\\",
  ["·"] = "`",
  ["～"] = "~",
  ["……"] = "^",
}

function eng_chr(str)
  print(string.format("call eng_chr: %s", enable))
  -- 空格模式
  if enable then
    if tb[str] then
      str = tb[str]
    end
  end
  return str
end

--
