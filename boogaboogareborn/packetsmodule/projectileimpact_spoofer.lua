local s = require(game:GetService("ReplicatedStorage").Modules.Packets)

print(typeof(s.ProjectileImpact))
for i, v in pairs(s.ProjectileImpact) do if isfunctionhooked(v) then restorefunction(v) end end
for i, v in pairs(s.ProjectileImpact) do
	print(i, typeof(v))
	ofunc = v
	local t
	hookfunction(v, function(...) 
        local args = {...} 
		    local caller = debug.traceback()
        warn(checkcaller() == false and "the game" or "you", "called {" .. i .. "} with {" .. #args .. "} arguments")
        --warn(debug.traceback())
		    for a, s in args do
            if s ~= nil then
				        t = s
				        --t["position"] = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
				        t["entityID"] = 1885759
				        --t["timeStamp"] = game.Workspace:GetServerTimeNow()
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
