local function decode(str)
    local b1, b2, b3 = string.byte(str, -4, -2)
    return b1 + b2 * 256 + b3 * 65536
end

local function float16(v)
    if v == 0 then return 0 end
    local sign = v < 0 and 0x8000 or 0
    v = math.abs(v)
    local exp = math.floor(math.log(v) / math.log(2))
    local mant = math.floor((v / (2 ^ exp)) * 1024)
    return sign + (exp + 15) * 32 + mant
end

local function swingencode(ids, cf, ts)
    if typeof(ids) ~= "table" then ids = {ids} end
    local data = {string.char(0x00, 0x13)}
    table.insert(data, string.char(#ids % 256, math.floor(#ids / 256)))
    for i, v in pairs(ids) do
        table.insert(data, string.char(
            v % 256,
            math.floor(v / 256) % 256,
            math.floor(v / 65536) % 256,
            math.floor(v / 16777216) % 256
        ))
        table.insert(data, "\0")
    end
    
    local x, y, z = cf.X, cf.Y, cf.Z
    local rx, ry, rz = cf:ToEulerAnglesXYZ()
    table.insert(data, string.pack("<fff", x, y, z))
    table.insert(data, string.pack("<HHH", float16(rx), float16(ry), float16(rz)))
    table.insert(data, string.pack("<d", ts))
    return table.concat(data)
end

local function pickupencode(id)
    local b1 = id % 256
    local b2 = math.floor(id / 256) % 256
    local b3 = math.floor(id / 65536) % 256
    return string.char(0x01, 0xE7, b1, b2, b3, 0x00)
end

local function toggledoorencode(id)
    local b1 = id % 256
    local b2 = math.floor(id / 256) % 256
    local b3 = math.floor(id / 65536) % 256
    return string.char(0x00, 0x07, b1, b2, b3, 0x00)
end

local function interactstructureencode(id, itemid)
    local b1 = id % 256
    local b2 = math.floor(id / 256) % 256
    local b3 = math.floor(id / 65536) % 256
    local i1 = itemid % 256
    local i2 = math.floor(itemid / 256) % 256
    return string.char(0x00, 0xC9, b1, b2, b3, 0x00, i1, i2)
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
