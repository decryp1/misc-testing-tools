for i, v in pairs(getrenv().debug) do
	print(i, v)
	if not (i == "profilebegin" or i == "profileend") then
		local o; o = hookfunction(v, newcclosure(function(...)
			print(i, "was called")
			return o(...)
		end))
	end
end
-- does nothing
