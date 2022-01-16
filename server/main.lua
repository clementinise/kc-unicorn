local GithubL, Changelog, ESX, QBCore, inPoleDance

local Version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0) -- Do Not Change This Value
local Github = GetResourceMetadata(GetCurrentResourceName(), 'github', 0)
local Updater = false
local INPOLEDANCE = false
local PedNumber = 2
local PoledancePed1, PoledancePed2

-- Server Seat Locales
local GetPlayerSeated = 0
local Seat1Taken = false
local Seat2Taken = false
local Seat3Taken = false
local Seat4Taken = false
local Seat5Taken = false
local Seat6Taken = false
local Seat7Taken = false

-- Import
if Config.Framework == "ESX" then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif Config.Framework == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

-------- Check if new update available
Citizen.CreateThread(function()
    
    local Resources = GetNumResources()

	for i = 0, Resources, 1 do
		local resource = GetResourceByFindIndex(i)
		UpdateResource(resource)
	end

    Citizen.Wait(4000)

    if Updater == false then
        if Config.UpdateChecker then
            Updater = not Updater
            UpdateChecker()
        end
    end

end)

function UpdateResource(resource)
	if resource == 'fivem-checker' then
        if GetResourceState(resource) == 'started' or GetResourceState(resource) == 'starting' then
            if Config.UpdateChecker then
                Updater = true
            end
		end
	end
end

----------------

function UpdateChecker()
    
    if string.find(Github, "github") then
        if string.find(Github, "github.com") then
            GithubL = Github
            Github = string.gsub(Github, "github", "raw.githubusercontent")..'/master/version'
        else
            GithubL = string.gsub(Github, "raw.githubusercontent", "github"):gsub("/master", "")
            Github = Github..'/version'
        end
    else
    end
    PerformHttpRequest(Github, function(Error, V, Header)
        NewestVersion = V
    end)
    repeat
        Citizen.Wait(10)
    until NewestVersion ~= nil
    local _, strings = string.gsub(NewestVersion, "\n", "\n")
    Version1 = NewestVersion:match("[^\n]*"):gsub("[<>]", "")
    if string.find(Version1, Version) then
    else
        if strings > 0 then
            Changelog = NewestVersion:gsub(Version1,""):match("(.*" .. Version .. ")"):gsub(Version,"")
            Changelog = string.gsub(Changelog, "\n", "")
            Changelog = string.gsub(Changelog, "-", " \n-"):gsub("%b<>", ""):sub(1, -2)
            NewestVersion = Version1
        end
    end

    Citizen.Wait(500)
    
    print('')
    if Config.Framework == 'QBCore' then
        print('^8QBCore ^6KC Unicorn Script ('..GetCurrentResourceName()..')')
    elseif Config.Framework == 'Standalone' then
        print('^9Standalone ^6KC Unicorn Script ('..GetCurrentResourceName()..')')
    elseif Config.Framework == 'ESX' then
        print('^3ESX ^6KC Unicorn Script ('..GetCurrentResourceName()..')')
    end
    if Version == Version1 then
        print('^2Version ' .. Version .. ' - Up to date!')
    else
        print('^1Version ' .. Version .. ' - Outdated!')
        print('^1New version: v' .. Version1)
        if Config.ChangeLog then
            print('\n^3Changelog:')
            print('^4'..Changelog..'\n')
        end
        print('^1Please check the GitHub and download the last update')
        print('^2'..GithubL..'/releases/latest')
    end
    print('')
end

-- Poledance Girls (WIP)
Citizen.CreateThread(function()

    PoledancePed1 = CreatePed(4, 1381498905, 112.27, -1287.22, 28.46, 303.19, true, false)
    PoledancePed2 = CreatePed(4, 1846523796, 102.13, -1296.19, 28.77, 303.19, true, false)
    SharedPed1 = NetworkGetNetworkIdFromEntity(PoledancePed1)
    SharedPed2 = NetworkGetNetworkIdFromEntity(PoledancePed2)

    inPoleDance = true

	SetPedComponentVariation(PoledancePed2, 8, 0)
	SetPedComponentVariation(PoledancePed1, 8, 0)

    
    repeat
        inPoleDance = true

        TaskGoToCoordAnyMeans(PoledancePed1, 102.13, -1296.19, 28.77, 1.0, 0, 0, 0, 0xbf800000)
        TaskGoToCoordAnyMeans(PoledancePed2, 112.27, -1287.22, 28.46, 1.0, 0, 0, 0, 0xbf800000)
        PoleDance(PoledancePed2)

        inPoleDance = true
        
        if PedNumber == 2 then
            PedNumber = 1
        else
            PedNumber = 2
        end

        TaskGoToCoordAnyMeans(PoledancePed2, 102.13, -1296.19, 28.77, 1.0, 0, 0, 0, 0xbf800000)
        TaskGoToCoordAnyMeans(PoledancePed1, 112.27, -1287.22, 28.46, 1.0, 0, 0, 0, 0xbf800000)
        PoleDance(PoledancePed1)
        
        if PedNumber == 2 then
            PedNumber = 1
        else
            PedNumber = 2
        end
        
    until (Poledance == false)
end)

function PoleDance(Ped)
    while inPoleDance do
        PedCoo = GetEntityCoords(Ped)
        local poledist = #(PedCoo - vector3(112.27, -1287.22, 28.46))
        local dict = "mini@strip_club@pole_dance@pole_dance"..PedNumber
        if poledist < 0.4 then
            INPOLEDANCE = true
            TriggerClientEvent('kc-unicorn:poledancescene', -1, NetworkGetNetworkIdFromEntity(Ped), PedNumber)
            repeat
                Citizen.Wait(200)
            until INPOLEDANCE == false
            inPoleDance = false
        end
        Citizen.Wait(10)
    end
end

-- Buy function
RegisterServerEvent('kc-unicorn:buy')
AddEventHandler('kc-unicorn:buy', function(Stripper)
	
    if Config.Framework == "QBCore" then

        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        Cost = Config.LapDanceCost
        PlayerMoney = Player.PlayerData.money["cash"]
        PlayerBirthdate = Player.PlayerData.charinfo.birthdate
        TodayDate = os.date("%Y-%m-%d")

        if GetPlayerSeated >= 7 then
            TriggerClientEvent('QBCore:Notify', src, Loc('AllPlacesTaken'), "error", 1700)
        else
            if PlayerMoney >= Cost then
                if not LapDanceActive then
                    Player.Functions.RemoveMoney("cash", Cost)
                    TriggerClientEvent('QBCore:Notify', src, Loc('BoughtLapdance', Config.LapDanceCost), "success", 1700)
                    TriggerClientEvent('kc-unicorn:lapdance', src, PlayerMoney, PlayerBirthdate, TodayDate, Stripper)
                else
                    TriggerClientEvent('QBCore:Notify', src, Loc('StripperActive'), "error", 1700)
                end
            else
                TriggerClientEvent('QBCore:Notify', src, Loc('NotEnoughMoney', Config.LapDanceCost), "error", 1700)
            end
        end

    elseif Config.Framework == "ESX" then

        local src = source
        local Player = ESX.GetPlayerFromId(src)
        Cost = Config.LapDanceCost
        PlayerMoney = Player.getMoney()

        if GetPlayerSeated >= 7 then
            TriggerClientEvent('esx:showNotification', src, Loc('AllPlacesTaken'))
        else
            if PlayerMoney >= Cost then
                if not LapDanceActive then
                    Player.removeMoney(Cost)
                    TriggerClientEvent('esx:showNotification', src, Loc('BoughtLapdance', Config.LapDanceCost))
                    TriggerClientEvent('kc-unicorn:lapdance', src, PlayerMoney, PlayerBirthdate, TodayDate, Stripper)
                else
                    TriggerClientEvent('esx:showNotification', src, Loc('StripperActive'))
                end
            else
                TriggerClientEvent('esx:showNotification', src, Loc('NotEnoughMoney', Config.LapDanceCost))
            end
        end

    elseif Config.Framework == 'Standalone' then

        local src = source
        
        if GetPlayerSeated >= 7 then
            TriggerClientEvent('kc-unicorn:showNotify', src, Loc('AllPlacesTaken'))
        else
            TriggerClientEvent('kc-unicorn:lapdance', src, PlayerMoney, PlayerBirthdate, TodayDate, Stripper)
        end
    end
end)

-- Lean Throw function
RegisterServerEvent('kc-unicorn:leanthrow')
AddEventHandler('kc-unicorn:leanthrow', function()
	
    if Config.Framework == "QBCore" then

        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        Cost = Config.ThrowCost
        PlayerMoney = Player.PlayerData.money["cash"]

        Player.Functions.RemoveMoney("cash", Cost)

    elseif Config.Framework == "ESX" then

        local src = source
        local Player = ESX.GetPlayerFromId(src)
        Cost = Config.ThrowCost
        PlayerMoney = Player.getMoney()

        Player.removeMoney(Cost)

    end
end)

-- Lean ESX Get Money
RegisterServerEvent('kc-unicorn:esxmoney')
AddEventHandler('kc-unicorn:esxmoney', function()

    local src = source
    local Player = ESX.GetPlayerFromId(src)
    Cost = Config.LapDanceCost
    PlayerMoney = Player.getMoney()
    
    TriggerClientEvent("kc-unicorn:esxplayermoney", src, PlayerMoney)

end)

RegisterServerEvent('kc-unicorn:SyncLapDanceSpawn')
AddEventHandler('kc-unicorn:SyncLapDanceSpawn', function()

    TriggerClientEvent("kc-unicorn:LapDanceSpawn", 0)

end)

RegisterServerEvent('kc-unicorn:GetPlayerSeated')
AddEventHandler('kc-unicorn:GetPlayerSeated', function()
    local src = source

    if Seat1Taken then
        GetPlayerSeated = GetPlayerSeated + 1
    end
    if Seat2Taken then
        GetPlayerSeated = GetPlayerSeated + 1
    end
    if Seat3Taken then
        GetPlayerSeated = GetPlayerSeated + 1
    end
    if Seat4Taken then
        GetPlayerSeated = GetPlayerSeated + 1
    end
    if Seat5Taken then
        GetPlayerSeated = GetPlayerSeated + 1
    end
    if Seat6Taken then
        GetPlayerSeated = GetPlayerSeated + 1
    end
    if Seat7Taken then
        GetPlayerSeated = GetPlayerSeated + 1
    end
    if not Seat1Taken and not Seat2Taken and not Seat3Taken and not Seat4Taken and not Seat5Taken and not Seat6Taken and not Seat7Taken then
        GetPlayerSeated = 0
    end

    if Config.Debug then
        print("Server: ", "Seat1: ", Seat1Taken, "Seat2: ", Seat2Taken, "Seat3: ", Seat3Taken, "Seat4: ", Seat4Taken, "Seat5: ", Seat5Taken, "Seat6: ", Seat6Taken, "Seat7: ", Seat7Taken, " ", GetPlayerSeated)
    end
    TriggerClientEvent("kc-unicorn:SetPlayerSeated", src, GetPlayerSeated, Seat1Taken,  Seat2Taken, Seat3Taken, Seat4Taken, Seat5Taken, Seat6Taken, Seat7Taken)
    GetPlayerSeated = 0

end)

RegisterServerEvent('kc-unicorn:Seat1')
AddEventHandler('kc-unicorn:Seat1', function(seat)
    Seat1Taken = true
end)

RegisterServerEvent('kc-unicorn:Seat2')
AddEventHandler('kc-unicorn:Seat2', function(seat)
    Seat2Taken = true
end)

RegisterServerEvent('kc-unicorn:Seat3')
AddEventHandler('kc-unicorn:Seat3', function(seat)
    Seat3Taken = true
end)

RegisterServerEvent('kc-unicorn:Seat4')
AddEventHandler('kc-unicorn:Seat4', function(seat)
    Seat4Taken = true
end)

RegisterServerEvent('kc-unicorn:Seat5')
AddEventHandler('kc-unicorn:Seat5', function(seat)
    Seat5Taken = true
end)

RegisterServerEvent('kc-unicorn:Seat6')
AddEventHandler('kc-unicorn:Seat6', function(seat)
    Seat6Taken = true
end)

RegisterServerEvent('kc-unicorn:Seat7')
AddEventHandler('kc-unicorn:Seat7', function(seat)
    Seat7Taken = true
end)

RegisterServerEvent('kc-unicorn:RemoveSeat1')
AddEventHandler('kc-unicorn:RemoveSeat1', function(seat)
    Seat1Taken = false
end)

RegisterServerEvent('kc-unicorn:RemoveSeat2')
AddEventHandler('kc-unicorn:RemoveSeat2', function(seat)
    Seat2Taken = false
end)

RegisterServerEvent('kc-unicorn:RemoveSeat3')
AddEventHandler('kc-unicorn:RemoveSeat3', function(seat)
    Seat3Taken = false
end)

RegisterServerEvent('kc-unicorn:RemoveSeat4')
AddEventHandler('kc-unicorn:RemoveSeat4', function(seat)
    Seat4Taken = false
end)

RegisterServerEvent('kc-unicorn:RemoveSeat5')
AddEventHandler('kc-unicorn:RemoveSeat5', function(seat)
    Seat5Taken = false
end)

RegisterServerEvent('kc-unicorn:RemoveSeat6')
AddEventHandler('kc-unicorn:RemoveSeat6', function(seat)
    Seat6Taken = false
end)

RegisterServerEvent('kc-unicorn:RemoveSeat7')
AddEventHandler('kc-unicorn:RemoveSeat7', function(seat)
    Seat7Taken = false
end)

RegisterServerEvent('kc-unicorn:NoPlaceAvailable')
AddEventHandler('kc-unicorn:NoPlaceAvailable', function()

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Cost = Config.LapDanceCost

    Player.Functions.AddMoney("cash", Cost)
    TriggerClientEvent('QBCore:Notify', src, Loc('AllPlacesTaken'), "error", 1700)


end)

AddEventHandler('onResourceStop', function()
    DeleteEntity(PoledancePed1)
    DeleteEntity(PoledancePed2)
    print("Ped succesfully deleted")
  end)

RegisterServerEvent('kc-unicorn:poledancestop')
AddEventHandler('kc-unicorn:poledancestop', function()
	
    INPOLEDANCE = false

end)
