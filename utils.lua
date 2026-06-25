local utils = {}
function utils.createherklefiles()
	isfolder = isfolder or is_folder or checkfolder or check_folder or nil;
	makefolder = makefolder or make_folder or folder or nil;
	writefile = writefile or write_file or nil;
	if not isfolder("herkleglobals") then
		makefolder("herkleglobals");
		writefile("herkleglobals/executions.txt", "1");
		writefile("herkleglobals/invited.txt", "false");
	end
end

function utils.addexecution()
	utils.createherklefiles()
	local num=tonumber(readfile("herkleglobals/executions.txt"))
	if num then
		writefile("herkleglobals/executions.txt",tostring(num + 1))
	end
end

function utils.invitetodiscord()
	utils.createherklefiles()
	if readfile("herkleglobals/invited.txt") == ("false" or nil) then
		if not request then
			print("ur executor is terrible, check your clipboard for the discord")
			setclipboard("https://dsc.gg/herkle OR https://discord.gg/uFYfMQGzk8")
			return
		end
		request({
			Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST",
			Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
			Body = game:GetService("HttpService"):JSONEncode({cmd = "INVITE_BROWSER", args = {code = "uFYfMQGzk8"}, nonce = game:GetService("HttpService"):GenerateGUID(false)})
		})
		writefile("herkleglobals/invited.txt", "true")
	end
end

function utils.getglobals(which: string): string
	utils.createherklefiles()
	return which == "executions" and readfile("herkleglobals/executions.txt") or readfile("herkleglobals/invited.txt")
end

function utils.removeherklenoo(shouldwipeconfigs: boolean)
	for i,v in listfiles("") do
		if tostring(v):lower():find("herkle") then
			if shouldwipeconfigs then
				if isfolder(v) then
					delfolder(v)
				elseif isfile(v) then
					delfile(v)
				end
				print("wiped configs")
			end 
			if tostring(v) == "herkleglobals" and isfolder(v) then
				print("removed herkleglobals")
				delfolder(v)
			end
		end
	end
end

--[[function utils.hook(oldref: string, tohook: function, isCnative: boolean, printvarargs: boolean, toreturn: any)
	if not oldref then oldref = o; end
	if not tohook then return end;
	if isCnative then newfunc = newcclosure(function(...)) else newfunc = function(...) end
	local oldref; oldref = hookfunction(tohook, newfunc
		local args = ...
		local packedargs = table.pack(args)
		if printvarargs then
			print(args)
		end
		return toreturn or oldref(args);
	end)
]]
return utils
--[[print(getglobals("executions"), getglobals("invited"))
utils.invitetodiscord()
utils.addexecution()
utils.removeherklenoo(false)
]]
