--- Checks if a player is a friend or another.
-- @param ply1 First player.
-- @param ply2 Player to check.
-- @param nil if either player is invalid, true if ply2 is a friend of ply1,
--    and false if they are not.
local function PlayerIsFriend(ply1, ply2)
  if not IsValid(ply) or not IsValid(ply2) then
    return
  end

  for _, friend in pairs(ply1:CPPIGetFriends()) do
    if friend == ply2 then
      return true
    end
  end

  return false
end

timer.Create(
  "Flood:OffProps", 1, 0,
  function()
    if GAMEMODE:GetGameState() == FLOOD_GS_FLOOD or GAMEMODE:GetGameState() == FLOOD_GS_FIGHT then
      for _, ply in pairs(player.GetAll()) do
	local ent = ply:GetGroundEntity()
	if ent and IsValid(ent) and ent:GetClass() == "prop_physics" and
	  ent:CPPIGetOwner() ~= ply and PlayerIsFriend(ent:CPPIGetOwner(), ply) == false
	then
	  ply:SetVelocity(Vector(math.random(1, 5000), math.random(1, 5000), math.random(1, 5000)))
	end
      end
    end
  end
)
