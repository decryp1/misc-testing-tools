--[[a=require(game:GetService("ReplicatedStorage").Modules.sequence)
local o;o = hookfunction(a['new'], function(...)
    print(...)
    return o(...)
end)]]
a = require(game:GetService("ReplicatedStorage").Modules.Packets)
print(a.UpdateLoop.getListener())
restorefunction(a.UpdateLoop.getListener())
local o; o = hookfunction(a.UpdateLoop.getListener(), function(...)
    for i,v in {...} do
        if type(v) == "table" then
            for a,s in v do
                print(a,s)
            end
        end
    end
    return o(...)
end)
