-- Check player and his coords
Citizen.CreateThread(function()
	while true do

		Cache.Player = PlayerPedId()
		Cache.PlyCoo = GetEntityCoords(Cache.Player)


		if Cache.inuniPoly then
			Citizen.Wait(1)
		else
			Citizen.Wait(1500)
		end
	end
end)

-- Get which seats are taken for lapdance
Citizen.CreateThread(function()
	
	while true do 
		
		if Cache.inlapPoly then
			Citizen.Wait(300)
			TriggerServerEvent('kc-unicorn:GetPlayerSeated')
		else
			Citizen.Wait(1000)
		end
	end

end)

-- 
Citizen.CreateThread(function()

	while true do

		while Cache.InLapdance do
			DisableControlAction(2, 0, true)
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, 32, true)
			DisableControlAction(2, 34, true)
			DisableControlAction(2, 8, true)
			DisableControlAction(2, 9, true)
			Citizen.Wait(0)
		end

		while Cache.InLean do
			DisableControlAction(2, 0, true)
			Citizen.Wait(0)
		end

		Citizen.Wait(1000)
	end
end)

--
Citizen.CreateThread(function()

	while true do

		while Cache.InLapdance do
			Citizen.Wait(400)
			if GetEntityHealth(Cache.SpawnPed) <= 0 or IsPedRagdoll(Cache.SpawnPed) or IsPedFleeing(Cache.SpawnPed) then
				FreezeEntityPosition(Cache.SpawnPed, false)
				DrawText2D(Loc('lapStopped'))
				Cache.InLapdance = false
				Cache.lapStop = true
				Citizen.Wait(1000)
				Cache.InCooldown = false
				Citizen.Wait(10000)
				DeleteEntity(Cache.SpawnPed)
			end
		end

		Citizen.Wait(1000)
	end
end)