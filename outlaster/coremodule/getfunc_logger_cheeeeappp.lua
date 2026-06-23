a=require(game:GetService("ReplicatedStorage").Core)
p=print
task.spawn(function()
	if isfunctionhooked(a["Get"]) then
		restorefunction(a["Get"])
		p'restored'
	end
	if a["Get"] then
		print'found'
		local o; o = hookfunction(a["Get"], function(...)
			p(...)
			return o(...)
		end)
		p'done'
	end
end)
