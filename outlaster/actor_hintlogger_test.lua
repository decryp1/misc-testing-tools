c=game:GetService("CollectionService")
a =Instance.new("Actor",workspace)
_G.t = setmetatable({},{__mode="v"})
id, ch = create_comm_channel()

ch.Event:Connect(function(d)
    table.insert(_G.t, d)
    print(d)
end)

run_on_actor(a,[[
    local id = ...
    local ch = get_comm_channel(id)
    workspace.DescendantAdded:Connect(function(d)
        if d:IsA("Model") and d:FindFirstChild("Part") and d.Part:IsA("MeshPart") and d.Part.MeshId == "rbxassetid://5163733008" then
            ch:Fire(d)
        end
    end)
]], id)
--[[
this is meant to be a more performant hint logger
my current checks are as minimal and as discriminatorial as possible, but i figured i'd test using parallel threads to weigh performance
]]
