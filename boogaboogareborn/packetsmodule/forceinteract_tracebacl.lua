a=require(game:GetService("ReplicatedStorage").Modules.Packets) -- no 'local' because top-level locals are essentially globals
for i,v in a.ForceInteract do
	if type(v) == "function" then
		if isfunctionhooked(v) then restorefunction(v); end
	end
end
for i,v in a.ForceInteract do
	if type(v) == "function" then
		local o;o = hookfunction(v, function(...) -- contrary to above, clamp old reference to current level to reduce possible confusion blabla
			print(i,v, ...)
			print(debug.traceback()) -- rs.Game.drag, line 135
			return o(...)
		end)
	end
end
--[[
find what's calling forceinteract, view logic to find a uhhh magnitude check, then spoof index call to hrp.Positon or hookmetamethod getpivot to return the target parts position to bypapsppy distance checks
]]
