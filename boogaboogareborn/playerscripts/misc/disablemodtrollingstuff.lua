--[[
not actually mod commands, basically just a flashbang and fling disabler
]]

plr = game.Players.LocalPlayer
chr = plr.Character or plr.CharacterAdded:Wait()
hum = chr:FindFirstChild("Humanoid") or nil
s = chr:FindFirstChild("Misc") or nil
function run()
    for i, v in pairs(getconnections(chr.ChildAdded)) do
        print(i, v)
        local ol = v.Function;
        local found = false
        if not found and #debug.getupvalues(ol) == 4 and typeof(debug.getupvalue(ol, 4)) == "function" then
            print("found")
            v:Disable()
            found = true
            break
        end
    end
end
plr.CharacterAdded:Connect(function(chrr)
	repeat wait(.1) until #chr:GetChildren() > 5 or chr:FindFirstChild("Humanoid").Health > 0
	chr = chrr
	hum = chr:WaitForChild("Humanoid")
	s = chr:FindFirstChild("Misc") or nil; task.wait()
    run()
end)

--[[if chr and s then
	for i, v in pairs(getconnections(chr.ChildAdded)) do
		print(i, v)
		local ol = v.Function;
		local found = false
		if not found and #debug.getupvalues(ol) == 4 and typeof(debug.getupvalue(ol, 4)) == "function" then
			print("found")
			v:Disable()
			found = true
			break
		end
	end	
		s.Enabled = false
		for i, v in pairs(getconnections(chr.ChildAdded)) do
		local ol = v.Function
		hookfunction(v.Function, function(...)
			local args = {...}
			print("something was added to ur player but john herkle disabled it, the arg(s) was: " .. args[1])
			for q, w in pairs(args) do
				if q:find("ps" or "flashb" or "shake") or w:find("ps" or "flashb" or "shake") then
					print("also it was fired with moderator something so yeah")
				end
			end -- idk if any of that above works, i never tested it but with some revivisions it might
			return ol(args)
		end)
	end
end]]
