#!/usr/bin/env lua

local number = require"number.script"
local cmdline = require"number.cmdline"

local load,assert,pcall,xpcall = load,assert,pcall,xpcall

local basename = string.match(arg[0], '[^/\\]+$') or arg[0]

local function abort(message)
  io.stderr:write(basename, ": ", message, "\n")
  os.exit(1)
end

local function error_handler(message)
  return string.gsub(message, '^([^:]*:%d+: )', '')
end

local function report_error(out, status, message)
  if not status then
    out:write(message,"\n")
  end
  return status
end

local function report(out, status, ...)
  local arg = table.pack(...)
  for n = 1,arg.n do
    arg[n] = tostring(arg[n])
  end
  if arg.n ~= 0 then
    out:write(table.concat(arg,"\t"),"\n")
  end
end

local function print_version(out)
  out:write("NumberScript for Lua v.", number.version, "\n")
end

local function print_help(out)
  out:write("Usage: ", basename, " [options] [script [args]]\n")
  out:write[[Available options are:
  -c, --compile         compile to Lua
  -d, --decompile       decompile Lua back to NumberScript
  -i, --interactive     run an interactive NumberScript REPL
  -o, --output          set a file to output to ("-" goes to stdout)
  -v, --version         display NumberScript version
  -h, --help            display this message
]]
end

local function load_script(file, filename)
  return assert(number.compile(
                        assert(file:read('*a'))
               ))
end

local function do_script(file, filename, arg)
  local err
  local status, code = xpcall(load_script, error_handler, file,filename)
  if not status then
    abort(filename..": "..code)
  end
  code, err = load(code, '@'..filename)
  if not code then
    abort(err)
  end
  return report_error(io.stdout, pcall(code, table.unpack(arg)))
end

local function do_compile_decompile(func, file, outfile)
  assert(outfile:write(
                assert(func(
                     assert(file:read('*a'))
                ))
        ))
end

local function compile_script(filename, file, outfile)
  local status, err = xpcall(do_compile_decompile, error_handler,
                             number.compile, file, outfile)
  if not status then
    abort(filename..": "..err)
  end
end

local function decompile_script(filename, file, outfile)
  local status, err = xpcall(do_compile_decompile, error_handler,
                             number.dump, file, outfile)
  if not status then
    abort(filename..": "..err)
  end
end

local function open_input(filename)
  if not filename or filename == '-' then
    return io.stdin,"stdin"
  end

  local file,err = io.open(filename, 'rb')
  if not file then
    abort("Cannot open "..err)
  end
  return file,filename
end

local function open_output(filename)
  if not filename or filename == '-' then
    return io.stdout,"stdout"
  end

  local file,err = io.open(filename, 'wb')
  if not file then
    abort("Cannot open "..err)
  end
  return file,filename
end

local function do_repl(console, out)
  console:setvbuf('line')
  out:setvbuf('no')

  local prompt = "> "
  local previous = ""
  local input = ""
  local line = 1
  local echo = false
  repeat
    if input ~= "" then
      if line == 1 and input:sub(1,1) == '=' then
        echo = true
        input = input:sub(2)
      end
      input = previous .. input
      local code, err = number.compile(input)
      if not code then
        out:write("stdin:",line,": ",err,"\n")
        previous = ""
        prompt = "> "
        line = 1
        echo = false
      else
        if echo then
          code = 'return '..code
        end
        local chunk = load(code, '=stdin')
        if not chunk and echo then
          -- try again without the implicit return
          code = code:sub(8)
          chunk = load(code, '=stdin')
        end
        if not chunk then
          previous = input
          prompt = ">> "
          line = line + 1
        else
          report(out, pcall(chunk))
          previous = ""
          prompt = "> "
          line = 1
          echo = false
        end
      end
    end
    out:write(prompt)
    input = console:read()
  until not input
  out:write("\n")
end

do
  local argv,err = cmdline.parse(arg,
        {
          h = "help",
          v = "version",
          i = "interactive",
          c = "compile",
          d = "decompile",
          o = "output",
          help = 0,
          version = 0,
          interactive = 0,
          compile = 0,
          decompile = 0,
          output = 1
        })
  if not argv then
    io.stderr:write(basename, ": ", err, "\n")
    print_help(io.stderr)
    os.exit(1)
  end

  if argv.help then
    print_help(io.stdout)

  elseif argv.version then
    print_version(io.stdout)

  else
    local outfile
    local file,filename
    if not argv.output then
      argv.output = {}
    end

    if argv.decompile then
      file,filename = open_input(argv[1])
      outfile = open_output(argv.output[1])
      decompile_script(filename, file, outfile)
      if outfile == io.stdout then
        outfile:write("\n")
      end

    elseif argv.compile then
      file,filename = open_input(argv[1])
      outfile = open_output(argv.output[1])
      compile_script(filename, file, outfile)
      if outfile == io.stdout then
        outfile:write("\n")
      end

    elseif argv.interactive or not argv[1] then
      print_version(io.stdout)
      do_repl(io.stdin, io.stdout)

    else
      local script_args = {[0] = filename}
      for i = 2,#argv do
        script_args[#script_args+1] = argv[i]
      end
      file,filename = open_input(argv[1])
      do_script(file, filename, script_args)
    end
  end

end
