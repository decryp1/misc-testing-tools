local s = require(game:GetService("ReplicatedStorage").Game.classes.projectile)
if isfunctionhooked(s.new) then restorefunction(s.new); end
local o; o = hookfunction(s.new, function(...)
	for i, v in {...} do
		print(i ~= nil and i, v ~= nil and v)
		for a, s in v do
			print(a ~= nil and a, s ~= nil and s)
		end
	end
	return o(...)
end)
