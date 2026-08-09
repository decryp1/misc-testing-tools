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
--^^ at runtime, the client can store info and compare the current info to the first logged info function when we send packets.
--^^ this method works, but it is detectable

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

debug.setinfo(swing,{source = "."})
--^^ using other options for info can be used to detect partial spoofing. only the s param is used, bur slnaf are all possible.
--^^ this method works, but is detectable if not modified correctly

setstackhidden(swing, true)
--^^ since this removes the stack level the game WOULD have seen entirely, this method currently bypasses all info checks that booga ever has or ever will implement.
--^^ this method works and is genuinely undetectable from the swing context

-- the last method would be patching/replacing require(game:GetService("ReplicatedStorage").Modules.ByteNet.process.client)[1] and [2], and remove the info check.
-- this last method can be detected if the game stores the reliable and unreliable funcs, and just compares them every time .send is called, so dont use it.
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
