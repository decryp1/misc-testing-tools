for i,v in getconnections(game:GetService("UserInputService").InputBegan) do
	--print(i,v)
	if v.Function then
		print('func for', i)
		local o; o = hookfunction(v.Function, newcclosure(function(...)
			local args = {...}
			print(...)
			return o(...)
		end))
	end	
end
