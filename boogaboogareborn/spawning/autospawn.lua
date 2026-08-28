--read the code before u skid it, it's a very very very easy feature to make
local t = {}
t.main = nil -- main 
t.spawntype = "asd" -- 'bed' for beds, anything else for regular spawning
t.lp = game.Players.LocalPlayer
t.pg = t.lp.PlayerGui.SpawnGui.Customization.BedButton -- settingsss
t.util = require(game.ReplicatedStorage.Modules.GameUtil)

if _G.stuff and _G.stuff.main then
    task.cancel(_G.stuff.main)
    _G.stuff.main = nil
end

_G.stuff = t -- global thread env for togglability
function getcd()
    return _G.stuff.spawntype == "bed" and workspace:GetServerTimeNow() - _G.stuff.util.Data.lastSpawnFromBed or 123123 --120| returns the time that's elapsed since spawning; if >120, u can spawn
end

function canspawn()
    if not _G.stuff.pg.Parent.Parent.Enabled then return false end --if we arent dead
    if _G.stuff.spawntype == "bed" and getcd() < 120 then return false end -- if we're spawning in beds and the cooldown hasnt reset
    return _G.stuff.spawntype == "bed" and t.pg.Visible or _G.stuff.spawntype ~= "bed" and true -- if we've died and the spawning ui is visible
end

function spawn()
    if not canspawn() then return end -- do nothing if we're playing the game or cant spawn
    getconnections(_G.stuff.pg.Parent:QueryDescendants(_G.stuff.spawntype == "bed" and '#BedButton' or '#PlayButton')[1].Activated)[1].Function()
    --presses the bedbutton or playbutton based on spawntype
    -- check bedspawn.lua for a better explanation of how this works
end

_G.stuff.main = task.spawn(function() while task.wait(.1) do spawn() end end)
-- attempts to spawn every ~.1 seconds
--^^ task.cancel(_G.stuff.main)
--this code is terrible pls fix it
