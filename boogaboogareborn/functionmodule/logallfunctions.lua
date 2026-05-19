--[[
unless you add a check for what function you're spoofing, or functions to ignore, this will crash your game or cause major lag
  ]]
local a = require(game:GetService("ReplicatedStorage").Game.functions)
warn(a)
for i, v in pairs(a) do
	print(i, v)
	if typeof(v) == "function" then
		local o = v
		hookfunction(v, function(...)
			args = {...} -- store original arguments without forcing structure
			print("{{" .. i .. "}}" .. " was fired with " .. #args .. " arguments")
      		for a, s in pairs(args) do
          		print(a ~= nil and a or "key is nil, i forgot whether or not pairs skips nil keys", s ~= nil and s or "value is nil")
          		if typeof(s) == "table" then
            		for d, f in pairs(s) do
              			warn(d ~= nil and d or "key is nil", f ~= nil and f or "value is nil")
            		end
          		end
      		end
			return o(args); -- return the original function call after the logger with the original arguments
		end)
	end
end
