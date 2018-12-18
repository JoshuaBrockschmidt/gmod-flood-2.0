-- The threshold of water coverage past which a player takes water damage.
local COVER_THRES = 20 -- 20 was chosen through experimentation.

-- Cooldown timer for GM:WaterHurts.
local whTick = 0

--- Applies water damage to players who are sufficiently covered in water.
-- Has a 0.5 second cooldown.
function GM:WaterHurts()
  if GetConVar("flood_wh_enabled"):GetBool() then
    if whTick < CurTime() then
      local dmg = GetConVar("flood_wh_damage"):GetFloat()
      for _, ply in pairs(self:GetActivePlayers()) do
	if ply:WaterLevel() >= 1 then
	  -- Only hurt the player if they are sufficiently submerged. Player:WaterLevel does not tell us the exact extent to which the player is submerged, so we will have to calculate it ourselves.

	  -- Calculate the position of the player's feet.
	  local pBoundMin, _ = ply:GetCollisionBounds()
	  local feetHeight = ply:GetPos().z + pBoundMin.z

	  -- Search for some water source that has the player sufficiently submerged.
	  for _, ent in pairs(ents.GetAll()) do
	    if ent:GetClass() == "func_water_analog" or ent:GetName() == "water" then
	      local _, wBoundMax = ent:GetCollisionBounds()
	      local wHeight = ent:GetPos().z + wBoundMax.z

	      -- Check if player is sufficiently covered by water.
	      local coverage = wHeight - feetHeight
	      if coverage > COVER_THRES then
		-- Found body of water that sufficiently covers the player.
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamageType(DMG_GENERIC)
		dmgInfo:SetDamage(dmg)
		dmgInfo:SetAttacker(game.GetWorld())
		dmgInfo:SetInflictor(game.GetWorld())
		ply:TakeDamageInfo(dmgInfo)
		break
	      end
	    end
	  end
	end
      end
      whTick = CurTime() + 0.5
    end
  end
end
hook.Add("Tick", "flood waterhurt function", function() hook.Call("WaterHurts", GAMEMODE) end)
