a=require(game:GetService("ReplicatedStorage").Core.Function)
p=print
task.spawn(function()
	if isfunctionhooked(a["Delay"]) then
		restorefunction(a["Delay"])
		p'restored'
	end
	if a["Delay"] then -- idk figured i would do both Delay and Cooldown just to cover all bases, though they're practically 1:1
		print'found'
		local o; o = hookfunction(a["Delay"], function(...)
			p(...)
			return o(...)
		end)
		p'done'
	end
end)
