if not _G.size then
	_G.size = Vector3.new(50, 50, 50)
end
local o; o = hookmetamethod(game, "__namecall", newcclosure(function(self, cf, size, args)
	if self == workspace and getnamecallmethod() == "GetPartBoundsInBox" then
		print(self, cf,size,args)
		size = _G.size or Vector3.new(50, 50, 50)
		if _G.changecf then	
			cf = _G.cf or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		end
	end
	return o(self, cf,size,args)
end))
