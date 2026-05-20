-- eats a bloodfruit if detected wow
-- i dont think this method of using and dropping items is detected since its js clicking
input = {["UserInputType"] = Enum.UserInputType.MouseButton1}
local item
for i, v in game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory.List:GetChildren() do
	if v.Name == "Bloodfruit" and v:FindFirstChild("ImageButton") then -- separate check because im tuff
		---------->change bloodfruit to Bluefruit or whatever to eat something else
    --firesignal(v.ImageButton.InputBegan, input)
    item = v.ImageButton
	end
end
firesignal(item.InputBegan, input)
