local a = require(game:GetService("ReplicatedStorage").Modules.ItemData.data)
local items = {["Sling"] = true, ["Bow"] = true, ["Iron Bow"] = true, ["Crossbow"] = true, ["Magnetite Crossbow"] = true, ["God Sling"] = true, ["AK47"] = true, ["AK47 V2"] = true, ["Blunderbuss"] = true, ["GSwitch"] = true, ["Hand Mortar"] = true, ["M82"] = true, ["M16"] = true, ["MG42"] = true, ["Musket"] = true, ["STG44"] = true, ["Slow Musket"] = true, ["Throw Grenade"] = true}
writefile("teststuff.txt", "hello!\n")
for i,v in a do
	if type(v) == "table" and items[i] then
		appendfile("teststuff.txt", `\n{string.upper(i)}\n`)
		for a,s in v do
			appendfile("teststuff.txt", `{a } {s }\n`)
		end
	end
end
