-- drops one of every item in your inventory without interacting with anything internally because im so good
input = {["UserInputType"] = Enum.UserInputType.MouseButton2}
for i, v in game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory.List:GetChildren() do
	if v:FindFirstChild("ImageButton") then
		firesignal(v.ImageButton.InputBegan, input)
		task.wait()
	end
	task.wait(0.3)
end
