a=require(game:GetService("ReplicatedStorage").Modules.Packets)
l={}
for i,v in a do
	if v.getListener and typeof(v.getListener) == "function" then
		local r = v.getListener()
		if r then
			if isfunctionhooked(v.getListener) then restorefunction(v.getListener) end
			local o; o = hookfunction(v.getListener, function(...)
				--print(...)
				print(getcallingscript(), debug.traceback())
				return o(...)
			end)
			--[[print(r, i)
			if i == "SwingTool" then
				print("yoyoyoyo");
			end]]
		end
	end
end
--print(#l)
--[[
was meant to get important listeners and see who invoked each given listener, and what they're used for wowo
]]
