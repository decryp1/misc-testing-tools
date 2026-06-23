a=require(game:GetService("ReplicatedStorage").Game.classes.statusEffects)
const effects = {"OnFire", "OnIce", "OnPoison", "OnBossPoison", "Silenced", "OnQueenPoison", "Debuff", "Swiftness", "Haste", "SpiderWebSlow"};
for i,v in a do print(i,v) end
local o; o = hookfunction(a["playerHasEffect"], function(...)
	if table.find(effects, tostring(...)) and tostring(...):lower():find("haste") then -- change haste to debuff, swiftness, onice, etc.
		return true
	end
	return o(...)
end)
