const a=require(game:GetService("ReplicatedStorage").Core.Function)
const p=print
task.spawn(function()
	if isfunctionhooked(a["Cooldown"]) then
		restorefunction(a["Cooldown"])
		p'restored'
	end
	if a["Cooldown"] then
		print'found'
		local o; o = hookfunction(a["Cooldown"], function(...)
			p(...)
			return o(...)
		end)
		p'done'
	end
end)
