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

local function run(ids, packettype, itemid)
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
        packet = interactstructureencode(id, itemid)
    end
    
    if packet then
        game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring(packet))
    end
end
