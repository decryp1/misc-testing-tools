local s = require(game:GetService("ReplicatedStorage").Modules.Packets)

print(typeof(s.ProjectileImpact))
for i, v in pairs(s.ProjectileImpact) do
	print(i, typeof(v))
	ofunc = v
	hookfunction(v, function(...) 
        local args = {...} 
		    local caller = debug.traceback()
        warn(checkcaller() == false and "the game" or "you", "called {" .. i .. "} with {" .. #args .. "} arguments")
        --warn(debug.traceback())
		    for a, s in args do
            if s ~= nil then
                warn("type check: " .. a, typeof(s), s)
                warn("num keys: " .. #s)
                for c, b in pairs(s) do
                    print(c, b) 
                end 
            end 
        end 
        return ofunc 
    end)
end
