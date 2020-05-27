--[[ ESX Data and Functions ]]--

ESX              	= nil
local PlayerData  = nil


local isTrucker  = false
local isWorking  = false
local blips      = {}

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

Citizen.CreateThread(function()
  while ESX == nil do Citizen.Wait(0) end
  while PlayerData == nil do
    PlayerData = ESX.GetPlayerData()
    Citizen.Wait(0)
  end
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
        local loc = Config.TruckRentalLocations[i].locker
        local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, loc.x, loc.y, loc.z, true)
        if dist <= Config.LockerMarkerProperties.distance and onFoot then
          DisplayMarker(Config.LockerMarkerProperties.type, loc, Config.LockerMarkerProperties.color, Config.LockerMarkerProperties.scale, false)
          if dist <= Config.LockerMarkerProperties.scale.x then
            if not ESX.UI.Menu.IsOpen(mt, GetCurrentResourceName(), "lockerroom") then
              ESX.ShowHelpNotification("~INPUT_CONTEXT~ Open Locker Room")
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