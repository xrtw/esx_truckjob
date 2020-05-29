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
  spawns = vector4 (x, y, z, w) is used to include headings, where w is heading
  despawn = location to provide the truck return marker
]]
Config.TruckRentalLocations = {
  {
    blip = vector3(156.1242, -3200.096, 6.021922),
    locker = vector3(145.8869, -3218.66, 4.9),
    computer = vector3(152.9294, -3211.702, 4.95),
    spawns = {
      vector4(146.4333, -3204.093, 5.925346, 269.9644),
      vector4(125.6823, -3212.811, 5.975893, 359.4013),
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
  Properties to apply to the markers
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

Config.ContractCompanies = {
  {
    name = "Post OP",
    pay = 50, -- per mile
    locations = {
      {
        name = "Post OP Warehouse",
        area = "Port of Los Santos",
        spots = {
          {
            name = "Bay 11",
            spawn = vector4(-446.0666, -2790.1118, 6.4200, 46.8816),
            back = vector3(-441.7129, -2794.1892, 6.1178),
            front = vector3(-449.5576, -2786.8423, 6.3264),
            model = "trailers2",
            livery = 1
          },
          {
            name = "Bay 12",
            spawn = vector4(-455.0634, -2799.4194, 6.4200, 45.3021),
            back = vector3(-450.8139, -2803.6252, 6.0854),
            front = vector3(-458.4544, -2796.0642, 6.2125),
            model = "trailers2",
            livery = 1
          },
          {
            name = "Bay 13",
            spawn = vector4(-464.1743, -2808.0352, 6.4200, 46.2233),
            back = vector3(-459.8551, -2812.1685, 6.081),
            front = vector3(-467.6163, -2804.7314, 6.2119),
            model = "trailers2",
            livery = 1
          },
          {
            name = "Bay 15",
            spawn = vector4(-481.8604, -2826.0928, 6.4200, 45.6194),
            back = vector3(-477.701, -2830.2051, 6.0881),
            front = vector3(-485.3572, -2822.6599, 6.2129),
            model = "trailers2",
            livery = 1
          },
          {
            name = "Bay 17",
            spawn = vector4(-499.8685, -2843.9341, 6.4200, 45.6311),
            back = vector3(-495.5972, -2848.1184, 6.087),
            front = vector3(-503.281, -2840.6013, 6.2119),
            model = "trailers2",
            livery = 1
          },
          {
            name = "Bay 18",
            spawn = vector4(-509.0766, -2853.0903, 6.4200, 45.7418),
            back = vector3(-504.8009, -2857.2502, 6.1227),
            front = vector3(-512.4982, -2849.7488, 6.3286),
            model = "trailers2",
            livery = 1
          }
        }
      },
      {
        name = "Blaine County Depot",
        area = "Paleto Bay",
        spots = {
          {
            name = "The Loading Bay",
            spawn = vector4(-435.7895, 6140.9414, 33.382, 215.3127),
            back = vector3(-439.2447, 6145.8198, 31.5584),
            front = vector3(-433.0316, 6137.0483, 31.6905),
            model = "trailers2",
            livery = 1
          }
        }
      },
      
    }
  }
}