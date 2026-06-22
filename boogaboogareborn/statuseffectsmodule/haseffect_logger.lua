a=require(game:GetService("ReplicatedStorage").Game.classes.statusEffects)
for i,v in a do print(i,v) end
local o; o = hookfunction(a["playerHasEffect"], function(...)
	print(...)
	print(debug.traceback())
	return o(...)
end)

--[[
alternatively:
local old = a["playerHasEffect"]
a["playerHasEffect"] = function(...)
	print(...)
	--print(debug.traceback()) -- assuming you're using this for lower-end executors, it's also assumed they dont have this. thougjh i cant remember if this is a renv func or not so whatever
	--return true
	return old(...)
end
]]
