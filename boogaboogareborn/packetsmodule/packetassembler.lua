--[[
to hit multiple targets at once:
run({1661826, 1661875}, "swing")

to hit one target:
run(1661826, "swing")

to pickup an item or harvest:
run(7111567, "pickup")

to plant bluefruit:
run(7109482, "interactstructure", 377)

to open or close the door of a structure:
run(123123, "toggledoor")

to place a structure:
run("Campfire", "placestructure", CFrame.new(308.27, -5.92, -1064.12))
]]

lp = game.Players.LocalPlayer
bytenet = game.ReplicatedStorage.ByteNetReliable

local function writefloat16(b, offset, v)
    if v == 0 then
        return
    end
    local sign = 0
    if v < 0 then
        sign = 0x8000
        v = -v
    end
    local m, e = math.frexp(v)
    if e < -46 then
        return
    end
    buffer.writeu16(b, offset, sign + (e + 14) * 32 + math.floor(m * 2048))
end

local function swingencode(ids, cf, ts)
    local n = #ids
    local b = buffer.create(30 + 5 * n)
    buffer.writeu8(b, 1, 0x13)
    buffer.writeu16(b, 2, n)
    local off = 4
    for i = 1, n do
        buffer.writeu32(b, off, ids[i])
        off = off + 5
    end
    local x, y, z = cf:ToEulerAnglesXYZ()
    buffer.writef32(b, off, cf.X)
    buffer.writef32(b, off + 4, cf.Y)
    buffer.writef32(b, off + 8, cf.Z)
    writefloat16(b, off + 12, x)
    writefloat16(b, off + 14, y)
    writefloat16(b, off + 16, z)
    buffer.writef64(b, off + 18, ts)
    return b
end

local function idencode(cmd, id)
    local b = buffer.create(6)
    buffer.writeu8(b, 0, 0x01)
    buffer.writeu8(b, 1, cmd)
    buffer.writeu32(b, 2, id)
    return b
end

local function interactstructureencode(id, itemid)
    local b = buffer.create(8)
    buffer.writeu8(b, 0, 0x01)
    buffer.writeu8(b, 1, 0x69)
    buffer.writeu32(b, 2, id)
    buffer.writeu16(b, 6, itemid)
    return b
end

local function placestructureencode(buildingname, cf)
    local n = #buildingname
    local b = buffer.create(22 + n)
    buffer.writeu8(b, 0, 0x01)
    buffer.writeu8(b, 1, 0xE1)
    buffer.writeu16(b, 2, n)
    buffer.writestring(b, 4, buildingname)
    local off = 4 + n
    local x, y, z = cf:ToEulerAnglesXYZ()
    buffer.writef32(b, off, cf.X)
    buffer.writef32(b, off + 4, cf.Y)
    buffer.writef32(b, off + 8, cf.Z)
    writefloat16(b, off + 12, x)
    writefloat16(b, off + 14, y)
    writefloat16(b, off + 16, z)
    return b
end

local function run(ids, packettype, arg1, arg2)
    local b
    if packettype == "swing" then
        local character = lp.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if type(ids) ~= "table" then ids = {ids} end
        b = swingencode(ids, root.CFrame, workspace:GetServerTimeNow())
    elseif packettype == "pickup" then
        b = idencode(0xE7, type(ids) == "table" and ids[1] or ids)
    elseif packettype == "toggledoor" then
        b = idencode(0x44, type(ids) == "table" and ids[1] or ids)
    elseif packettype == "interactstructure" then
        b = interactstructureencode(type(ids) == "table" and ids[1] or ids, arg1)
    elseif packettype == "placestructure" then
        b = placestructureencode(ids, arg1)
    end
    if b then
        bytenet:FireServer(b)
    end
end

--[[
traditionally, you used to be able to do:
local p = require(game.ReplicatedStorage.Modules.Packets)
p.SwingTool.send({
    ["entityIDs"] = {
        [1] = { ["entityID"] = 123123 }
    }
    ["cframe"] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    ["timestamp"] = game.Workspace:GetServerTimeNow()
})
^^ THIS IS PROBABLY VERY DETECTED DONT USE THIS, SAME FOR EVERY PACKET. JUST BECAUSE YOU DONT GET KICKED DOESNT MEAN U DONT GET FLAGGED
^^ though the game uses a different method for timestamp delivery (less secure and actually easier to exploit):
local c = require(game:GetService("ReplicatedStorage").Modules.Clock)
["timestamp"] = c.getServerTime()
^^ you can exploit the timestamp that this function gives via traceback searches for any module or function named swingTool/SwingTool/swing, etc
local old; old = hookmetamethod(c.getServerTime, function(...)
    -- an example of a traceback search but very very pseudo would be:
    if tostring(debug.traceback()):lower():find("swing") then
        return game.Workspace:GetServerTimeNow() + 2 -- you would use this for any swing calls, but you'd also want to only spoof every even call so that time checks return later values, reducing swing cooldown
    end
    _G.call += 1 -- this would be the even/odd determination (but wouldnt work by itself due to no traceback searching)
    if _G.call % 2 == 0 then -- modulo == 0 then it's even i think
        return game.Workspace:GetServerTimeNow() + 1 -- combine with a traceback search to only spoof swingtool calls, every second swing would have no cooldown, since the "if tick() - oldtick > 1 do .. " would return a value of greater than one, meaning you've already "waited" one second
    else 
        return old(...)
    end
end)
]]
