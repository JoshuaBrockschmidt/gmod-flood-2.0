function GM:RealismThink()
  for _, v in pairs(player.GetAll()) do
    if v:IsOnFire() and v:WaterLevel() > 1 then
      -- TODO: Should not extinguish if they are above water.
      v:Extinguish()
    end
  end
end
