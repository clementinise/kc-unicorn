-- Import QBCore
local QBCore
if Config.Framework == "QBCore" then
	QBCore = exports['qb-core']:GetCoreObject()
end

Cache = {}

local PlayerSitted = false
local PlayerSeated = 0

-- Server Seat Locales
local Seat1 = false
local Seat2 = false
local Seat3 = false
local Seat4 = false
local Seat5 = false
local Seat6 = false
local Seat7 = false

-- Client Seat Locales
local Seat1Taken = false
local Seat2Taken = false
local Seat3Taken = false
local Seat4Taken = false
local Seat5Taken = false
local Seat6Taken = false
local Seat7Taken = false

local SpawnObject, PreviousCamViewMode, factor, lines, PlayerMoney

-- PolyZones
local uniPoly = BoxZone:Create(vector3(115.01, -1293.19, 28.27), 25.1, 32.0, {
	name = "uniPoly",
	heading = 8,
	debugPoly = Config.DebugPolyzones,
	minZ = 22.37,
	maxZ = 31.17
})
local lapPoly = BoxZone:Create(vector3(117.06, -1294.85, 29.27), 1.24, 1.0, {
	name = "lapPoly",
	heading = 30,
	debugPoly = Config.DebugPolyzones,
	minZ = 28.17,
	maxZ = 30.57
})
local leanPoly = BoxZone:Create(vector3(113.22, -1286.74, 28.46), 8.4, 6.4, {
	name="leanPoly",
	heading=30,
	debugPoly = Config.DebugPolyzones,
	minZ=27.26,
	maxZ=28.66
})
local leanPoly1 = BoxZone:Create(vector3(114.31, -1289.97, 28.26), 0.2, 2.5, {
	name="leanPoly1",
	heading=30,
	debugPoly = Config.DebugPolyzones,
	minZ=27.26,
	maxZ=28.66
})
local leanPoly2 = BoxZone:Create(vector3(114.75, -1285.88, 28.26), 4.2, 0.2, {
	name="leanPoly2",
	heading=30,
	debugPoly = Config.DebugPolyzones,
	minZ=27.26,
	maxZ=28.66
})
local leanPoly3 = BoxZone:Create(vector3(110.98, -1284.24, 28.26), 0.2, 2.5, {
	name="leanPoly3",
	heading=30,
	debugPoly = Config.DebugPolyzones,
	minZ=27.26,
	maxZ=28.66
})

-- Create Blips
Citizen.CreateThread(function()
	LoadDict("mini@strip_club@pole_dance@pole_dance1", false)
	LoadDict("mini@strip_club@pole_dance@pole_dance2", false)

	if Config.Blip then

		local blip = AddBlipForCoord(Config.BlipCoord.x, Config.BlipCoord.y, Config.BlipCoord.z)

		SetBlipSprite (blip, Config.BlipStripclub.Sprite)
		SetBlipDisplay(blip, Config.BlipStripclub.Display)
		SetBlipScale  (blip, Config.BlipStripclub.Scale)
		SetBlipColour (blip, Config.BlipStripclub.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.BlipName)
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent('kc-unicorn:showNotify')
AddEventHandler('kc-unicorn:showNotify', function(notify)
	ShowAboveRadarMessage(notify)
end)

function ShowAboveRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

function DrawText3D(xyz, text)
	
    if Config.Text == 'Better3D' then
        AdvancedDrawText3D(xyz, text)
        return
	elseif Config.Text == '2D' then
		DrawText2D(text)
		return
	elseif Config.Text == 'None' then
		return
	elseif Config.Text ~= '3D' then
		DrawText2D('Config.Text is not correctly configured.')
		return
    end

	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(xyz, 0)
    DrawText(0.0, 0.0)
    DrawRect(0.0, 0.0115*lines, 0.017+ factor, 0.028*lines, 0, 0, 0, 75)
    ClearDrawOrigin()
	
end

function AdvancedDrawText3D(xyz, text)

    AddTextEntry(GetCurrentResourceName(), text)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(2, false, false, -1)

    SetFloatingHelpTextWorldPosition(1, xyz)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)

end

function DrawText2D(text)

    AddTextEntry(GetCurrentResourceName(), text)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(0, 0, true, -1)

end

Citizen.CreateThread(function()

	uniPoly:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
		Cache.inuniPoly = isPointInside
		if isPointInside then
			lapPoly:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
				Cache.inlapPoly = isPointInside
				if isPointInside then
					FactorAndLines(Loc('LapText', Config.LapDanceCost))
				end
				TriggerServerEvent('kc-unicorn:GetPlayerSeated')
			end)
			leanPoly:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
				Cache.inleanPoly = isPointInside
				if isPointInside then
					FactorAndLines(Loc('Lean'))
				end
			end)
		end
	end, 2000)

end)

-- Better to not repeat this in DrawText3D, save a bit of perf ¯\_(ツ)_/¯
function FactorAndLines(text)

	factor = (string.len(text)) / 370
	if Config.SelectStrippers and Cache.inlapPoly then
		lines = 2
	else
		lines = 1
	end
	
end

---- Lapdance

Citizen.CreateThread(function()
	
	local InputLeft, InputRight
	
	local text = Loc('LapText', Config.LapDanceCost)
	local CustomStrippers = 0
	local Stripper = 1

	for _ in pairs(Config.Strippers) do CustomStrippers = CustomStrippers + 1 end

	if Config.Framework == "Standalone" then
		text = Loc('StandaloneLapText')
	end

	
	if Config.Text == '3D' then
		Input = '~r~E~w~ - '
		InputLeft = '\n~b~ {-- ~w~'
		InputRight = '~b~ --} ~w~'
	else
		Input = '~INPUT_CONTEXT~ '
		InputLeft = '\n~INPUT_CELLPHONE_LEFT~ '
		InputRight = '   ~INPUT_CELLPHONE_RIGHT~'
	end

    while true do

		if Config.SelectStrippers then
			if Stripper > CustomStrippers then
				Stripper = 1
			elseif Stripper <= 0 then
				Stripper = CustomStrippers
			end
			DrawnText = Input .. text .. InputLeft .. Config.Strippers[Stripper].Name .. InputRight
		else
			DrawnText = Input .. text 
		end

    	if not Cache.inuniPoly then 
			Citizen.Wait(800)
		else
			Citizen.Wait(0)
		end

        if Cache.inuniPoly and not Cache.InCooldown and not Cache.InLean then
            if Config.LapMarker then 
				DrawMarker(2, 117.04, -1294.8, 29.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 255, 255, 100, false, true, 2, false, false, false, false)
			end
            if Cache.inlapPoly then
				DrawText3D(vector3(117.04, -1294.8, 29.25), DrawnText)
				if IsControlJustPressed(0, 38) then
					if PlayerSeated >= 7 then
						QBCore.Functions.Notify(Loc('AllPlacesTaken'), "error")
					else
						TriggerServerEvent('kc-unicorn:buy', Stripper)
						Citizen.Wait(500)
					end
				elseif IsControlJustPressed(0, 174) then
					Stripper = Stripper - 1
				elseif IsControlJustPressed(0, 175) then
					Stripper = Stripper + 1
				end
        	end
    	end
    end
end)

function PlayerFunc(xyz, heading, camheading, xyz2, wait)
	Dict = LoadDict("mini@strip_club@lap_dance_2g@ld_2g_reach", true)
	Anim = "ld_2g_sit_idle"
	
	PlayerSitted = true

	SetFollowPedCamViewMode(4)

	SetEntityCoords(Cache.Player, xyz)
	FreezeEntityPosition(Cache.Player, true)
	SetEntityHeading(Cache.Player, heading)
	TaskPlayAnim(Cache.Player, Dict, Anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	SetGameplayCamRelativeHeading(camheading)

	while Cache.InLapdance do
		if GetEntityAnimCurrentTime(Cache.Player, Dict, Anim) >= 0.97 and GetEntityAnimCurrentTime(Cache.Player, Dict, Anim) < 1.0 then
			TaskPlayAnim(Cache.Player, Dict, Anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		end
		Citizen.Wait(50)
	end

	FreezeEntityPosition(Cache.Player, false)
	PlayerSitted = false

	if not Cache.lapStop then
		SetEntityCoords(Cache.Player, xyz2)
		Citizen.Wait(200)
		SetFollowPedCamViewMode(PreviousCamViewMode)
		TaskGoToCoordAnyMeans(Cache.Player, 117.48, -1294.82, 28.43, 1.0, 0, 0, 786603, 1.0)
		Citizen.Wait(wait)
	end

end

function StripperFunc(ped, heading, heading2, heading3, xyz, xyz2, xyz3, xyz4, wait)

	SetEntityHeading(ped, heading)
	FreezeEntityPosition(ped, true)
	TaskGoToCoordAnyMeans(Cache.Player, xyz, 1.0, 0, 0, 786603, 1.0)
	Citizen.Wait(wait)

	Repeatcount = -13
	Repeatcount2 = 0

	repeat
		Citizen.Wait(200)
		Repeatcount = Repeatcount + 1
		Repeatcount2 = Repeatcount2 + 1
		if Repeatcount == 17 then
			TaskPlayAnim(Cache.SpawnPed, LoadDict("mini@strip_club@idles@stripper", true), "stripper_idle_02", 8.0, -8.0, -1, 0, 0, false, false, false)
			Repeatcount = 0
		end
		if Repeatcount2 >= 160 then
			DeleteEntity(Cache.SpawnPed)
		end
	until PlayerSitted or Cache.lapStop

	FreezeEntityPosition(ped, false)
	TaskGoToCoordAnyMeans(ped, xyz2, 174.93, 0, 0, 0, 0xbf800000)
	Citizen.Wait(1000)

	TaskGoToCoordAnyMeans(ped, xyz3, 174.93, 0, 0, 0, 0xbf800000)
	Citizen.Wait(2100)

	FreezeEntityPosition(ped, true)
	SetEntityHeading(ped, heading2)
	
	StripperAnim()
	
	if not lapStop then
		TaskGoToCoordAnyMeans(ped, xyz4, 174.93, 0, 0, 0, 0xbf800000)
		Wait(2000)

		TaskPlayAnim(ped, LoadDict("mini@strip_club@idles@stripper", true), "stripper_idle_02", 8.0, -8.0, -1, 0, 0, false, false, false)
		SetEntityHeading(ped, heading3)
	end

	Cache.InLapdance = false

	Citizen.Wait(10000)

end

function StripperAnim()

	FreezeEntityPosition(Cache.SpawnPed, false)
	
	if not Cache.lapStop then
		TaskPlayAnim(Cache.SpawnPed, LoadDict("mini@strip_club@private_dance@part1", true), "priv_dance_p1", 8.0, -8.0, -1, 0, 0, false, false, false)
		Wait(22300)
	end

	if not Cache.lapStop then
		TaskPlayAnim(Cache.SpawnPed, LoadDict("mini@strip_club@private_dance@part2", true), "priv_dance_p2", 8.0, -8.0, -1, 0, 0, false, false, false)
		Wait(31200)
	end

	if not Cache.lapStop then
		TaskPlayAnim(Cache.SpawnPed, LoadDict("mini@strip_club@private_dance@exit", true), "priv_dance_exit", 8.0, -8.0, -1, 0, 0, false, false, false)
		Wait(8000)
	end
end

function LoadDict(Dict, Bool)
	RequestAnimDict(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(20)
		RequestAnimDict(Dict)
    end

	if Bool then
    	return Dict
	end
end

RegisterNetEvent('kc-unicorn:lapdance')
AddEventHandler('kc-unicorn:lapdance', function(PlayerMoney, PlayerBirthdate, TodayDate, Stripper)
	Birthdate = {}
	Date = {}
	Cache.lapStop = false
	Cache.InLapdance = true
	PreviousCamViewMode = GetFollowPedCamViewMode(Cache.Player)

	if Config.Framework == 'QBCore' then
		index = 1
		for value in string.gmatch(PlayerBirthdate, "[^-]+") do
			Birthdate[index] = value
			index = index + 1
		end

		index = 1
		for value in string.gmatch(TodayDate, "[^-]+") do
			Date[index] = value
			index = index + 1
		end

		Year = Date[1] - Birthdate[1] - 4
		Month = Date[2] - Birthdate[2]
		Day = Date[3] - Birthdate[3]
	else
		Year = 1000
		Month = 0
		Day = 0
	end
		
	RequestModel(Config.Strippers[Stripper].Model)
	Cache.InCooldown = true
	while not HasModelLoaded(1846523796) do
		Wait(20)
	end
	Citizen.Wait(200)

	SetEntityHeading(Cache.Player, 120.18)

	if not Seat1 and not Seat1Taken then
		Seat1Taken = true
		TriggerServerEvent('kc-unicorn:Seat1')
	elseif not Seat2 and not Seat2Taken then
		Seat2Taken = true
		TriggerServerEvent('kc-unicorn:Seat2')
	elseif not Seat3 and not Seat3Taken then
		Seat3Taken = true
		TriggerServerEvent('kc-unicorn:Seat3')
	elseif not Seat4 and not Seat4Taken then
		Seat4Taken = true
		TriggerServerEvent('kc-unicorn:Seat4')
	elseif not Seat5 and not Seat5Taken then
		Seat5Taken = true
		TriggerServerEvent('kc-unicorn:Seat5')
	elseif not Seat6 and not Seat6Taken then
		Seat6Taken = true
		TriggerServerEvent('kc-unicorn:Seat6')
	elseif not Seat7 and not Seat7Taken then
		Seat7Taken = true
		TriggerServerEvent('kc-unicorn:Seat7')
	end

	if Seat1Taken then
		SpawnObject = CreatePed(4, 1846523796, 117.1, -1301.25, 28.05, 303.19, true, false)
	elseif Seat2Taken then
		SpawnObject = CreatePed(4, 1846523796, 114.98, -1302.43, 28.05, 303.19, true, false)
	elseif Seat3Taken then
		SpawnObject = CreatePed(4, 1846523796, 112.89, -1303.69, 28.05, 303.19, true, false)
	elseif Seat4Taken then
		SpawnObject = CreatePed(4, 1846523796, 111.32, -1304.58, 28.05, 303.19, true, false)
	elseif Seat5Taken then
		SpawnObject = CreatePed(4, 1846523796, 110.89, -1303.84, 28.05, 303.19, true, false)
	elseif Seat6Taken then
		SpawnObject = CreatePed(4, 1846523796, 112.42, -1303.04, 28.05, 303.19, true, false)
	elseif Seat7Taken then
		SpawnObject = CreatePed(4, 1846523796, 114.29, -1301.91, 28.05, 303.19, true, false)
	end

	Citizen.Wait(100)
	Cache.SpawnPed = SpawnObject
	FreezeEntityPosition(Cache.SpawnPed, true)

	SetPedComponentVariation(Cache.SpawnPed, 1, Config.Strippers[Stripper].Drawables.Head) -- Head
	SetPedComponentVariation(Cache.SpawnPed, 2, Config.Strippers[Stripper].Drawables.Hair, Config.Strippers[Stripper].Textures.HairTex) -- Hair
	SetPedComponentVariation(Cache.SpawnPed, 3, Config.Strippers[Stripper].Drawables.Torso) -- Torso
	SetPedComponentVariation(Cache.SpawnPed, 4, Config.Strippers[Stripper].Drawables.Shoes, Config.Strippers[Stripper].Textures.ShoesTex) -- Shoes
	SetPedComponentVariation(Cache.SpawnPed, 6, Config.Strippers[Stripper].Drawables.Underwear, Config.Strippers[Stripper].Textures.UnderwearTex) -- Underwear
	SetPedComponentVariation(Cache.SpawnPed, 10, 0) -- Decals ??
	SetPedComponentVariation(Cache.SpawnPed, 11, Config.Strippers[Stripper].Drawables.Torso2) -- Auxiliary parts for torso

	if Year >= Config.NudityAge + 1 then
		underage = false
	elseif Year == Config.NudityAge then
		if Month == 0 and Day <= 0 then
			underage = false
		else
			underage = true
		end
	else
		underage = true
	end

	if underage then
		SetPedComponentVariation(Cache.SpawnPed, 8, 0, Config.Strippers[Stripper].Textures.BraTex) -- Not Topless
	elseif not underage and not Config.Nudity then
		SetPedComponentVariation(Cache.SpawnPed, 8, 0, Config.Strippers[Stripper].Textures.BraTex) -- Not Topless
	else
		SetPedComponentVariation(Cache.SpawnPed, 8, 1) -- Topless
	end
	print("Shoes | Drawable: " .. GetPedDrawableVariation(Cache.SpawnPed, 4), "Drawables: " .. GetNumberOfPedDrawableVariations(Cache.SpawnPed, 4), "Texture: " .. GetPedTextureVariation(Cache.SpawnPed, 4), "Textures: " .. GetNumberOfPedTextureVariations(Cache.SpawnPed, 4), "Palette: " .. GetPedPaletteVariation(Cache.SpawnPed, 4))
	print("Underwear | Drawable: " .. GetPedDrawableVariation(Cache.SpawnPed, 6), "Drawables: " .. GetNumberOfPedDrawableVariations(Cache.SpawnPed, 6), "Texture: " .. GetPedTextureVariation(Cache.SpawnPed, 6), "Textures: " .. GetNumberOfPedTextureVariations(Cache.SpawnPed, 6), "Palette: " .. GetPedPaletteVariation(Cache.SpawnPed, 6))
	print("Underwear?? | Drawable: " .. GetPedDrawableVariation(Cache.SpawnPed, 10), "Drawables: " .. GetNumberOfPedDrawableVariations(Cache.SpawnPed, 10), "Texture: " .. GetPedTextureVariation(Cache.SpawnPed, 10), "Textures: " .. GetNumberOfPedTextureVariations(Cache.SpawnPed, 10), "Palette: " .. GetPedPaletteVariation(Cache.SpawnPed, 10))

	if Config.Framework ~= 'Standalone' then
		if PlayerMoney >= Config.LegMoney then
			SetPedComponentVariation(Cache.SpawnPed, 9, 1)
		else
			SetPedComponentVariation(Cache.SpawnPed, 9, 0)
		end
	end

	if Config.Debug then
		print("------ kc-unicorn : Debug print start ------")
		print("Player cash: ", PlayerMoney, "Player birthdate: ", PlayerBirthdate, "Today date: ", TodayDate)
		print('Config.Language is set to: ' .. Config.Language)
		print('Framework used: ' .. Config.Framework)
		print(Config.Language .. "", lg)
		--[[ print("Birthdate split: ", Birthdate[1], Birthdate[2], Birthdate[3])
		print("Date split: ", Date[1], Date[2], Date[3]) ]]
		print("Year: ", Year, "Month: ", Month, "Day: ", Day)
		print(GetPedDrawableVariation(Cache.SpawnPed, 1), "Head")
		print(GetPedDrawableVariation(Cache.SpawnPed, 2), "Beard")
		print(GetPedDrawableVariation(Cache.SpawnPed, 3), "Torso")
		print(GetPedDrawableVariation(Cache.SpawnPed, 4), "Legs")
		print(GetPedDrawableVariation(Cache.SpawnPed, 5), "Hands")
		print(GetPedDrawableVariation(Cache.SpawnPed, 6), "Foot")
		print(GetPedDrawableVariation(Cache.SpawnPed, 7), "???")
		print(GetPedDrawableVariation(Cache.SpawnPed, 8), "Accessories 1")
		print(GetPedDrawableVariation(Cache.SpawnPed, 9), "Accessories 2")
		print(GetPedDrawableVariation(Cache.SpawnPed, 10), "Decals")
		print(GetPedDrawableVariation(Cache.SpawnPed, 11), "Auxiliary parts for torso")
		print('')
		if Config.NudityAge ~= 0 then
			if underage then
				print("Player is underage")
			else
				print("Player isn't underage")
			end
		end
		if not Config.Nudity and underage then
			print("Stripper isn't topless")
		elseif not Config.Nudity and not underage then
			print("Stripper isn't topless")
		else
			print("Stripper is topless")
		end
		print("Player in lap dance: " .. PlayerSeated)
		print("------ kc-unicorn : Debug print end ------")
	end

	TaskPlayAnim(Cache.SpawnPed, LoadDict("mini@strip_club@idles@stripper", true), "stripper_idle_02", 8.0, -8.0, -1, 0, 0, false, false, false)

	SetEntityCoords(Cache.Player, 116.88, -1295.04, 28.42)

	------------------- First seat ----------------------
	if Seat1Taken then
		StripperFunc(Cache.SpawnPed, 303.19, 216.6, 308.6, vector3(118.71, -1301.93, 28.42), vector3(118.0, -1300.3, 28.17), vector3(118.74, -1301.91, 29.27), vector3(117.1, -1301.25, 28.05), 4900)

		Seat1Taken = false
		TriggerServerEvent('kc-unicorn:RemoveSeat1')

	------------------- Second seat ----------------------
	elseif Seat2Taken then
		StripperFunc(Cache.SpawnPed, 303.19, 216.6, 308.6, vector3(116.67, -1303.35, 29.27), vector3(115.85, -1302.02, 29.02), vector3(116.25, -1302.85, 29.27), vector3(114.98, -1302.43, 28.05), 6000)

		Seat2Taken = false
		TriggerServerEvent('kc-unicorn:RemoveSeat2')

	------------------- Third seat ----------------------
	elseif Seat3Taken then
		StripperFunc(Cache.SpawnPed, 303.19, 216.6, 308.6, vector3(114.64, -1304.54, 29.27), vector3(113.56, -1302.94, 29.02), vector3(114.33, -1304.23, 29.27), vector3(112.89, -1303.69, 28.05), 7000)
		Seat3Taken = false
		TriggerServerEvent('kc-unicorn:RemoveSeat3')

	------------------- Fourth seat ----------------------
	elseif Seat4Taken then
		StripperFunc(Cache.SpawnPed, 303.19, 216.6, 308.6, vector3(112.66, -1305.52, 29.27), vector3(111.82, -1304.17, 29.02), vector3(112.42, -1305.11, 29.27), vector3(111.32, -1304.58, 28.05), 8000)
		Seat4Taken = false
		TriggerServerEvent('kc-unicorn:RemoveSeat4')

	------------------- Fifth seat ----------------------
	elseif Seat5Taken then
		StripperFunc(Cache.SpawnPed, 303.19, 29.5, 308.6, vector3(111.18, -1302.62, 29.27), vector3(111.46, -1303.61, 29.02), vector3(111.17, -1302.81, 29.27), vector3(110.89, -1303.84, 28.05), 8000)
		Seat5Taken = false
		TriggerServerEvent('kc-unicorn:RemoveSeat5')

	------------------- Sixth seat ----------------------
	elseif Seat6Taken then
		StripperFunc(Cache.SpawnPed, 303.19, 29.5, 308.6, vector3(112.64, -1301.27, 29.27), vector3(113.35, -1302.36, 29.02), vector3(112.91, -1301.62, 29.27), vector3(112.42, -1303.04, 28.05), 7000)
		Seat6Taken = false
		TriggerServerEvent('kc-unicorn:RemoveSeat6')

	------------------- Seventh seat ----------------------
	elseif Seat7Taken then
		StripperFunc(Cache.SpawnPed, 303.19, 29.5, 308.6, vector3(114.73, -1300.41, 29.27), vector3(115.08, -1301.39, 29.02), vector3(114.88, -1300.64, 29.27), vector3(114.29, -1301.91, 28.05), 7000)
		Seat7Taken = false
		TriggerServerEvent('kc-unicorn:RemoveSeat7')
	end

	TriggerServerEvent('kc-unicorn:idle')
	Citizen.Wait(1000)
	Cache.InCooldown = false

	if not Cache.lapStop then
		DeleteEntity(Cache.SpawnPed)
	end
end)

Citizen.CreateThread(function()

	while true do

		if not Cache.InLapdance then
			Citizen.Wait(1000)
		else
			Citizen.Wait(0)
		end

		if Seat1Taken then
			local sitdist = #(Cache.PlyCoo - vector3(118.75, -1301.97, 28.42))
			if sitdist < 1 and Cache.InLapdance then
				PlayerFunc(vector3(119.06, -1302.66, 27.78), 40.0, -10.0, vector3(118.75, -1301.99, 28.42), 5000)
			end
		elseif Seat2Taken then
			local sitdist = #(Cache.PlyCoo - vector3(116.59, -1303.01, 28.42))
			if sitdist < 1 and Cache.InLapdance then
				PlayerFunc(vector3(116.9, -1303.75, 27.78), 40.0, -10.0, vector3(116.59, -1303.01, 28.42), 6200)
			end
		elseif Seat3Taken then
			local sitdist = #(Cache.PlyCoo - vector3(114.64, -1304.54, 29.27))
			if sitdist < 1 and Cache.InLapdance then
				PlayerFunc(vector3(114.86, -1305.0, 27.78), 40.0, -10.0, vector3(114.64, -1304.54, 29.27), 6800)
			end
		elseif Seat4Taken then
			local sitdist = #(Cache.PlyCoo - vector3(112.66, -1305.52, 29.27))
			if sitdist < 1 and Cache.InLapdance then
				PlayerFunc(vector3(113.08, -1306.17, 27.78), 40.0, -10.0, vector3(112.66, -1305.52, 29.27), 7500)
			end
		elseif Seat5Taken then
			local sitdist = #(Cache.PlyCoo - vector3(111.18, -1302.62, 29.27))
			if sitdist < 1 and Cache.InLapdance then
				PlayerFunc(vector3(110.57, -1301.82, 27.78), 216.6, -10.0, vector3(111.18, -1302.62, 29.27), 7500)
			end
		elseif Seat6Taken then
			local sitdist = #(Cache.PlyCoo - vector3(112.64, -1301.27, 29.27))
			if sitdist < 1 and Cache.InLapdance then
				PlayerFunc(vector3(112.34, -1300.76, 27.78), 216.6, -10.0, vector3(112.64, -1301.27, 29.27), 6800)
			end
		elseif Seat7Taken then
			local sitdist = #(Cache.PlyCoo - vector3(114.73, -1300.41, 29.27))
			if sitdist < 1 and Cache.InLapdance then
				PlayerFunc(vector3(114.27, -1299.66, 27.78), 216.6, -10.0, vector3(114.73, -1300.41, 29.27), 6000)
			end
		end
		
		DisableControlAction(2, 0, false)
	end
end)

RegisterNetEvent("kc-unicorn:SetPlayerSeated")
AddEventHandler("kc-unicorn:SetPlayerSeated", function(GetPlayerSeated, Seat1Busy,  Seat2Busy, Seat3Busy, Seat4Busy, Seat5Busy, Seat6Busy, Seat7Busy)
	Seat1 = Seat1Busy
	Seat2 = Seat2Busy
	Seat3 = Seat3Busy
	Seat4 = Seat4Busy
	Seat5 = Seat5Busy
	Seat6 = Seat6Busy
	Seat7 = Seat7Busy
	PlayerSeated = GetPlayerSeated
end)

--------

---- Lean

Citizen.CreateThread(function()

	if Config.Text == '3D' then
		Input = '~r~E~w~ - '
	else
		Input = '~INPUT_CONTEXT~ '
	end

	while true do
		if Cache.inleanPoly then
			if leanPoly1:isPointInside(Cache.PlyCoo) then
				Citizen.Wait(1)
				DrawText3D(Cache.PlyCoo, Input .. Loc('Lean'))
				if IsControlJustReleased(0, 51) then
					LeanStart(29.0)
				end
			elseif leanPoly2:isPointInside(Cache.PlyCoo) then
				Citizen.Wait(1)
				DrawText3D(Cache.PlyCoo, Input .. Loc('Lean'))
				if IsControlJustReleased(0, 51) then
					LeanStart(116.2)
				end
			elseif leanPoly3:isPointInside(Cache.PlyCoo) then
				Citizen.Wait(1)
				DrawText3D(Cache.PlyCoo, Input .. Loc('Lean'))
				if IsControlJustReleased(0, 51) then
					LeanStart(210.0)
				end
			else
				Citizen.Wait(200)
			end
		else
			Citizen.Wait(200)
		end
	end
end)

function LoadModel(model)
	model = GetHashKey(model)

    if not HasModelLoaded(model) and IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(20)
        end
    end
end

function LeanStart(PlyHeading)
	
	local text = Loc('LeanNotice', Config.ThrowCost)
	LoadModel("prop_anim_cash_note_b")
	local is_female = function()
		return(GetEntityModel(Cache.Player) == "mp_f_freemode_01" and "_female" or "")
	end

	if Config.Framework == "Standalone" then
		text = Loc('StandaloneLeanNotice')
	end

	SetEntityCoordsNoOffset(Cache.Player, Cache.PlyCoo)
	FreezeEntityPosition(Cache.Player, true)
	SetEntityHeading(Cache.Player, PlyHeading)
	Cache.InLean = true
	Wait(50)

	TaskPlayAnim(Cache.Player, LoadDict("mini@strip_club@leaning@enter", true), "enter" .. is_female(), 8.0, -8.0, -1, 0, 0, false, false, false)
	Wait(2750)
	PreviousCamViewMode = GetFollowPedCamViewMode(Cache.Player)
	SetFollowPedCamViewMode(4)
	SetGameplayCamRelativeHeading(0.0)
	TaskPlayAnim(Cache.Player, LoadDict("mini@strip_club@leaning@base", true), "base" .. is_female(), 8.0, -8.0, -1, 1, 0, false, false, false)

	while true do
		Wait(0)

		DrawText2D(text)
		if IsControlJustReleased(0, 22) then
			if Config.Framework == "QBCore" then
				PlayerData = QBCore.Functions.GetPlayerData()
				PlayerMoney = PlayerData.money["cash"]
			elseif Config.Framework == "ESX" then
				TriggerServerEvent('kc-unicorn:esxmoney')
			elseif Config.Framework == "Standalone" then
				PlayerMoney = Config.ThrowCost + 1
			end
			repeat
				Citizen.Wait(100)
			until PlayerMoney ~= nil
			if Config.Debug then
				print("Player money: " .. PlayerMoney, "Throw cost: " .. Config.ThrowCost)
			end
			if PlayerMoney >= Config.ThrowCost then
				
				TriggerServerEvent('kc-unicorn:leanthrow')
				local pos = GetPedBoneCoords(Cache.Player, 28422, 0.0, 0.0, 0.0)
				local cash = CreateObject("prop_anim_cash_note_b", pos, true, false, false)
				SetEntityAlpha(cash, 0, false)
				AttachEntityToEntity(cash, Cache.Player, GetPedBoneIndex(Cache.Player, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				TaskPlayAnim(Cache.Player, LoadDict("mini@strip_club@leaning@toss", true), "toss" .. is_female(), 8.0, -8.0, -1, 2, 0, false, false, false)
				Citizen.Wait(150)
				SetEntityAlpha(cash, 255, false)
				while true do
					if GetEntityAnimCurrentTime(Cache.Player, "mini@strip_club@leaning@toss", "toss" .. is_female()) >= 0.74 then
						local alphaLevel = 255
						repeat
						SetEntityAlpha(cash, alphaLevel, false)
						alphaLevel = alphaLevel - 51
						Citizen.Wait(40)
						until(alphaLevel == 0)
						DeleteEntity(cash)
						break
					end
					Citizen.Wait(50)
				end
				TaskPlayAnim(Cache.Player, LoadDict("mini@strip_club@leaning@base", true), "base" .. is_female(), 8.0, -8.0, -1, 1, 0, false, false, false)

			else
				if Config.Framework == 'QBCore' then
					QBCore.Functions.Notify(Loc('NotEnoughCashLean'), "error")
				else
					TriggerEvent('kc-unicorn:showNotify', Loc('NotEnoughCashLean'))
				end
			end
		elseif IsControlJustReleased(0, 51) then
			break
		end
	end
	
	Cache.InLean = false
	SetFollowPedCamViewMode(PreviousCamViewMode)
	Wait(100)
	TaskPlayAnim(Cache.Player, LoadDict("mini@strip_club@leaning@exit", true), "exit" .. is_female(), 8.0, -8.0, -1, 0, 0, false, false, false)
	FreezeEntityPosition(Cache.Player, false)
end

--------

---- ????


RegisterNetEvent('kc-unicorn:poledancescene')
AddEventHandler('kc-unicorn:poledancescene', function(ped, number)
	PedPole = NetworkGetEntityFromNetworkId(ped)
	local scene = NetworkCreateSynchronisedScene(vector3(112.65, -1286.74, 28.5), vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(PedPole, scene, 'mini@strip_club@pole_dance@pole_dance'..number, 'pd_dance_0'..number, 1.5, -4.0, 1, 1, 1148846080, 0)
	NetworkStartSynchronisedScene(scene)
	Citizen.Wait(30000)
	TriggerServerEvent('kc-unicorn:poledancestop')
end)


--------

---- Debug

Citizen.CreateThread(function()
	local Count = 0
	while true do 
		
		Citizen.Wait(Config.MoreDebugRefreshTime*1000)
		if Cache.inuniPoly and Config.MoreDebug then
				print("In Unicorn PolyZone: " .. tostring(Cache.inuniPoly), "In Lapdance PolyZone: " .. tostring(Cache.inlapPoly), "In Lean PolyZone: " .. tostring(Cache.inleanPoly) .. "\n")
				print("Server: ", "Seat1: " .. tostring(Seat1), "Seat2: " .. tostring(Seat2), "Seat3: " .. tostring(Seat3), "Seat4: " .. tostring(Seat4), "Seat5: " .. tostring(Seat5), "Seat6: " .. tostring(Seat6), "Seat7: " .. tostring(Seat7), PlayerSeated)
				print("Client: ", "Seat1: " .. tostring(Seat1Taken), "Seat2: " .. tostring(Seat2Taken), "Seat3: " .. tostring(Seat3Taken), "Seat4: " .. tostring(Seat4Taken), "Seat5: " .. tostring(Seat5Taken), "Seat6: " .. tostring(Seat6Taken), "Seat7: " .. tostring(Seat7Taken), PlayerSeated)
		elseif Config.MoreDebug then
			if Count == 0 then 
				print("In Unicorn PolyZone: " .. tostring(Cache.inuniPoly))
				Count = Count + 1
			end
		end
	end

end)

--------

RegisterNetEvent('kc-unicorn:esxplayermoney')
AddEventHandler('kc-unicorn:esxplayermoney', function(money)
	PlayerMoney = money
end)
