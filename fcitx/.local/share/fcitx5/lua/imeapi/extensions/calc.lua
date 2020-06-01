-- 参考 https://developer.51cto.com/art/201109/293595.htm

function calc(input)
  local func = loadstring(string.format("return %s", input))
  if func == nil then
    return "-- 表达式不正确 --"
  end
  local ret = func()
  if ret == math.huge or ret ~= ret then
    return "-- 计算错误 --"
  end
  return ret
end

ime.register_command("cl", "calc", "数学计算", "alpha", "进行简单的数学计算机")
