--idk if this works but i had an old info bypass and figured thats what booga used to use for packet traceback so here it is
-- i hate you sully
local oldinfo = debug.info
local a = require(game:GetService("ReplicatedStorage").Game.tool.Slash)
debug.info = newcclosure(function(level, field)
    if not checkcaller() then
        if field == "s" then
            return 'game:GetService("ReplicatedStorage").Game.tool.Slash'
        elseif field == "n" then
            return ""
        elseif field == "f" then
            return a
        end
    end
    return oldinfo(level, field)
end)

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
    --^^ when we call send, the game checks who called the send func. below, we patch it, so that the game thinks a module sent it.
end

debug.setinfo(swing,{source = "."}) -- change swing to the name of the function that's sending packets. all are affected, not just swinging
--^^ in the near future, the game may check the actual module name and packet type. for swinging, change '.' to 'ReplicatedStorage.Game.tool'

-- the last method would be patching/replacing require(game:GetService("ReplicatedStorage").Modules.ByteNet.process.client)[1] and [2], and remove the info check.
--[[
the packet assembler already bypasses the checks that the server imposes, since we create our own packets with all bytes preset as normal.
this is because we skip the server's entire encoding process, and we mimic it on our side. the game never sees who is sending it. we skip the line and send the information directly.
the game checks if the caller of the <...>.send() function was an actual modulescript. since debug.info returns a string with a slightly truncated path, such as "ReplicatedStorage.Game.tool" for ...
... normal calls, all we do is replicate it. though the game doesn't actually check the name of the module that sent it (which is the next step for them), they check for any dots in the returned string.
since executors have no real caller, the string the game sees is just "". they check for strings like ".". from there, the fix is obvious.

js saying words bro jesus

later, they're probably going to add more fingerprinting or directly reading the module that called the packet. on top of this, having a list of...
... certain packets that can be sent from certain modules tightens the filter, and makes it harder to bypass. soon soon soon.
]]
