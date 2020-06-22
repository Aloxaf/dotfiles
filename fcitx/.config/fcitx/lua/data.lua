-- https://github.com/lilydjwg/fcitx-lua-scripts/blob/master/date.lua
function LookupDate(input)
  local fmt
  if input == '' then
    fmt = "%Y年%m月%d日"
  elseif input == 't' then
    fmt = "%Y-%m-%d %H:%M:%S"
  elseif input == 'd' then
    fmt = "%Y-%m-%d"
  end
  return os.date(fmt)
end

ime.register_command("dt", "LookupDate", "日期时间输入")
