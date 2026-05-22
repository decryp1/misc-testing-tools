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

local function float16(v)
    if v == 0 then return 0 end
    local sign = v < 0 and 0x8000 or 0
    v = math.abs(v)
    local exp = math.floor(math.log(v, 2))
    local mant = math.floor((v / 2 ^ exp) * 1024)
    return sign + (exp + 15) * 32 + mant
end

local function swingencode(ids, cf, ts)
    if typeof(ids) ~= "table" then ids = {ids} end

    local parts = {string.char(0x00, 0x13)}
    table.insert(parts, string.pack("<H", #ids))
    for i, v in ipairs(ids) do
        table.insert(parts, string.pack("<I4x", v))
    end
    
    local x, y, z = cf:ToEulerAnglesXYZ()
    table.insert(parts, string.pack("<fffHHHd", cf.X, cf.Y, cf.Z, float16(x), float16(y), float16(z), ts))
    return table.concat(parts)
end

local function pickupencode(id)
    return string.pack("<BBI3x", 0x01, 0xE7, id)
end

local function toggledoorencode(entityid)
    return string.pack("<BBI3x", 0x01, 0x44, entityid)
end

local function interactstructureencode(id, itemid)
    return string.pack("<BBI3xH", 0x01, 0x69, id, itemid)
end

local function placestructureencode(buildingname, cf)
    local x, y, z = cf:ToEulerAnglesXYZ()
    return string.pack("<BBH", 0x01, 0xE1, #buildingname) .. buildingname .. string.pack("<fffHHH", cf.X, cf.Y, cf.Z, float16(x), float16(y), float16(z))
end

local function run(ids, packettype, arg1, arg2)
    local packet
    if packettype == "swing" then
        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        packet = swingencode(ids, root.CFrame, workspace:GetServerTimeNow())
    elseif packettype == "pickup" then
        local id = typeof(ids) == "table" and ids[1] or ids
        packet = pickupencode(id)
    elseif packettype == "toggledoor" then
        local id = typeof(ids) == "table" and ids[1] or ids
        packet = toggledoorencode(id)
    elseif packettype == "interactstructure" then
        local id = typeof(ids) == "table" and ids[1] or ids
        packet = interactstructureencode(id, arg1)
    elseif packettype == "placestructure" then
        packet = placestructureencode(ids, arg1)
    end
    
    if packet then
        game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring(packet))
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
