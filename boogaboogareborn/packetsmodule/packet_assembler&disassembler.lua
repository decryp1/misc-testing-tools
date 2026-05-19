-- most of these are broken, but not all of them
--[[
example usage:

to hit multiple targets at once:
run({1661826, 1661875, 1661849, 1663858, 1665572, 1667068, 1666881, 1670157, 1670236, 1672009, 1672096, 1672394}, "swing")

to hit one target:
run({1661826}, "swing") -- it's not necessary for it to be a table for one entity, the script automatically converts it to a table anyway
^^ EntityID, packet type

to pickup an item or harvest:
run(7111567, "pickup")
^^ EntityID, packet type

to plant bluefruit:
run(7109482, "interactstructure", 377)
^^ EntityID, packet type, ItemID of fruit to plant

to open or close the door of a structure:
run(123123, "toggledoor")
^^ EntityID of thing with a door, packet type
]]
local function decode(str)
    local b1, b2, b3 = string.byte(str, -4, -2)
    return b1 + b2 * 256 + b3 * 65536
end

local function swingencode(ids)
    if typeof(ids) ~= "table" then ids = {ids}; end
    local count = #ids
    local out = {string.char(0x00, 0x11, count, 0x00)}
    for i = 1, count do
        local num = ids[i]
        out[#out + 1] = string.char(num % 256, math.floor(num / 256) % 256, math.floor(num / 65536) % 256, 0x00)
    end
    return table.concat(out)
end

local function pickupencode(entityid)
    local b1 = entityid % 256
    local b2 = math.floor(entityid / 256) % 256
    local b3 = math.floor(entityid / 65536) % 256
    return string.char(0x00, 0xD5, b1, b2, b3, 0x00)
end

local function toggledoorencode(entityid)
    local b1 = entityid % 256
    local b2 = math.floor(entityid / 256) % 256
    local b3 = math.floor(entityid / 65536) % 256
    return string.char(0x00, 0x07, b1, b2, b3, 0x00)
end

local function interactstructureencode(entityid, itemid)
    local b1 = entityid % 256
    local b2 = math.floor(entityid / 256) % 256
    local b3 = math.floor(entityid / 65536) % 256
    local i1 = itemid % 256
    local i2 = math.floor(itemid / 256) % 256
    return string.char(0x00, 0xC9, b1, b2, b3, 0x00, i1, i2)
end

local function run(stringg, packett, itemid)
    local id = typeof(stringg) == "string" and decode(stringg) or stringg
    local packet
    if packett == "swing" then
        packet = swingencode(id)
    elseif packett == "pickup" then
        packet = pickupencode(id)
    elseif packett == "interactstructure" then
        packet = interactstructureencode(id, typeof(itemid) == "number" and itemid or nil)
    elseif packett == "toggledoor" then
        packet = toggledoorencode(id)
    else
        print("dumbass")
    end
    game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring(packet))
end
