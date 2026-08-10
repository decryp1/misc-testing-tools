-- #1
local oldinfo = debug.info; debug.info = newcclosure(function(level, field)
    if not checkcaller() then
        if field == "s" then
            return 'game:GetService("ReplicatedStorage").Game.tool.Slash'
        elseif field == "n" then
            return ""
        elseif field == "f" then
            return require(game:GetService("ReplicatedStorage").Game.tool.Slash)
        end
    end
    return oldinfo(level, field)
end)

-- #2
local p=require(game:GetService("ReplicatedStorage").Modules.Packets)
function swing(id:number|string|table)
	local rag={}
	if not id then return end
	if type(id) == "table" then
		for i,v in id do
			v = tonumber(v)
			if v then rag[#rag+1] = {["entityID"] = v} end
		end
	else
		id = tonumber(id)
		if not id then return end
		rag[1] = {["entityID"] = id}
	end
	p.SwingTool.send({["entityIDs"] = rag, ["cframe"] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, ["timestamp"] = game.Workspace:GetServerTimeNow()})
end

-- #3
debug.setinfo(swing,{source = "."})

-- #4
setstackhidden(swing, true)

-- #5
local threadref, scriptref, senv = nil, nil, nil
for i,v in getallthreads() do
    local sname = getscriptfromthread(v)
    if sname --[[and sname.Name:lower():find('swing', 1, true)]] then
        threadref = v;
        scriptref = sname;
        senv = getsenv(sname);
    end
end

trampoline_call(
    packets[`<packetname>`].send,
    {currentline = math.random(40, 120), --[[func = require(game:GetService("ReplicatedStorage").Game.tool.Slash)]]},
    {script = scriptref, identity = 2, env = senv, thread = threadref},
)

--#6
-- replace/hook sendreliable/unreliable + remove the info check yourself

--#7
-- encode your own packets entirely. mimic the clients entire encoding process and send normal buffers to the server.
