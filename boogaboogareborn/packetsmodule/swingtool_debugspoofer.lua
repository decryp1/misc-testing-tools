--idk if this works but i had an old info bypass and figured thats what booga used to use for packet traceback so here it is
local oldinfo = debug.info
local a = require(game:GetService("ReplicatedStorage").Game.tool.Slash)
debug.info = newcclosure(function(level, field)
    if not checkcaller() then
        if level ~= 1 then
            if field == "s" then
                return game:GetService("ReplicatedStorage").Game.tool.Slash
            elseif field == "n" then
                return ""
            elseif field == "f" then
                return a
            end
        end
    end
    return oldinfo(level, field)
end)
