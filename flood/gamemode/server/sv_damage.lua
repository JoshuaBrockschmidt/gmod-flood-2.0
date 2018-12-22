----------------
-- Handles damage dealt or received by water, players, and props.

-- The threshold of water coverage past which a player takes water damage.
local WATER_COVER_THRES = 20 -- 20 was chosen through experimentation.

function GM:EntityTakeDamage(ent, dmginfo)
  -- We will take a whitelisting approach to accepting damage events. Note that returning true
  -- blocks a damage event.

  local blockDmg = true

  -- Apply damage to props if it is fighting phase.
  if GAMEMODE:GetGameState() == FLOOD_GS_FIGHT then
    local attacker = dmginfo:GetAttacker()
    if ent:IsPlayer() then
      if attacker:GetClass() == "worldspawn" then
	-- Allow world damage to players, such as water damage.
	blockDmg = false
      end
    else
      -- Handle prop damage.
      if attacker:IsPlayer() then
	if attacker:GetActiveWeapon() ~= NULL then
	  -- TODO: Why do we need a special case for the pistol?
	  if attacker:GetActiveWeapon():GetClass() == "weapon_pistol" then
	    ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 1)
	  else
	    for _, weapon in pairs(Weapons) do
	      if attacker:GetActiveWeapon():GetClass() == weapon.Class then
		ent:SetNWInt(
		  "CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - tonumber(weapon.Damage)
		)
	      end
	    end
	  end
	end
      elseif attacker:GetClass() == "entityflame" then
	ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 0.5)
      else
	-- TODO: What is this for?
	ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 1)
      end

      -- Check if the prop's health is depleted.
      if ent:GetNWInt("CurrentPropHealth") <= 0 and IsValid(ent) then
	ent:Remove()
      end
    end
  end

  return blockDmg
end

function ShouldTakeDamage(victim, attacker)
  -- Only take damage during the flooding and fighting phase.
  local gs = GAMEMODE:GetGameState()
  if gs == FLOOD_GS_FLOOD or gs == FLOOD_GS_FIGHT then
    if attacker:IsPlayer() and victim:IsPlayer() then
      return false
    else
      if attacker:GetClass() ~= "prop_*" and attacker:GetClass() ~= "entityflame" then
	return true
      end
    end
  else
    return false
  end
end
hook.Add("PlayerShouldTakeDamage", "Flood_PlayerShouldTakeDamage", ShouldTakeDamage)

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
	      if coverage > WATER_COVER_THRES then
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
