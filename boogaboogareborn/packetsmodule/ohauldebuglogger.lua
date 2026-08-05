flag = false
for i,v in getrenv().debug do
	if not i:find("profile") --[[and not i:find("info")]] then
		if isfunctionhooked(v) then restorefunction(v) end
		local o;o = hookfunction(v, function(...)
			if checkcaller() then return o(...) end
			if flag then return o(...) end
			local args = {...}
			print(`{i} was called with args`, ...)
			for a,s in args do
				if typeof(s) == "function" and islclosure(s) then
					for d,f in getgc(false) do
						if type(f) == "function" and islclosure(f) and getfunctionhash(f) == getfunctionhash(s) then
							warn(`found {i} func argument`)
							flag = true
							print(debug.traceback())
							flag = false
						end
					end
				end
			end
			return o(...)
		end)
	end
end
--[[
these hooks error when used too early, because that's when the game first uses setmemorycategory. it's also the only setmemc call i believe.
upon releasing this i have not yet checked if the game uses getmemorycategory on callers to check if it's from an executors closure, but it's possible.
(for executor calls, getmemorycategory (like debug.getinfo for stack traces) return a blank string ("")).
if the game has multiple memcategories, they can check the name of your caller's memc and flag you based on what did and did not pass.
then again, calling setmemc from an executor closure triggeres getmemc, traceback, fenv, and getinfo calls, which can obviously be used against you.

in the future booga booga is more than likely going to trace callers of specific packets, and if a specific module/caller is not seen in the stack trace, ...
... the game can flag you then and there, and addorn you to a long list of others users who have been flagged by scripts that are not herkle hub :yawn:

also, the released methods for stack trace spoofing in this repo are not adjusted to genuine stack LEVEL checks, which means the game can just implement a ...
... simple second-level stack trace at each step and determine if it's from a module or not. if even one caller or link in the chain is broken, you're flagged.
herkle hub already has a bypass for this though so js use my script losers
]]
--[[for i, v in pairs(getrenv().debug) do
	print(i, v)
	if not (i == "profilebegin" or i == "profileend") then
		local o; o = hookfunction(v, newcclosure(function(...)
			print(i, "was called")
			return o(...)
		end))
	end
end


for i, v in pairs(getrenv().debug) do
	print(i, v)
	if not (i == "profilebegin" or i == "profileend" or i == "traceback") then -- traceback for insight, wow recursion wow
		local o; o = hookfunction(v, newcclosure(function(...)
			print(i, "was called");
			print(debug.traceback())
			return o(...)
		end))
	end
end
]]
