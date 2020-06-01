function timestamp()
  return os.time(os.date("!*t"))
end

ime.register_trigger("timestamp", "UNIX 时间戳", { }, { "时间戳" })
