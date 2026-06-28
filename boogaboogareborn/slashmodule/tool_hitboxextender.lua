if not _G.size then
	_G.size = Vector3.new(50, 50, 50)
end
local o; o = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	if self == workspace and getnamecallmethod() == "GetPartBoundsInBox" then
		local args = {...}
		if typeof(args[1]) == "CFrame" and typeof(args[2]) == "Vector3" then
			--print(self, cf,size,args)
			--print(getcallingscript())
			args[2] = _G.size or Vector3.new(50, 50, 50)
			if _G.changecf then
				args[1] = _G.cf or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			end
		end
		return o(self, unpack(args))
	end
	return o(self, ...)
end))
