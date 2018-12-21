-- Include and AddCSLua everything
include("shared.lua")
AddCSLuaFile("shared.lua")

MsgN("_-_-_-_- Flood Server Side -_-_-_-_")
MsgN("Loading Server Files")
for _, file in pairs (file.Find("flood/gamemode/server/*.lua", "LUA")) do
  MsgN("-> " .. file)
  include("flood/gamemode/server/" .. file)
end

MsgN("Loading Shared Files")
for _, file in pairs (file.Find("flood/gamemode/shared/*.lua", "LUA")) do
  MsgN("-> " .. file)
  AddCSLuaFile("flood/gamemode/shared/" .. file)
end

MsgN("Loading Clientside Files")
for _, file in pairs (file.Find("flood/gamemode/client/*.lua", "LUA")) do
  MsgN("-> " .. file)
  AddCSLuaFile("flood/gamemode/client/" .. file)
end

MsgN("Loading Clientside VGUI Files")
for _, file in pairs (file.Find("flood/gamemode/client/vgui/*.lua", "LUA")) do
  MsgN("-> " .. file)
  AddCSLuaFile("flood/gamemode/client/vgui/" .. file)
end

-- Timer ConVars

CreateConVar("flood_build_time", 240, FCVAR_NOTIFY,
	     "Time allowed for building (def: 240)")
CreateConVar("flood_board_time", 20, FCVAR_NOTIFY,
	     "Time between build phase and flood phase (def: 20)")
CreateConVar("flood_flood_time", 10, FCVAR_NOTIFY,
	     "Time between board phase and fight phase (def: 10)")
CreateConVar("flood_fight_time", 300, FCVAR_NOTIFY,
	     "Time allowed for fighting (def: 300)")
CreateConVar("flood_reset_time", 10, FCVAR_NOTIFY,
	     "Time after fight phase to allow water to drain and other ending tasks (def: 10)")

-- Cash Convars
CreateConVar("flood_participation_cash", 50, FCVAR_NOTIFY,
	     "Amount of cash given to a player every 5 seconds of being alive (def: 50)")
CreateConVar("flood_bonus_cash", 2000, FCVAR_NOTIFY,
	     "Amount of cash given to the winner(s) of a round (def: 2000)")

-- Water Hurt System
CreateConVar("flood_wh_enabled", 1, FCVAR_NOTIFY,
	     "Does the water hurt players - 1=true 0=false (def: 1)")
CreateConVar("flood_wh_damage", 2, FCVAR_NOTIFY,
	     "How much damage a player takes per cycle (def: 2)")

-- Prop Limits
CreateConVar("flood_max_player_props", 20, FCVAR_NOTIFY,
	     "How many props a player can spawn (def: 20)")
CreateConVar("flood_max_donator_props", 30, FCVAR_NOTIFY,
	     "How many props a donator can spawn (def: 30)")
CreateConVar("flood_max_admin_props", 40, FCVAR_NOTIFY,
	     "How many props an admin can spawn (def: 40)")

function GM:Initialize()
  self.ShouldHaltGamemode = false
  self:InitializeRoundController()

  -- Dont allow the players to noclip
  RunConsoleCommand("sbox_noclip", "0")

  -- We have our own prop spawning system
  RunConsoleCommand("sbox_maxprops", "0")
end

function GM:InitPostEntity()
  self:CheckForWaterControllers()
  for _, ent in pairs(ents.GetAll()) do
    if ent:GetClass() == "trigger_hurt" then
      ent:Remove()
    end
  end
end

function GM:Think()
  self:ForcePlayerSpawn()
  self:CheckForWinner()

  if self.ShouldHaltGamemode == true then
    hook.Remove("Think", "Flood_TimeController")
  end
end

function GM:CleanUpMap()
  -- Refund what we can.
  self:RefundAllProps()

  -- Clean up the rest.
  game.CleanUpMap()

  self:InitPostEntity()
end

function GM:ShowHelp(ply)
  ply:ConCommand("flood_helpmenu")
end

function GM:EntityTakeDamage(ent, dmginfo)
  -- Apply damage to props if it is fighting phase.
  if GAMEMODE:GetGameState() == FLOOD_GS_FIGHT then
    local attacker = dmginfo:GetAttacker()
    if not ent:IsPlayer() then
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
      else
	if attacker:GetClass() == "entityflame" then
	  ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 0.5)
	else
	  ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 1)
	end
      end

      if ent:GetNWInt("CurrentPropHealth") <= 0 and IsValid(ent) then
	ent:Remove()
      end
    end
  else
    return false
  end
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

function GM:KeyPress(ply, key)
  if not ply:Alive() then
    if key == IN_ATTACK then
      ply:CycleSpectator(1)
    end
    if key == IN_ATTACK2 then
      ply:CycleSpectator(-1)
    end
  end
end
