local sub = string.sub
local insert = table.insert
local type = type

return {
  parse = function(arglist, options)
    local params = {}
    local num = 1
    while num <= #arglist do
      local arg = arglist[num]
      if arg == '--' then
        num = num + 1
        break
      elseif sub(arg,1,2) == '--' then
        arg = sub(arg,3)
        if not options[arg] or type(options[arg]) == 'string' then
          return nil, "invalid option '"..arg.."'"
        end
        local optparams = {}
        for i = 1,options[arg] do
          num = num + 1
          if num > #arglist then
            return nil, "too few parameters for option '"..arg.."'"
          end
          insert(optparams, arglist[num])
        end
        params[arg] = optparams
      elseif sub(arg,1,1) == '-' and #arg > 1 then
        arg = sub(arg,2)
        for n = 1, #arg do
          local opt = sub(arg,n,n)
          if not options[opt] or not options[options[opt]] then
            return nil, "invalid option '"..opt.."'"
          end
          opt = options[opt]
          local numparams = options[opt]
          if numparams > 0 then
            local optparams = {}
            if n < #arg then
              optparams[1] = sub(arg,n+1)
              numparams = numparams - 1
            end
            for i = 1,numparams do
              num = num + 1
              if num > #arglist then
                return nil, "too few parameters for option '"..opt.."'"
              end
              insert(optparams, arglist[num])
            end
            params[opt] = optparams
            break
          else
            params[opt] = {}
          end
          n = n + 1
        end
      else
        break
      end
      num = num + 1
    end
    repeat
      insert(params, arglist[num])
      num = num + 1
    until num > #arglist
    return params
  end
}
