local function CreateDeathNotify()
  local x, y = ScrW(), ScrH()

  g_DeathNotify = vgui.Create("DNotify")
  g_DeathNotify:SetPos(0, 25)
  g_DeathNotify:SetSize(x - 25, y)
  g_DeathNotify:SetAlignment(9)
  g_DeathNotify:SetLife(4)
  g_DeathNotify:ParentToHUD()
end
hook.Add("InitPostEntity", "CreateDeathNotify", CreateDeathNotify)

local function RecvPlayerKilledByPlayer(length)
  local victim = net.ReadEntity()
  local inflictor = net.ReadString()
  local attacker = net.ReadEntity()

  if not IsValid(attacker) or not IsValid(victim) then
    return
  end

  GAMEMODE:AddDeathNotice(victim, inflictor, attacker)
end
net.Receive("PlayerKilledByPlayer", RecvPlayerKilledByPlayer)

local function RecvPlayerKilledSelf(length)
  local victim 	= net.ReadEntity()

  if not IsValid(victim) then
    return
  end
  GAMEMODE:AddPlayerAction(victim, GAMEMODE.SuicideString)
end
net.Receive("PlayerKilledSelf", RecvPlayerKilledSelf)

local function RecvPlayerKilled(length)
  local victim = net.ReadEntity()
  local inflictor = net.ReadString()
  local attacker = "#" .. net.ReadString()

  if not IsValid(victim) then
    return
  end
  GAMEMODE:AddDeathNotice(victim, inflictor, attacker)
end
net.Receive("PlayerKilled", RecvPlayerKilled)

local function RecvPlayerKilledNPC(length)
  local victim = "#" .. net.ReadString()
  local inflictor = net.ReadString()
  local attacker = net.ReadEntity()

  if not IsValid(attacker) then
    return
  end
  GAMEMODE:AddDeathNotice(victim, inflictor, attacker)
end
net.Receive("PlayerKilledNPC", RecvPlayerKilledNPC)

local function RecvNPCKilledNPC( length )
  local victim = "#" .. net.ReadString()
  local inflictor = net.ReadString()
  local attacker = "#" .. net.ReadString()

  GAMEMODE:AddDeathNotice(victim, inflictor, attacker)
end
net.Receive("NPCKilledNPC", RecvNPCKilledNPC)

function GM:AddDeathNotice(victim, inflictor, attacker)
  if not IsValid( g_DeathNotify) then
    return
  end
  local pnl = vgui.Create("GameNotice", g_DeathNotify)
  pnl:AddText(attacker)
  pnl:AddIcon(inflictor)
  pnl:AddText(victim)

  g_DeathNotify:AddItem(pnl)
end

function GM:AddPlayerAction(...)
  if not IsValid(g_DeathNotify) then
    return
  end

  local pnl = vgui.Create("GameNotice", g_DeathNotify)

  for _, text in ipairs({...}) do
    pnl:AddText(text)
  end

  g_DeathNotify:AddItem(pnl)
end
