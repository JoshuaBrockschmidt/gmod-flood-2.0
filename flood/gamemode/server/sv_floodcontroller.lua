--- Gets all controllable bodies of water on the map.
-- @param Indexed table of all water controllers.
local function GetWaterControllers()
  local controllers = {}
  for _, ent in pairs(ents.GetAll()) do
    if ent:GetClass() == "func_water_analog" or ent:GetName() == "water" then
      controllers[#controllers + 1] = ent
    end
  end

  return controllers
end

--- Checks if there are any valid water controllers.
-- @raise an error when there is not valid flood controller.
function GM:CheckForWaterControllers()
  if #GetWaterControllers() <= 0 then
    self.ShouldHaltGamemode = true
    error("Flood was unable to find a valid water controller on " ..
	    game.GetMap() .. ", gamemode halting.", 2)
  end
end

--- Lowers all controllable bodies of water.
function GM:RiseAllWaterControllers()
  for _, ctrl in pairs(GetWaterControllers()) do
    ctrl:Fire("open")
  end
end

--- Raises all controllable bodies of water.
function GM:LowerAllWaterControllers()
  for _, ctrl in pairs(GetWaterControllers()) do
    ctrl:Fire("close")
  end
end
