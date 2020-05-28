Config              = {}
Config.Locale        = 'en'

--[[
  24%-27% for employees, 83%-87% for owner-operators
  percentage is out of total job pay
]]

--[[
  Amount (out of 1000.0) of damage that can be caused to the truck
  body before deductions apply to the deposit
]]
Config.DamageThreshold = 6.0

--[[
  Multiplier to apply to the percentage of damage past the damage threshold
]]
Config.DeductionMultiplier = 2.0

--[[
  List of Trucks that can be used with the script
  model    = the in-game model for the vehicle
  deposit  = the price to rent this truck from the logistics company
          : if price is set to -1, the truck can be used but not rented
            (use case: players can purchase their own trucks to use on jobs)
]]
Config.Trucks = {
  {model = "hauler", deposit = 500},
  {model = "phantom", deposit = 1000},
  {model = "phantom3", deposit = 5000},
  {model = "packer", deposit = -1}
}

--[[
  locker = location to get in and out of uniform
  computer = location for player to go to spawn a truck
]]
Config.TruckRentalLocations = {
  {
    blip = vector3(156.1242, -3200.096, 6.021922),
    locker = vector3(145.8869, -3218.66, 4.9),
    computer = vector3(152.9294, -3211.702, 4.95),
    spawns = {
      vector4(125.6823, -3212.811, 5.975893, 359.4013),
      vector4(146.4333, -3204.093, 5.925346, 269.9644),
      vector4(126.1741, -3196.659, 5.979477, 270.1207),
      vector4(137.2964, -3187.17, 5.92463, 180.5098)
    },
    despawn = vector3(162.4647, -3196.618, 5.0)
  }
}

--[[
  Properties to apply to the Truck Rental blip
  short = true if blip should only be rendered on radar when you are nearby

  Alternate sprites and colors can be found at https://docs.fivem.net/docs/game-references/blips/
]]
Config.BlipProperties = {
  name		= _U("blip_name"),
  sprite	= 477,
  color		= 5,
  short		= true
}

--[[
  Properties to apply to the Locker Room markers
  distance = distance to start drawing marker from

  Alternate marker types can be found at https://docs.fivem.net/docs/game-references/markers/
]]
Config.LockerMarkerProperties = {
  type			= 25,
  distance	= 50,
  color			= {red = 255, green = 255, blue = 0, alpha = 150},
  scale			= vector3(1.5, 1.5, 1.5)
}

Config.SpawnMarkerProperties = {
  type			= 25,
  distance	= 10,
  color			= {red = 0, green = 255, blue = 0, alpha = 150},
  scale			= vector3(1.5, 1.5, 1.5)
}

Config.ReturnMarkerProperties = {
  type			= 1,
  distance	= 10,
  color			= {red = 255, green = 0, blue = 0, alpha = 150},
  scale			= vector3(3.5, 3.5, 1.5)
}