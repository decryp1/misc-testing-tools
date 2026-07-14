filtergc("function", {Constants = {"I need to wait %* seconds..."}})[1]()
--[[
filters garbage collection for any function with a constant that matches the one given
since bed spawning has a cooldown with an 'error' message, we just look for that, and we've found the function that determines whether or not you can spawn
once we find it (we will), we just fire the first function in the table that filtergc returns.
(since only one function has this constant, only one function will be returned. we can just fire this one function.
]]

getconnections(game:GetService("Players").LocalPlayer.PlayerGui.SpawnGui.Customization.BedButton.Activated)[1].Function()
--[[
the game connects to `...BedButton.Activate:Connect(function(...) end)`
instead of using replicatesignal or firesignal which have been proven to hardly work, we choose the next best thing
since filtergc already finds the Activated callback function, we can use getconnections (or noticeably simpler, getconnection) to find every `...Activated:Connect()` call
once we do this, rbxscriptconnections inside of the returned getconnections table have properties such as .Function and :Fire()
once again, since there's only one connection (and in turn, one function), all we have to do is fire this connections function, and the game handles the rest.
]]
