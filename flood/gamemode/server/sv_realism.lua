function GM:RealismThink()
  for _, ply in pairs(player.GetAll()) do
    if ply:IsOnFire() and ply:WaterLevel() > 1 then
      -- TODO: Should not extinguish if they are above water.
      ply:Extinguish()
    end
  end
end
