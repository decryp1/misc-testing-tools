local s = require(game:GetService("ReplicatedStorage").Modules.GameUtil)
local tray = s.canPlace
local argss = {}
local o; o = hookfunction(s.canPlace, function(...)
	local args = {...}
	for i, v in pairs(args) do
		--print(i, v)
		if v ~= nil then
			table.insert(argss, v)
		end
	end
	return o(table.unpack(args))
end)

wait(6)
print'a'
for i = 1, 40 do
	if i == 1 then print("total arguments logged:", #argss); end
	if argss[i] ~= nil then
		print(argss[i])
	end
end
for i = 1,40 do
	if i == 1 then warn("REVERSE"); end
	local c= #argss>0 and #argss-i ~= nil and argss[#argss-i]
	if c then
		print(c~=nil and c)
	end
end
restorefunction(s.canPlace)
