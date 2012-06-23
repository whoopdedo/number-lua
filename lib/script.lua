local bignum = require"bn"
local tostring = tostring
local gsub,find = string.gsub,string.find
local strdump = string.dump
local type,error = type,error

return {
  version = "20120623";

  compile = function(source)
    source = gsub(tostring(source), '%s+', '')
    if find(source, '%D') then
      return nil,"invalid number"
    end
    return bignum.number(source):totext()
  end;

  dump = function(code)
    if type(code) == 'function' then
      code = strdump(code)
    elseif type(code) ~= 'string' then
      return nil,"string or function expected"
    end
    return bignum.text(code):tostring()
  end;
}
