util.AddNetworkString("RoundState")
GM.GameState = GAMEMODE and GAMEMODE.GameState or 0

--- Get the game state.
-- @return Integer indicating the current game state.
-- @see ../shared/sh_gamestates.lua for state enumerators. These constants should be used
--    to improve readability.
function GM:GetGameState()
  return self.GameState
end

--- Set the game state.
-- @param state Integer indicating the new game state.
-- @see ../shared/sh_gamestates.lua for state enumerators. These constants should be used
--    to improve readability.
function GM:SetGameState(state)
  self.GameState = state
end

function GM:GetStateStart()
  return self.StateStart
end

function GM:GetStateRunningTime()
  return CurTime() - self.StateStart
end

function GM:ResetAllTimers()
  Flood_buildTime = GetConVar("flood_build_time"):GetFloat()
  Flood_boardTime = GetConVar("flood_board_time"):GetFloat()
  Flood_floodTime = GetConVar("flood_flood_time"):GetFloat()
  Flood_fightTime = GetConVar("flood_fight_time"):GetFloat()
  Flood_resetTime = GetConVar("flood_reset_time"):GetFloat()
end

function GM:InitializeRoundController()
  --self:ResetAllTimers() -- TODO: Use this instead.
  Flood_buildTime = GetConVar("flood_build_time"):GetFloat()
  Flood_boardTime = GetConVar("flood_board_time"):GetFloat()
  Flood_floodTime = GetConVar("flood_flood_time"):GetFloat()
  Flood_fightTime = GetConVar("flood_fight_time"):GetFloat()
  Flood_resetTime = GetConVar("flood_reset_time"):GetFloat()

  hook.Add("Think", "Flood_TimeController", function() hook.Call("TimerController", GAMEMODE) end)
end

local tNextThink = 0
function GM:TimerController()
  if CurTime() >= tNextThink then
    if self:GetGameState() == FLOOD_GS_WAIT then
      self:WaitPhase()
    elseif self:GetGameState() == FLOOD_GS_BUILD then
      self:BuildPhase()
    elseif self:GetGameState() == FLOOD_GS_BOARD then
      self:BoardPhase()
    elseif self:GetGameState() == FLOOD_GS_FLOOD then
      self:FloodPhase()
    elseif self:GetGameState() == FLOOD_GS_FIGHT then
      self:FightPhase()
    elseif self:GetGameState() == FLOOD_GS_RESET then
      self:ResetPhase()
    end

    local gState = self:GetGameState()
    net.Start("RoundState")
    net.WriteFloat(gState)
    net.WriteFloat(Flood_buildTime)
    net.WriteFloat(Flood_boardTime)
    net.WriteFloat(Flood_floodTime)
    net.WriteFloat(Flood_fightTime)
    net.WriteFloat(Flood_resetTime)
    net.Broadcast()

    tNextThink = CurTime() + 1
  end
end

--- Starts the building phase when two or more players are present.
function GM:WaitPhase()
  local plyCount = 0
  for _, ply in pairs(player.GetAll()) do
    if IsValid(ply) then
      plyCount = plyCount + 1
    end
  end

  if plyCount >= 2 then
    -- Initiate building phase.
    self:SetGameState(FLOOD_GS_BUILD)

    -- Clean the map, game is about to start.
    self:CleanUpMap()

    -- Respawn all the players.
    for _, ply in pairs(player.GetAll()) do
      if IsValid(ply) then
	ply:Spawn()
      end
    end
  end
end

function GM:BuildPhase()
  if Flood_buildTime <= 0 then
    -- Initialze boarding phase.
    self:SetGameState(FLOOD_GS_BOARD)

    -- Remove all items and reset health of all players.
    for _, ply in pairs(self:GetActivePlayers()) do
      ply:StripWeapons()
      ply:RemoveAllAmmo()
      ply:SetHealth(100)
      ply:SetArmor(0)
    end

    -- Unfreeze everything.
    for _, ent in pairs(ents.GetAll()) do
      if IsValid(ent) then
	local phys = ent:GetPhysicsObject()

	if phys:IsValid() then
	  phys:EnableMotion(true)
	  phys:Wake()
	end
      end
    end
  else
    Flood_buildTime = Flood_buildTime - 1
  end
end

function GM:BoardPhase()
  if Flood_boardTime <= 0 then
    -- Initiate flooding phase.
    self:SetGameState(FLOOD_GS_FLOOD)

    -- Nobody can respawn now.
    for _, ply in pairs(player.GetAll()) do
      if IsValid(ply) then
	ply:SetCanRespawn(false)
      end
    end

    -- Remove any ceiling above players.
    for _, ceiling in pairs(ents.FindByClass("func_breakable")) do
      ceiling:Fire("Break")
    end

    -- Raise the water.
    self:RiseAllWaterControllers()
  else
    Flood_boardTime = Flood_boardTime - 1
  end
end

function GM:FloodPhase()
  if Flood_floodTime <= 0 then
    -- Initiate fighing phase.
    self:SetGameState(FLOOD_GS_FIGHT)

    -- Give all players weapons.
    self:GivePlayerWeapons()
  else
    Flood_floodTime = Flood_floodTime - 1
  end
end

function GM:FightPhase()
  if Flood_fightTime <= 0 then
    -- Reset round.
    self:SetGameState(FLOOD_GS_RESET)

    -- Lower water.
    self:LowerAllWaterControllers()

    -- Declare winner is nobody because time ran out.
    self:DeclareWinner(3)
  else
    Flood_fightTime = Flood_fightTime - 1
    self:ParticipationBonus()
  end
end

function GM:ResetPhase()
  if Flood_resetTime <= 0 then
    -- Time to wait for players. If more than two players are online, the build phase will be
    -- automatically initiated.
    self:SetGameState(FLOOD_GS_WAIT)

    self:CleanUpMap()

    -- Force respawn all players, living and dead.
    for _, ply in pairs(player.GetAll()) do
      if IsValid(ply) then
	-- Silently kill any living players.
	if ply:Alive() then
	  ply:KillSilent()
	end

	ply:SetCanRespawn(true)

	-- Wait until they respawn.
	timer.Simple(
	  0,
	  function()
	    ply:StripWeapons()
	    ply:RemoveAllAmmo()
	    ply:SetHealth(100)
	    ply:SetArmor(0)

	    timer.Simple(
	      0,
	      function()
		ply:Give("gmod_tool")
		ply:Give("weapon_physgun")
		ply:Give("flood_propseller")

		ply:SelectWeapon("weapon_physgun")
	      end
	    )
	  end
	)
      end
    end

    -- Reset all the round timers.
    self:ResetAllTimers()
  else
    Flood_resetTime = Flood_resetTime - 1
  end
end
