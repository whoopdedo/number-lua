-- test number-lua
local number = require"number.script"

print(number.version)

assert(number.compile"12345" == "09")
assert(number.dump"09" == "12345")
load(number.compile("38263704518100867739600410149216596336930"))()
