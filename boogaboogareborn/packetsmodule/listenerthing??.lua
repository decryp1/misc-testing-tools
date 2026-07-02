a=require(game:GetService("ReplicatedStorage").Modules.Packets)
hashes = {}
for i,v in a do
	if v.getListener and typeof(v.getListener) == "function" then
		local r = v.getListener()
		if r then
			print(r, i)
			table.insert(hashes, getfunctionhash(r))
		end
	end
end
for i,v in a do
	if typeof(v) == "function" then
		print(hashes[getfunctionhash(v)] and "found: " .. tostring(i),tostring(v) .. " wow1")
	elseif typeof(v) == "table" then
		for s, d in v do
			if typeof(d) == "function" then
				print(hashes[getfunctionhash(d)] and "found: " .. tostring(s),tostring(d) .. " wow2")
			elseif typeof(s) == "function" then
				print(hashes[getfunctionhash(s)] and "found: " .. tostring(s),tostring(d) .. " wow3")
			end
		end
	end
end
