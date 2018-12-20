function CheckAFKTimerInit( )
  if not game.SinglePlayer() then
    timer.Create("CheckAFK", 15, 0, CheckAFK)
  end
end
hook.Add("InitPostEntity", "AfkCheckingHook", CheckAFKTimerInit)

-- CHECK AFK
local afkInfo = {ang = nil, pos = nil, mx = 0, my = 0, t = 0}
function CheckAFK()
  if not IsValid(LocalPlayer()) then
    return
  elseif LocalPlayer():IsAdmin() then
    return
  elseif not afkInfo.ang or not afkInfo.pos then
    afkInfo.ang = LocalPlayer():GetAngles()
    afkInfo.pos = LocalPlayer():GetPos()
    afkInfo.mx = gui.MouseX()
    afkInfo.my = gui.MouseY()
    afkInfo.t = CurTime()
    return
  end

  if LocalPlayer():GetNWInt("flood_afkticks") > 0 then
    if not timer.Exists("AFKCountDecay:" .. LocalPlayer():UniqueID()) then
      local callback = function()
	LocalPlayer():SetNWInt("flood_afkticks", 0)
	chat.AddText(
	  Color(255, 140, 0), "[AFK System] ", color_white, "AFK count before kick has been reset."
	)
      end
      timer.Create("AFKCountDecay:" .. LocalPlayer():UniqueID(), 600, 1, callback)
    end
  end

  if LocalPlayer():Alive() then
    afkTimer = 30
    if afkTimer <= 0 then
      afkTimer = 30
    end

    if LocalPlayer():GetAngles() != afkInfo.ang then
      afkInfo.ang = LocalPlayer():GetAngles()
      afkInfo.t = CurTime()

    elseif gui.MouseX() != afkInfo.mx or gui.MouseY() != afkInfo.my then
      afkInfo.mx = gui.MouseX()
      afkInfo.my = gui.MouseY()
      afkInfo.t = CurTime()

    elseif LocalPlayer():GetPos():Distance(afkInfo.pos) > 10 then
      afkInfo.pos = LocalPlayer():GetPos()
      afkInfo.t = CurTime()

    elseif CurTime() > (afkInfo.t + afkTimer) then
      if LocalPlayer():GetNWInt("flood_afkticks") >= 5 then
	RunConsoleCommand("kickplayer")
      end

    elseif CurTime() > (afkInfo.t + (afkTimer / 2)) then
      chat.AddText(Color(255, 140, 0), "[AFK System] ", color_white,
		   "You will be slain if you do not regain activity.")
      if timer.Exists("AFKCountDecay:" .. LocalPlayer():UniqueID()) then
	timer.Destroy("AFKCountDecay:" .. LocalPlayer():UniqueID())
      end
    end
  end
end
