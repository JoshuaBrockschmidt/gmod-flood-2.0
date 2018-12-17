--- Checks if a player is a friend of another.
-- @param ply First player.
-- @param ply2 Second player.
-- @return True if first player and second player are friends of each other, and false otherwise.
local function PlayerIsFriend(ply1, ply2)
  if not IsValid(ply1) or not IsValid(ply2) then
    return
  end

  for _, friend in pairs(ply1:CPPIGetFriends()) do
    if friend == ply2 then
      return true
    end
  end

  return false
end

--- Gets all living players.
-- @return a table of all living players.
function GM:GetActivePlayers()
  local players = {}
  for _, ply in pairs(player.GetAll()) do
    if IsValid(ply) and ply:Alive() then
      table.insert(players, ply)
    end
  end

  return players
end

--- Checks if there is a winner. Only works during the fighting phase.
function GM:CheckForWinner()
  -- If it is the fighing phase, check for a winner.
  if self:GetGameState() == FLOOD_GS_FIGHT then
    local players = self:GetActivePlayers()
    local count = #players
    if count == 1 then
      winner = players[1]
    end

    -- Determine team conditions.
    local AllAreFriends = true
    for k, ply1 in pairs(players) do
      for x, ply2 in pairs(players) do
	-- Dont look at the same person
	if ply1 == ply2 then
	  continue
	end

	-- Is player one friends with player two, and is player two friends with player one?
	if PlayerIsFriend(ply1, ply2) and PlayerIsFriend(ply2, ply1) then
	  continue
	else
	  AllAreFriends = false
	  break
	end
      end
    end

    -- Determine if there are any winners.
    doReset = false
    if AllAreFriends == true and count != 0 then
      -- A group of players won.
      self:DeclareWinner(0, players)
      doReset = true
    elseif count == 1 and winner != nil then
      -- A single player won..
      self:DeclareWinner(1, winner)
      doReset = true
    elseif count == 0 and winner == nil then
      -- Nobody won.
      self:DeclareWinner(2, winner)
      doReset = true
    end

    if doReset then
      self:SetGameState(FLOOD_GS_RESET)
      self:LowerAllWaterControllers()
    end
  end
end

--- Declares the winner(s) and distributes prize money to them.
-- @param case 0 if a group of players has won, 1 if a single player has won, and 0 if not player
--    has won.
-- @param winner Table of players for case 0, a single player for case 1, and nothing for case 2 or 3.
function GM:DeclareWinner(case, winner)
  if case == 0 and type(winner) == "table" then
    for _, v in pairs(winner) do
      if IsValid(v) and v:Alive() and self:GetGameState() == FLOOD_GS_FIGHT then
	local cash = GetConVar("flood_bonus_cash"):GetInt()
	v:AddCash(cash)

	local ct = ChatText()
	ct:AddText("[Flood] ", Color(132, 199, 29, 255))
	ct:AddText(v:Nick(), self:FormatColor(v:GetPlayerColor()))
	ct:AddText(" won and recieved an additional $" .. cash .. "!")
	ct:SendAll()
      end
    end
  elseif case == 1 and IsValid(winner) then
    if winner:Alive() and IsValid(winner) and self:GetGameState() == FLOOD_GS_FIGHT then
      local cash = GetConVar("flood_bonus_cash"):GetInt()
      winner:AddCash(cash)

      local ct = ChatText()
      ct:AddText("[Flood] ", Color(132, 199, 29, 255))
      ct:AddText(winner:Nick(), self:FormatColor(winner:GetPlayerColor()))
      ct:AddText(" won and recieved an additional $" .. cash .. "!")
      ct:SendAll()
    end
  elseif case == 2 then
    local ct = ChatText()
    ct:AddText("[Flood] ", Color(132, 199, 29, 255))
    ct:AddText("Nobody won!")
    ct:SendAll()
  elseif case == 3 then
    local ct = ChatText()
    ct:AddText("[Flood] ", Color(132, 199, 29, 255))
    ct:AddText("Round time limit reached. Nobody wins.")
    ct:SendAll()
  end
end

local pNextBonus = 0
--- Issues a participation bonus to all living players. Only works during the fighting phase.
-- Has a five second cooldown before it can be invoked with effect again.
function GM:ParticipationBonus()
  if self:GetGameState() == FLOOD_GS_FIGHT and pNextBonus <= CurTime() then
    for _, ply in pairs(self:GetActivePlayers()) do
      local cash = GetConVar("flood_participation_cash"):GetInt()
      ply:AddCash(cash)
    end

    pNextBonus = CurTime() + 5
  end
end

--- Deletes all props and refunds their owner for each prop's cost.
function GM:RefundAllProps()
  for _, ent in pairs(ents.GetAll()) do
    if ent:GetClass() == "prop_physics" then
      if ent:CPPIGetOwner() ~= nil and ent:CPPIGetOwner() ~= NULL and ent:CPPIGetOwner() ~= "" then
	local currentHealth = tonumber(ent:GetNWInt("CurrentPropHealth"))
	local baseHealth = tonumber(ent:GetNWInt("BasePropHealth"))
	local currentCash = tonumber(ent:CPPIGetOwner():GetNWInt("flood_cash"))
	local receive = (currentHealth / baseHealth) * baseHealth
	if receive > 0 then
	  ent:Remove()
	  if ent:CPPIGetOwner():IsValid() then
	    ent:CPPIGetOwner():AddCash(receive)
	  end
	else
	  ent:Remove()
	end
      else
	ent:Remove()
      end
    end
  end
end
