local s = require(game:GetService("ReplicatedStorage").Modules.GameUtil)
local tray = s.canPlace
local argss = {}
hookfunction(s.canPlace, function(...)
	local args = {...}
	for i, v in pairs(args) do
		--print(i, v)
		table.insert(argss, v)
	end
	return tray(table.unpack(args))
end)

wait(6)

for i = 1, 40 do
	if i == 1 then print("total arguments logged:", #argss); end
	print(argss[i])
end
for i = 1,40 do
	if i == 1 then warn("REVERSE"); end
	print(argss[#argss-i])
end
restorefunction(s.canPlace)
