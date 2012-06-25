package = "number-lua"
version = "20120623-2"
source = {
  url = "git://github.com/whoopdedo/number-lua.git",
  tag = "release-20120623-2"
}
description = {
  summary = "NumberScript for Lua, a small language that compiles to Lua",
  detailed = [[
NumberScript is mathematically proven to be the most readable possible language.

 * No braces
 * No significant whitespace
 * No operators of any sort
 * Hindu-arabic base 10 numerals only. All other bases are completely inferior.

NumberScript for Lua is also able to act as a compiler for the original
Javascript NumberScript.
  ]],
  homepage = "https://github.com/whoopdedo/number-lua",
  license = "MIT"
}
dependencies = {
  "lua >= 5.2",
  "lbn >= 20120501"
}
build = {
  type = "none",
  install = {
    lua = {
      ["number.script"] = "lib/script.lua",
      ["number.cmdline"] = "lib/cmdline.lua"
    },
    bin = {
      ["number-lua"] = "bin/cmd.lua"
    }
  }
}
