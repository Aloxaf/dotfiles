local fcitx = require("fcitx")
-- fcitx.addConverter("space")

function is_english(str)
  return str:match("%W") == nil
end

local last_str = ""
local last_is_eng = false
local punctuation = "[。，？！]"

function space(str)
  local cur_is_eng = is_english(str)

  if last_is_eng == cur_is_eng then
    return str
  end

  if last_is_eng and not cur_is_eng then
    -- 需要注意中文标点和英文之间一般不需要空格
    if not last_str:match(punctuation) then
      str = " "..str
    end
  elseif not last_is_eng and cur_is_eng then
    if not str:match(punctuation) then
      str = " "..str
    end
  end

  last_is_eng = cur_is_eng
  last_str = str
  return str
end
