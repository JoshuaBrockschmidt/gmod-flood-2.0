GM.ConstraintTools = GAMEMODE and GM.ConstraintTools or {}
GM.ConstructionTools = GAMEMODE and GM.ConstructionTools or {}

-- Tables are {"internal toolname", DonatorOnly bool, Enabled? bool},
GM.ConstraintTools = {
  {"rope", false, true},
  {"smartweld", false, true}
}

-- TODO: Replace these with tools compatible with the monetary system in use
--    or make them compatible
GM.ConstructionTools = {
  {"balloon", false, true},
  {"duplicator", false, true},
  {"thruster", false, true},
  {"stacker_improved", false, true}
}

function GM:CompileToolTable()
  local tools = {}

  for _, v in pairs(self.ConstraintTools) do
    table.insert(tools, v)
  end

  for _, v in pairs(self.ConstructionTools) do
    table.insert(tools, v)
  end

  return tools
end
