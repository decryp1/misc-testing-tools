-- lets you try out mod commands or trolling things or whatever so u know what ur disabling
local a

a = Instance.new("Part", game.Players.LocalPlayer.Character)
a.Name = '@ps'
task.wait(3)
a:Destroy() -- to unplatformstand urself
a = nil

a = Instance.new("Part", game.Players.LocalPlayer.Character)
a.Name = '@flashb'
a:SetAttribute("duration", 2)
a:SetAttribute("delay", 1)
task.wait(3)
a:Destroy()
a = nil

a = Instance.new("Part", game.Players.LocalPlayer.Character)
a.Name = "@shake"
a:SetAttribute("duration", 5)
a:SetAttribute("intensity", 3)
task.wait(5)
a:Destroy()
a = nil
