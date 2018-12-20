-- TEXTABLE LAYOUT
-- {"Text", Color(), duration, algorithm}
local TEXTABLE = {}

surface.CreateFont(
  "TEXREND",
  {
    font = "Tehoma",
    size = 70,
    weight = 900,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont(
  "TEXREND_SMALL",
  {
    font = "Tehoma",
    size = 35,
    weight = 900,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

for i = 0, 20 do
  surface.CreateFont(
    "TEXREND" .. i,
    {
      font = "Tehoma",
      size = 70 + i * 1.5,
      weight = 900,
      blursize = 0,
      scanlines = 0,
      antialias = true,
      underline = false,
      italic = false,
      strikeout = false,
      symbol = false,
      rotary = false,
      shadow = false,
      additive = false,
      outline = false,
  })
end

--- Renders queued text on the player's screen and removes them from the queue when their duration
-- of display is fully diminished.
function GM:DrawScreenText()
  local icou = 0
  for k, textInfo in pairs(TEXTABLE) do
    icou = icou + 1
    if not textInfo.__DEX then
      textInfo.__DEX = {}
      textInfo.__DEX.STime = CurTime()
    end
    local dur = textInfo[3]
    local col = textInfo[2]
    local text = textInfo[1]
    local alg = textInfo[4]
    surface.SetFont("TEXREND")
    local wi, hei = surface.GetTextSize("ABCDEFG")
    if alg == "flash" then
      draw.SimpleText(
	text, "TEXREND", ScrW() / 2 , (ScrH() / 5) + icou * hei,
	Color(col.r, col.g, col.b, math.sin(CurTime()^1.144) * 100 + 155),
	TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
      )
    end

    if alg == "none" then
      draw.SimpleText(
	text, "TEXREND",
	(ScrW() / 2), (ScrH() / 5) + icou * hei,
	Color(col.r, col.g, col.b, 255),
	TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
      )
    elseif alg == "sideside" then
      draw.SimpleText(
	text, "TEXREND",
	(ScrW() / 2) + math.sin((CurTime() - textInfo.__DEX.STime) * 5) * 100,
	(ScrH() / 5) + icou * hei , Color(col.r, col.g, col.b, 255),
	TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
      )
    elseif alg == "pulse" then
      draw.SimpleText(
	text, "TEXREND" .. math.abs(math.floor(math.sin((CurTime() - textInfo.__DEX.STime) * 5) * 20)),
	(ScrW() / 2)  , (ScrH() / 5) + icou * hei , Color(col.r, col.g, col.b, 255),
	TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
      )
    elseif alg == "small" then
      draw.SimpleText(
	text, "TEXREND_SMALL", (ScrW() / 2), (ScrH() / 5) + icou * hei,
	Color(col.r, col.g, col.b, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
      )
    end

    if ((textInfo.__DEX.STime + dur) - CurTime()) < 0 then
      TEXTABLE[k] = nil
    end
  end
end

hook.Add(
  "HUDPaint", "GMTEXREND",
  function()
    GAMEMODE:DrawScreenText()
  end
)

--- Temporarily displays text on the player's screen.
-- @param text Text to display.
-- @param col Color of the text.
-- @param duration Seconds to display the text for.
-- @param typ Method of displaying the text.
--      * none - No effects.
--      * flash - Repeatedly flash the text.
--      * sideside - Move text side to side.
--      * pulse - Flucuate the size of the text.
--      * small - Small text.
function GM:AddTextRegister(text, col, duration, typ)
  for _, textInfo in pairs(TEXTABLE) do
    if col == Color(123, 123, 123) then
      col = Color(math.random(1, 255), math.random(1, 255), math.random(1, 255))
    end
    if textInfo[1] == text then
      textInfo[2] = col
      textInfo[3] = duration
      return
    end
  end
  TEXTABLE[#TEXTABLE + 1] = {text, col, duration, typ}
end

--- Removes text registered with GM:AddTextRegister from the player's screen prematurely.
-- @param text Text identifying the registered text object to remove.
function GM:RemoveText(text)
  for k, textInfo in pairs(TEXTABLE) do
    if textInfo[1] == text then
      TEXTABLE[k] = nil
    end
  end
end

--- Add or removes text from the screen as per the server's request.
function GM:GetScreenMessage()
  local command = net.ReadString()
  local data = net.ReadTable()

  if command == "SCRTEXT_ADD" then
    GAMEMODE:AddTextRegister(unpack(data))
  end
  if command == "SCRTEXT_REMOVE" then
    GAMEMODE:RemoveText(unpack(data))
  end
end

net.Receive("GAMEMSG", GM.GetScreenMessage)
