-- doesnt actually work loser
local a = require(game:GetService("ReplicatedStorage").Game.pickup)
--a.Try = function() return true end
of = a.Try
hookfunction(a.Try, function(...)
	print(...)
	return true
end)

-- run this to remove the hook
--restorefunction(a.Try)
