a = require(game:GetService("ReplicatedStorage").Modules.Clock)
setreadonly(a,false)
if isfunctionhooked(a.tick) then restorefunction(a.tick) end
local o; o = hookfunction(a.tick, function(...)
    local args = {...}
    local r1, r2 = args[1], args[2];
    local s,d,f = info(r1,'sln')
    local stringm = string.match(s, "{^%.}+$") or s
    local dummy
    if f == "" then
        dummy = `{stringm}:{d}`
    else
        dummy = `{stringm}.{f}`
    end
    print(`stringm {stringm}`)
    print(`dummy {dummy}`)
    --[[for i,v in args do
        print(`asdasdasd {i} {v}`)
    end]]

    return o(...)
end)
setstackhidden(o,true)
