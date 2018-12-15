local x = ScrW()
local y = ScrH()
local g_ToolMenu = {}

local PANEL = {}
function PANEL:Init()
  if not self.ToolTable then
    self.ToolTable = GAMEMODE:CompileToolTable()
  end

  if not self.GmodTools then
    self.GmodTools = spawnmenu.GetTools()
  end

  self.List = vgui.Create("DCategoryList", self)
  self.List:Dock(LEFT)
  self.List:SetWidth(130)
  print(self.List)
  self.List.Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
  end

  self.Content = vgui.Create("DCategoryList", self)
  self.Content:Dock(FILL)
  self.Content:DockMargin( 6, 0, 0, 0 )
  self.Content.Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
  end

  if self.GmodTools then
    for k, v in pairs(self.GmodTools[1].Items) do
      if type(v) == "table" then
	local Name = v.ItemName
	local Label = v.Text
	v.ItemName = nil
	v.Text = nil
	self:AddCategory(Name, Label, v)
      end
    end
  else
    LocalPlayer():ChatPrint("There has been an error loading your tools section, please rejoin the server or contact an administrator to resolve the issue.")
  end
end

function PANEL:AddCategory(Name, Label, tItems)
  -- Find all valid tools for this category.
  validTools = {}
  for _, item in pairs(tItems) do
    for _, tools in pairs(self.ToolTable) do
      if tostring(item.ItemName) == tostring(tools[1]) then
	if tobool(tools[3]) == true then
	  table.insert(validTools, item)
	end
      end
    end
  end

  -- If there are valid tools, add this category and its tools to the panel.
  -- Otherwise don't add a new category.
  if next(validTools) ~= nil then
    local Category = self.List:Add(Label)
    Category.Paint = function(self, w, h)
      draw.RoundedBox(4, 0, 0, w, h, Color(240, 240, 240, 255))
      draw.RoundedBoxEx(
	4, 0, 0, w, self.Header:GetTall(), Color(24, 24, 24, 255), true, true, false, false)
    end
    Category:SetCookieName("ToolMenu." .. tostring(Name))

    for _, tool in pairs(validTools) do
      local item = Category:Add(tool.Text)
      item.DoClick = function(button)
	self:CreateCP(button)
	LocalPlayer():ConCommand(tool.Command)
      end

      item.ControlPanelBuildFunction = tool.CPanelFunction
      item.Command = tool.Command
      item.Name = tool.ItemName
      item.Controls = tool.Controls
      item.Text = tool.Text
    end

    self:InvalidateLayout()
  end
end

function PANEL:CreateCP(button) 
  if self.LastSelected then 
    self.LastSelected:SetSelected(false)
  end

  button:SetSelected(true)
  self.LastSelected = button

  local cp = controlpanel.Get(button.Name)
  if !cp:GetInitialized() then
    cp:FillViaTable(button)
  end

  self.Content:Clear()
  self.Content:AddItem(cp)
  self.Content:Rebuild()
  cp:SetVisible(true)
  cp:Dock(TOP)
  cp.Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240, 255))
    draw.RoundedBox(4, 0, 0, w, self.Header:GetTall(), Color(24, 24, 24, 255))
  end

  g_ActiveControlPanel = cp
end
vgui.Register("Flood_ShopMenu_Tools", PANEL)
