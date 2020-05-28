--[[ ESX Data and Functions ]]--

ESX              	= nil
local PlayerData  = nil


local isTrucker = false
local isWorking = false
local blips     = {}

local deposit = -1

local jobTruck  = nil

local availableTrucks = {}

local mt = "default"
local ma = "bottom-right"

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
  PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  if (PlayerData == nil) then
    PlayerData = ESX.GetPlayerData()
  end
  PlayerData.job = job
end)

RegisterNetEvent('esx_truckjob:Notification')
AddEventHandler('esx_truckjob:Notification', function(text)
  ESX.ShowNotification(text)
end)

RegisterNetEvent('esx_truckjob:SpawnTruck')
AddEventHandler('esx_truckjob:SpawnTruck', function(model, location, locationIndex, depositA)
  if Config.TruckRentalLocations[location] == nil then
    ESX.ShowNotification(_U("error_location"))
    return
  end
  if Config.TruckRentalLocations[location].spawns[locationIndex] == nil then
    ESX.ShowNotification(_U("error_locindex"))
    return
  end
  deposit = depositA
  local pos = Config.TruckRentalLocations[location].spawns[locationIndex]
  RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(500)
	end

  jobTruck = CreateVehicle(model, pos.x, pos.y, pos.z, pos.w, true, false)
  SetVehicleNumberPlateText(jobTruck, "WRK " .. math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9))

  SetModelAsNoLongerNeeded(model)
end)

RegisterNetEvent("esx_truckjob:ReturnAccepted")
AddEventHandler("esx_truckjob:ReturnAccepted", function()
  local ped = PlayerPedId()
  if IsPedInVehicle(ped, jobTruck, false) then
    TaskLeaveVehicle(ped, jobTruck, 0)
    Citizen.Wait(2750) -- just enough time to get out of the truck :D
  end
  DeleteVehicle(jobTruck)
  jobTruck = nil
end)

Citizen.CreateThread(function()
  while ESX == nil do Citizen.Wait(0) end
  while PlayerData == nil do
    PlayerData = ESX.GetPlayerData()
    Citizen.Wait(0)
  end
  for i = 1, #Config.Trucks, 1 do
    if Config.Trucks[i].deposit ~= -1 then
      table.insert(availableTrucks, {label = _U(Config.Trucks[i].model) .. " - $" .. Config.Trucks[i].deposit, value = Config.Trucks[i].model})
    end
  end
  table.insert(availableTrucks, {label = "BORKBORK", value = "bork"})
  while true do
    if not (PlayerData.job == nil or PlayerData.job.name == nil) then
      if PlayerData.job.name == "trucker" and not isTrucker then
        DoHireFunctions()
        isTrucker = true
      end
      if PlayerData.job.name ~= "trucker" and isTrucker then
        DoQuitFunctions()
        isTrucker = false
      end
    end
    Citizen.Wait(100)
  end
end)

--[[ Job Functions ]]--

Citizen.CreateThread(function()
  while true do
    if not isTrucker then
      Citizen.Wait(500)
    else
      local ped			= PlayerPedId()
      local pos			= GetEntityCoords(ped)
      local onFoot	= IsPedOnFoot(ped)
      for i = 1, #Config.TruckRentalLocations, 1 do
        HandleLockerMarker(i, pos, ped, onFoot)
        HandleTruckSpawnMarker(i, pos, ped, onFoot)
        HandleTruckReturnMarker(i, pos, ped, onFoot)
      end
      Citizen.Wait(0)
    end
  end
end)

function DoHireFunctions()
  for i = 1, #Config.TruckRentalLocations, 1 do
    local bp = Config.BlipProperties
    local blip = Config.TruckRentalLocations[i].blip
    table.insert(blips, CreateBlip(bp.name, bp.sprite, bp.color, blip, bp.short))
  end
end

function DoQuitFunctions()
  for i = 1, #blips, 1 do
    RemoveBlip(blips[i])
  end
  blips = {}
end

function HandleLockerMarker(i, pos, ped, onFoot)
  if jobTruck ~= nil then return end
  local loc = Config.TruckRentalLocations[i].locker
  local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, loc.x, loc.y, loc.z, true)
  if dist <= Config.LockerMarkerProperties.distance and onFoot then
    DisplayMarker(Config.LockerMarkerProperties.type, loc, Config.LockerMarkerProperties.color, Config.LockerMarkerProperties.scale, false)
    if dist <= Config.LockerMarkerProperties.scale.x then
      if not ESX.UI.Menu.IsOpen(mt, GetCurrentResourceName(), "lockerroom") then
        ESX.ShowHelpNotification(_U("prompt_lockerroom"))
        if IsControlJustReleased(0, 51) then
          ESX.UI.Menu.Open(mt, GetCurrentResourceName(), "lockerroom", {
            title = _U("ui_lockerroom"),
            align = ma,
            elements = {
              {label = _U("lockerroom_uniform"), value = "uniform"},
              {label = _U("lockerroom_regular"), value = "regular"}
            }
          },
          function(data, menu)
            if data.current.value == "uniform" then
              isWorking = true
              ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                  TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                  TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end
              end)
            elseif data.current.value == "regular" then
              isWorking = false
              ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
              end)
            end
            menu.close()
          end,
          function(data, menu)
            menu.close()
          end)
        end
      end
    elseif ESX.UI.Menu.IsOpen(mt, GetCurrentResourceName(), "lockerroom") then
      ESX.UI.Menu.Close(mt, GetCurrentResourceName(), "lockerroom")
    end
  end
end

function HandleTruckSpawnMarker(i, pos, ped, onFoot)
  if jobTruck ~= nil or not isWorking then return end
  local loc = Config.TruckRentalLocations[i].computer
  local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, loc.x, loc.y, loc.z, true)
  if dist <= Config.SpawnMarkerProperties.distance and onFoot then
    DisplayMarker(Config.SpawnMarkerProperties.type, loc, Config.SpawnMarkerProperties.color, Config.SpawnMarkerProperties.scale, false)
    if dist <= Config.SpawnMarkerProperties.scale.x then
      if not ESX.UI.Menu.IsOpen(mt, GetCurrentResourceName(), "rental") then
        ESX.ShowHelpNotification(_U("prompt_rental"))
        if IsControlJustReleased(0, 51) then
          ESX.UI.Menu.Open(mt, GetCurrentResourceName(), "rental", {
            title = _U("ui_rental"),
            align = ma,
            elements = availableTrucks
          },
          function(data, menu)
            TriggerServerEvent("esx_truckjob:RequestVehicle", i, data.current.value)
            menu.close()
          end,
          function(data, menu)
            menu.close()
          end)
        end
      end
    elseif ESX.UI.Menu.IsOpen(mt, GetCurrentResourceName(), "rental") then
      ESX.UI.Menu.Close(mt, GetCurrentResourceName(), "rental")
    end
  end
end

function HandleTruckReturnMarker(i, pos, ped, onFoot)
  if jobTruck == nil or not isWorking then return end
  local loc = Config.TruckRentalLocations[i].despawn
  local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, loc.x, loc.y, loc.z, true)
  if dist <= Config.ReturnMarkerProperties.distance and not onFoot and IsPedInVehicle(ped, jobTruck, false) then
    DisplayMarker(Config.ReturnMarkerProperties.type, loc, Config.ReturnMarkerProperties.color, Config.ReturnMarkerProperties.scale, false)
    if dist <= Config.ReturnMarkerProperties.scale.x then
      ESX.ShowHelpNotification(_U("prompt_return"))
      if IsControlJustReleased(0, 51) then
        local veh = jobTruck
        local ped = PlayerPedId()
        if (GetVehiclePedIsIn(ped, false) ~=  veh) then return end
        local health = GetVehicleBodyHealth(veh)
        local damagePercentage = ((1000 - health)/(1000 - Config.DamageThreshold)) * 100
        local returnAmount = deposit
        if 1000 - health > Config.DamageThreshold then
          ESX.ShowNotification(_U("damaged_veh"))
          local depositDeduction = (Config.DeductionMultiplier * damagePercentage) / 100
          returnAmount = round(deposit - (deposit * depositDeduction), 0)
          if returnAmount < 0 then returnAmount = 0 end
        end
        TriggerServerEvent("esx_truckjob:ReturnVehicle", returnAmount)
      end
    end
  end
end

--[[ Helper Functions ]]--
function CreateBlip(name, sprite, color, position, short)
  local blip = AddBlipForCoord(position.x, position.y, position.z)
  SetBlipSprite(blip, sprite)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentSubstringPlayerName(name)
  EndTextCommandSetBlipName(blip)
  SetBlipColour(blip, color)
  SetBlipAsShortRange(blip, short)
  return blip
end

function DisplayMarker(type, pos, color, scale, face)
  DrawMarker(type, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, scale.x, scale.y, scale.z, color.red, color.green, color.blue, color.alpha, false, face, 2, nil, nil, nil, false)
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end