a= require(game:GetService("ReplicatedStorage").Modules.ByteNet.process.client)
if isfunctionhooked(a.sendReliable) then restorefunction(a.sendReliable) end
shouldprintargs = true
shouldprintlevels = true
local o;
dummy = function(...)
    warn(string.rep('|', 104))
    --print(...)
    if shouldprintargs then
        warn(`|||||| args ||||||`)
        local args = {...};
        for i,v in args do
            if type(v) =='table' then
                warn(`arg{i}`)
                for a,s in v do
                    print(a,s)
                end
            else
                --warn(`arg{i}\n{a} {s}`)
                -- sometimes numbers and functions get passed thru on their own, but those dont really matter i think maybe prolly
            end
        end
    end
    if shouldprintlevels then
        warn(`|||||| levels ||||||`)
        for i = 1, 10 do
            if not isvalidlevel(i) then break end
            warn(`level: {i}`)
            print(debug.info(i, 's'))
        end
    end
    return o(...)
end;
--setstackhidden(dummy, true)
--^^ during this i found out that only calling and directly replacing send functions are detected
-- so it seems that unless ur replacement function has protos (probably), setstackhidden is realistically useless if they add direct caller checks
o = hookfunction(a.sendReliable, dummy)
