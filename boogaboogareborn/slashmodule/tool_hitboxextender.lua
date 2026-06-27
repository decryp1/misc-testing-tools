local o; o = hookmetamethod(game, "__namecall", newcclosure(function(self, cf, size, args)
	if self == workspace and getnamecallmethod() == "GetPartBoundsInBox" then
		print(self, cf,size,args)
		size = Vector3.new(50,50,50)
		cf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	end
	return o(self, cf,size,args)
end))
