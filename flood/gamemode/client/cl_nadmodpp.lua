-- =================================
-- NADMOD PP - Prop Protection
-- By Nebual@nebtown.info 2012
-- Menus designed after SpaceTech's Simple Prop Protection
-- =================================
if not NADMOD then
  NADMOD = {}
  NADMOD.PropOwners = {}
  NADMOD.PPConfig = {}
  NADMOD.Friends = {}
end

local PropOwners = NADMOD.PropOwners
net.Receive(
  "nadmod_propowners",
  function(len)
    local num = net.ReadUInt(16)
    for k = 1, num do
      local id,str = net.ReadUInt(16), net.ReadString()
      if str == "-" then PropOwners[id] = nil
      elseif str == "W" then PropOwners[id] = "World"
      elseif str == "O" then PropOwners[id] = "Ownerless"
      else PropOwners[id] = str
      end
    end
  end
)

local font = "ChatFont"
hook.Add(
  "HUDPaint", "NADMOD.HUDPaint",
  function()
    local tr = LocalPlayer():GetEyeTrace()
    if not tr.HitNonWorld then
      return
    end
    local ent = tr.Entity
    -- Only show information for entities that are props owned by a player.
    if ent:IsValid() and not ent:IsPlayer() and PropOwners[ent:EntIndex()] then
      local text = "Owner: " .. PropOwners[ent:EntIndex()]
      local text2 = "'" .. string.sub(table.remove(string.Explode("/", ent:GetModel())), 1, -5) ..
	"' [" .. ent:EntIndex() .. "]"
      local text3 = ent:GetClass()
      surface.SetFont(font)
      local Width, Height = surface.GetTextSize(text)
      local w2,h2 = surface.GetTextSize(text2)
      local w3,h3 = surface.GetTextSize(text3)
      local boxHeight = Height + h2 + h3 + 16
      local boxWidth = math.Max(Width,w2,w3) + 25
      draw.RoundedBox(4, ScrW() - (boxWidth + 4), (ScrH() / 2 - 200) - 16, boxWidth, boxHeight,
		      Color(0, 0, 0, 150))
      draw.SimpleText(text, font, ScrW() - (Width / 2) - 20, ScrH() / 2 - 200,
		      Color(255, 255, 255, 255), 1, 1)
      draw.SimpleText(text2, font, ScrW() - (w2 / 2) - 20, ScrH() / 2 - 200 + Height,
		      Color(255, 255, 255, 255), 1, 1)
      draw.SimpleText(text3, font, ScrW() - (w3 / 2) - 20, ScrH() / 2 - 200 + Height + h2,
		      Color(255, 255, 255, 255), 1, 1)
    end
  end
)

function NADMOD.CleanCLRagdolls()
  for k, v in pairs(ents.FindByClass("class C_ClientRagdoll")) do
    v:SetNoDraw(true)
  end
  for k, v in pairs(ents.FindByClass("class C_BaseAnimating")) do
    v:SetNoDraw(true)
  end
end
net.Receive("nadmod_cleanclragdolls", NADMOD.CleanCLRagdolls)
concommand.Add("npp_cleanclragdolls", NADMOD.CleanCLRagdolls)

-- =============================
-- NADMOD PP CPanels
-- =============================
net.Receive(
  "nadmod_ppconfig",
  function(len)
    NADMOD.PPConfig = net.ReadTable()
    for k,v in pairs(NADMOD.PPConfig) do
      local val = v
      if isbool(v) then
	val = v and "1" or "0"
      end

      CreateClientConVar("npp_" .. k,val, false, false)
      RunConsoleCommand("npp_" .. k,val)
    end
    NADMOD.AdminPanel(NADMOD.AdminCPanel, true)
  end
)

concommand.Add(
  "npp_apply",
  function(ply,cmd,args)
    for k,v in pairs(NADMOD.PPConfig) do
      if isbool(v) then
	NADMOD.PPConfig[k] = GetConVar("npp_" .. k):GetBool()
      elseif isnumber(v) then
	NADMOD.PPConfig[k] = GetConVarNumber("npp_" .. k)
      else
	NADMOD.PPConfig[k] = GetConVarString("npp_" .. k)
      end
    end
    net.Start("nadmod_ppconfig")
    net.WriteTable(NADMOD.PPConfig)
    net.SendToServer()
  end
)

function NADMOD.AdminPanel(Panel, runByNetReceive)
  if Panel and not NADMOD.AdminCPanel then
    NADMOD.AdminCPanel = Panel
  end
  if not runByNetReceive then
    RunConsoleCommand("npp_refreshconfig")
    timer.Create(
      "NADMOD.AdminPanelCheckFail", 0.75, 1,
      function()
	Panel:ClearControls()
	Panel:Help("Waiting for the server to say you're an admin...")
      end
    )
    return
  end

  timer.Remove("NADMOD.AdminPanelCheckFail")
  Panel:ClearControls()
  Panel:SetName("NADMOD PP Admin Panel")

  Panel:CheckBox("Main PP Power Switch", "npp_toggle")
  Panel:CheckBox("Admins can touch anything", "npp_adminall")
  Panel:CheckBox("Use Protection", "npp_use")

  local txt = Panel:Help("Autoclean Disconnected Players?")
  txt:SetAutoStretchVertical(false)
  txt:SetContentAlignment(TEXT_ALIGN_CENTER)
  Panel:CheckBox("Autoclean Admins", "npp_autocdpadmins")
  Panel:NumSlider("Autoclean Timer", "npp_autocdp", 0, 1200, 0)
  Panel:Button("Apply Settings", "npp_apply")

  local txt = Panel:Help("                     Cleanup Panel")
  txt:SetContentAlignment(TEXT_ALIGN_CENTER)
  txt:SetFont("DermaDefaultBold")
  txt:SetAutoStretchVertical(false)

  local counts = {}
  for k, v in pairs(NADMOD.PropOwners) do
    counts[v] = (counts[v] or 0) + 1
  end
  local dccount = 0
  for k, v in pairs(counts) do
    if k ~= "World" and k ~= "Ownerless" then
      dccount = dccount + v
    end
  end
  for k, ply in pairs(player.GetAll()) do
    if IsValid(ply) then
      Panel:Button(ply:Nick() .. " (" .. (counts[ply:Nick()] or 0) .. ")",
		   "nadmod_cleanupprops", ply:EntIndex())
      dccount = dccount - (counts[ply:Nick()] or 0)
    end
  end

  Panel:Help(""):SetAutoStretchVertical(false) -- Spacer
  Panel:Button("Cleanup Disconnected Players Props (" .. dccount .. ")", "nadmod_cdp")
  Panel:Button("Cleanup All NPCs", "nadmod_cleanclass", "npc_*")
  Panel:Button("Cleanup All Ragdolls", "nadmod_cleanclass", "prop_ragdol*")
  Panel:Button("Cleanup Clientside Ragdolls", "nadmod_cleanclragdolls")
end

net.Receive(
  "nadmod_ppfriends",
  function(len)
    NADMOD.Friends = net.ReadTable()
    for _, tar in pairs(player.GetAll()) do
      local isFriend = NADMOD.Friends[tar:SteamID()] and "1" or "0"
      CreateClientConVar("npp_friend_" .. tar:UniqueID(), isFriend, false, false)
      RunConsoleCommand("npp_friend_" .. tar:UniqueID(), isFriend)
    end
  end
)

concommand.Add(
  "npp_applyfriends",
  function(ply,cmd,args)
    for _, tar in pairs(player.GetAll()) do
      NADMOD.Friends[tar:SteamID()] = GetConVar("npp_friend_" .. tar:UniqueID()):GetBool()
    end
    net.Start("nadmod_ppfriends")
    net.WriteTable(NADMOD.Friends)
    net.SendToServer()
  end
)

function NADMOD.ClientPanel(Panel)
  RunConsoleCommand("npp_refreshfriends")
  Panel:ClearControls()
  if not NADMOD.ClientCPanel then
    NADMOD.ClientCPanel = Panel
  end
  Panel:SetName("NADMOD - Client Panel")

  Panel:Button("Cleanup Props", "nadmod_cleanupprops")
  Panel:Button("Clear Clientside Ragdolls", "nadmod_cleanclragdolls")

  local txt = Panel:Help("                     Friends Panel")
  txt:SetContentAlignment(TEXT_ALIGN_CENTER)
  txt:SetFont("DermaDefaultBold")
  txt:SetAutoStretchVertical(false)

  local Players = player.GetAll()
  if table.Count(Players) == 1 then
    Panel:Help("No Other Players Are Online")
  else
    for _, tar in pairs(Players) do
      if IsValid(tar) and tar ~= LocalPlayer() then
	Panel:CheckBox(tar:Nick(), "npp_friend_"..tar:UniqueID())
      end
    end
    Panel:Button("Apply Friends", "npp_applyfriends")
  end
end

function NADMOD.SpawnMenuOpen()
  if NADMOD.AdminCPanel then
    NADMOD.AdminPanel(NADMOD.AdminCPanel)
  end
  if NADMOD.ClientCPanel then
    NADMOD.ClientPanel(NADMOD.ClientCPanel)
  end
end
hook.Add("SpawnMenuOpen", "NADMOD.SpawnMenuOpen", NADMOD.SpawnMenuOpen)

function NADMOD.PopulateToolMenu()
  spawnmenu.AddToolMenuOption("Utilities", "NADMOD Prop Protection", "Admin", "Admin", "", "",
			      NADMOD.AdminPanel)
  spawnmenu.AddToolMenuOption("Utilities", "NADMOD Prop Protection", "Client", "Client", "", "",
			      NADMOD.ClientPanel)
end
hook.Add("PopulateToolMenu", "NADMOD.PopulateToolMenu", NADMOD.PopulateToolMenu)

net.Receive(
  "nadmod_notify",
  function(len)
    local text = net.ReadString()
    GAMEMODE:AddNotify(text, NOTIFY_GENERIC, 5)
    surface.PlaySound("ambient/water/drip"..math.random(1, 4)..".wav")
    print(text)
  end
)
