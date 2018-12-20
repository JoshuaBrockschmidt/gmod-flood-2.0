surface.CreateFont(
  "Flood_HUD_Small",
  {
    font = "Arial",
    size = 14,
    weight = 500,
    antialias = true
})

surface.CreateFont(
  "Flood_HUD",
  {
    font = "Arial",
    size = 16,
    weight = 500,
    antialias = true
})

surface.CreateFont(
  "Flood_HUD_Large",
  {
    font = "Arial",
    size = 30,
    weight = 500,
    antialias = true
})

surface.CreateFont(
  "Flood_HUD_B",
  {
    font = "Arial",
    size = 18,
    weight = 600,
    antialias = true
})

local x = ScrW()
local y = ScrH()

-- HUD variables.
local color_grey = Color(120, 120, 120, 100)
local color_black = Color(0, 0, 0, 200)
local active_color = Color(24, 24, 24, 255)
local outline_color = Color(0, 0, 0, 255)

-- Timer variables.
local GameState = 0
local BuildTimer = -1
local BoardTimer = -1
local FloodTimer = -1
local FightTimer = -1
local ResetTimer = -1

local xPos = x * 0.004
local yPos = y * 0.005

-- HUD positioning.
local Spacer = y * 0.006
local xSize = x * 0.2
local ySize = y * 0.04
local bWidth = Spacer + xSize + Spacer
local bHeight = Spacer + ySize + Spacer

net.Receive(
  "RoundState",
  function(len)
    GameState = net.ReadUInt(3)
    BuildTimer = net.ReadFloat()
    BoardTimer = net.ReadFloat()
    FloodTimer = net.ReadFloat()
    FightTimer = net.ReadFloat()
    ResetTimer = net.ReadFloat()
  end
)

--- Draw the HUD.
function GM:HUDPaint()
  if BuildTimer and BoardTimer and FloodTimer and FightTimer and ResetTimer then
    -- Draw boxes indicating the current game phase and the time remaining
    -- for each phase (if applicable).

    local boxW = x * 0.175
    local labelX = x * 0.01
    local timerX = x * 0.15

    -- Waiting for players to join.
    boxY0 = y * 0.005
    textY0 = boxY0 + Spacer
    if GameState == FLOOD_GS_WAIT then
      draw.RoundedBoxEx(
	6, xPos, boxY0, boxW,  x * 0.018, active_color, true, true, false, false
      )
      draw.SimpleText("Waiting for players...", "Flood_HUD", labelX, textY0, color_white, 0, 0)
    else
      draw.RoundedBoxEx(
	6, xPos, boxY0, boxW,  x * 0.018, color_grey, true, true, false, false
      )
      draw.SimpleText("Waiting for players...", "Flood_HUD", labelX, textY0, color_grey, 0, 0)
    end

    -- Boat building phase.
    local boxY1 = yPos + (Spacer * 6)
    local textY1 = boxY1 + Spacer * 0.7
    if GameState == FLOOD_GS_BUILD then
      draw.RoundedBox(0, xPos, boxY1, boxW,  x * 0.018, active_color)
      draw.SimpleText("Build a boat.", "Flood_HUD", labelX, textY1, color_white, 0, 0)
      draw.SimpleText(BuildTimer, "Flood_HUD", timerX, textY1, color_white, 0, 0)
    else
      draw.RoundedBox(0, xPos, boxY1, boxW,  x * 0.018, color_grey)
      draw.SimpleText("Build a boat.", "Flood_HUD", labelX, textY1, color_grey, 0, 0)
      draw.SimpleText(BuildTimer, "Flood_HUD", timerX, textY1, color_grey, 0, 0)
    end

    -- Boat boarding phase.
    local boxY2 = yPos + (Spacer * 12)
    local textY2 = boxY2 + Spacer * 0.7
    if GameState == FLOOD_GS_BOARD then
      draw.RoundedBox(0, xPos, boxY2, boxW,  x * 0.018, active_color)
      draw.SimpleText("Get on your boat!", "Flood_HUD", labelX, textY2, color_white, 0, 0)
      draw.SimpleText(BoardTimer, "Flood_HUD", timerX, textY2, color_white, 0, 0)
    else
      draw.RoundedBox(0, xPos, boxY2, boxW,  x * 0.018, color_grey)
      draw.SimpleText("Get on your boat!", "Flood_HUD", labelX, textY2, color_grey, 0, 0)
      draw.SimpleText(BoardTimer, "Flood_HUD", timerX, textY2, color_grey, 0, 0)
    end

    -- Flooding phase.
    local boxY3 = yPos + (Spacer * 18)
    local textY3 = boxY3 + Spacer * 0.7
    if GameState == FLOOD_GS_FLOOD then
      draw.RoundedBox(0, xPos, boxY3, boxW,  x * 0.018, active_color)
      draw.SimpleText("Water rising...", "Flood_HUD", labelX, textY3, color_white, 0, 0)
      draw.SimpleText(FloodTimer, "Flood_HUD", timerX, textY3, color_white, 0, 0)
    else
      draw.RoundedBox(0, xPos, boxY3, boxW,  x * 0.018, color_grey)
      draw.SimpleText("Water rising...", "Flood_HUD", labelX, textY3, color_grey, 0, 0)
      draw.SimpleText(FloodTimer, "Flood_HUD", timerX, textY3, color_grey, 0, 0)
    end

    -- Destroy enemy boats.
    local boxY4 = yPos + (Spacer * 24)
    local textY4 = boxY4 + Spacer * 0.7
    if GameState == FLOOD_GS_FIGHT then
      draw.RoundedBox(0, xPos, boxY4, boxW,  x * 0.018, active_color)
      draw.SimpleText("Destroy enemy boats!", "Flood_HUD", labelX, textY4, color_white, 0, 0)
      draw.SimpleText(FightTimer, "Flood_HUD", timerX, textY4, color_white, 0, 0)
    else
      draw.RoundedBox(0, xPos, boxY4, boxW,  x * 0.018, color_grey)
      draw.SimpleText("Destroy enemy boats!", "Flood_HUD", labelX, textY4, color_grey, 0, 0)
      draw.SimpleText(FightTimer, "Flood_HUD", timerX, textY4, color_grey, 0, 0)
    end

    -- Restarting the round.
    local boxY5 = yPos + (Spacer * 30)
    local textY5 = boxY5 + Spacer * 0.7
    if GameState == FLOOD_GS_RESET then
      -- We subtract 1 from the x coordinate and width to align with the other boxes.
      draw.RoundedBoxEx(
	6, xPos, boxY5, boxW,  x * 0.018, active_color, false, false, true, true
      )
      draw.SimpleText("Restarting the round.", "Flood_HUD", labelX, textY5, color_white, 0, 0)
      draw.SimpleText(ResetTimer, "Flood_HUD", timerX, textY5, color_white, 0, 0)
    else
      -- We subtract 1 from the x coordinate and width to align with the other boxes.
      draw.RoundedBoxEx(
	6, xPos, boxY5, boxW,  x * 0.018, color_grey, false, false, true, true
      )
      draw.SimpleText("Restarting the round.", "Flood_HUD", labelX, textY5, color_grey, 0, 0)
      draw.SimpleText(ResetTimer, "Flood_HUD", timerX, textY5, color_grey, 0, 0)
    end
  end

  -- Get entity player `is looking at.
  local tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
  local ent = tr.Entity

  -- Display prop's health if it is owned by a player.
  if ent:IsValid() and not ent:IsPlayer() and NADMOD.PropOwners[ent:EntIndex()] then
    if ent:GetNWInt("CurrentPropHealth") == "" or
      ent:GetNWInt("CurrentPropHealth") == nil or
      ent:GetNWInt("CurrentPropHealth") == NULL
    then
      draw.SimpleText("Fetching Health", "Flood_HUD_Small", x * 0.5, y * 0.5 - 25, color_white, 1, 1)
    else
      draw.SimpleText("Health: " .. ent:GetNWInt("CurrentPropHealth"), "Flood_HUD_Small",
		      x * 0.5, y * 0.5 - 25, color_white, 1, 1)
    end
  end

  -- Display player's health and name.
  if ent:IsValid() and ent:IsPlayer() then
    draw.SimpleText("Name: " .. ent:GetName(), "Flood_HUD_Small",
		    x * 0.5, y * 0.5 - 75, color_white, 1, 1)
    draw.SimpleText("Health: " .. ent:Health(), "Flood_HUD_Small",
		    x * 0.5, y * 0.5 - 60, color_white, 1, 1)
  end

  -- Bottom left HUD.
  if LocalPlayer():Alive() and IsValid(LocalPlayer()) then
    draw.RoundedBox(
      6, 4, y - ySize - Spacer - (bHeight * 2), bWidth, bHeight * 2 + ySize, Color(24, 24, 24, 255)
    )

    -- Health
    local pHealth = LocalPlayer():Health()
    local pHealthClamp = math.Clamp(pHealth / 100, 0, 1)
    local pHealthWidth = (xSize - Spacer) * pHealthClamp

    draw.RoundedBoxEx(6, Spacer * 2, y - (Spacer * 4) - (ySize * 3), Spacer + pHealthWidth, ySize,
		      Color(128, 28, 28, 255), true, true, false, false)
    draw.SimpleText(math.Max(pHealth, 0).." HP","Flood_HUD_B",
		    xSize * 0.5 + (Spacer * 2), y - (ySize * 2.5) - (Spacer * 4),
		    color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    -- Ammo
    local activeWep = LocalPlayer():GetActiveWeapon()
    if IsValid(activeWep) then
      local ammoType = activeWep:GetPrimaryAmmoType()
      if LocalPlayer():GetAmmoCount(ammoType) > 0 or activeWep:Clip1() > 0 then
	local wBulletCount = LocalPlayer():GetAmmoCount(ammoType) + activeWep:Clip1() + 1
	local wBulletClamp = math.Clamp(wBulletCount / 100, 0, 1)
	local wBulletWidth = (xSize - bWidth) * wBulletClamp

	draw.RoundedBox(0, Spacer * 2, y - (ySize * 2) - (Spacer * 3), bWidth + wBulletWidth, ySize,
			Color(30, 105, 105, 255))
	draw.SimpleText(wBulletCount.." Bullets", "Flood_HUD_B",
			xSize * 0.5 + (Spacer * 2), y - ySize - (ySize * 0.5) - (Spacer * 3),
			color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      else
	draw.RoundedBox(0, Spacer * 2, y - (ySize * 2) - (Spacer * 3), xSize, ySize,
			Color(30, 105, 105, 255))
	draw.SimpleText("Doesn't Use Ammo", "Flood_HUD_B",
			xSize * 0.5 + (Spacer * 2), y - ySize - (ySize * 0.5) - (Spacer * 3),
			color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      end
    else
      draw.RoundedBox(0, Spacer * 2, y - (ySize * 2) - (Spacer * 3), xSize, ySize,
		      Color(30, 105, 105, 255))
      draw.SimpleText("No Ammo", "Flood_HUD_B",
		      xSize * 0.5 + (Spacer * 2), y - ySize - (ySize * 0.5) - (Spacer * 3),
		      color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Cash
    local pCash = LocalPlayer():GetNWInt("flood_cash") or 0
    local pCashClamp = math.Clamp(pCash / 5000, 0, xSize)

    draw.RoundedBoxEx(6, Spacer * 2, y - ySize - (Spacer * 2), xSize, ySize,
		      Color(63, 140, 64, 255), false, false, true, true)
    draw.SimpleText("$" .. pCash, "Flood_HUD_B",
		    (xSize * 0.5) + (Spacer * 2), y - (ySize * 0.5) - (Spacer * 2),
		    WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
end

--- Checks whether a HUD should be drawn.
-- @param name Name of the HUD.
-- @return true if the HUD should be draw and false otherwise.
local function hideHud(name)
  for _, validName in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
    if name == validName then
      return false
    end
  end
end
hook.Add("HUDShouldDraw", "hideHud", hideHud)
