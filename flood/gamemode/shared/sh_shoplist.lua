PropCategories = {}
Props = {}
WeaponCategories = {}
Weapons = {}

local INCLUDE_CSGO_PROPS = true

--- Adds a prop to the prop list.
-- @param prop Table describing prop.
local function addProp(prop)
  table.insert(Props, prop)
end

--- Adds a weapon to the weapon list.
-- @param weapon Table describing weapon.
local function addWeapon(weapon)
  table.insert(Weapons, weapon)
end

local FLOAT_PROPS = 1
local ARMOR_PROPS = 2
local DONATOR_PROPS = 3


-- Prop categories.
PropCategories[FLOAT_PROPS] = "Bouyant Props"
PropCategories[ARMOR_PROPS] = "Armor Props"
PropCategories[DONATOR_PROPS] = "Donator Props"


-- Weapon categories.
WeaponCategories[1] = "Basic Weapons"


-- Bouyant props.
addProp({
    Description = "Blue Barrel",
    Model = "models/props_borealis/bluebarrel001.mdl",
    Group = FLOAT_PROPS,
    Price = 50,
    Health = 100,
    DonatorOnly = false
})
addProp({
    Description = "Curved Wooden Platform",
    Model = "models/props_phx/construct/wood/wood_curve90x2.mdl",
    Group = FLOAT_PROPS,
    Price = 70,
    Health = 140,
    DonatorOnly = false
})
addProp({
    Description = "Wooden Platform",
    Model = "models/props_phx/construct/wood/wood_panel2x2.mdl",
    Group = FLOAT_PROPS,
    Price = 75,
    Health = 150,
    DonatorOnly = false
})
addProp({
    Description = "Half Wooden Circle",
    Model = "models/props_phx/construct/wood/wood_angle180.mdl",
    Group = FLOAT_PROPS,
    Price = 35,
    Health = 70,
    DonatorOnly = false
})
addProp({
    Description = "Wooden Circle",
    Model = "models/props_phx/construct/wood/wood_angle360.mdl",
    Group = FLOAT_PROPS,
    Price = 70,
    Health = 140,
    DonatorOnly = false
})
addProp({
    Description = "Shelf",
    Model = "models/props_c17/furnitureshelf001a.mdl",
    Group = FLOAT_PROPS,
    Price = 120,
    Health = 400,
    DonatorOnly = false
})
addProp({
    Description = "Short Dock Pole",
    Model = "models/props_docks/dock01_pole01a_128.mdl",
    Group = FLOAT_PROPS,
    Price = 100,
    Health = 300,
    DonatorOnly = false
})
addProp({
    Description = "Dock Pole",
    Model = "models/props_docks/dock03_pole01a_256.mdl",
    Group = FLOAT_PROPS,
    Price = 120,
    Health = 360,
    DonatorOnly = false
})
addProp({
    Description = "Vending Machine Door",
    Model = "models/props_interiors/vendingmachinesoda01a_door.mdl",
    Group = FLOAT_PROPS,
    Price = 150,
    Health = 400,
    DonatorOnly = false
})
addProp({
    Description = "Vending Machine",
    Model = "models/props_interiors/vendingmachinesoda01a.mdl",
    Group = FLOAT_PROPS,
    Price = 300,
    Health = 800,
    DonatorOnly = false
})


-- Armor props.
addProp({
    Description = "Metal Bars",
    Model = "models/props_building_details/storefront_template001a_bars.mdl",
    Group = ARMOR_PROPS,
    Price = 30,
    Health = 200,
    DonatorOnly = false
})
addProp({
    Description = "Small Metal Panel",
    Model = "models/props_debris/metal_panel02a.mdl",
    Group = ARMOR_PROPS,
    Price = 30,
    Health = 200,
    DonatorOnly = false
})
addProp({
    Description = "Large Metal Panel",
    Model = "models/props_debris/metal_panel01a.mdl",
    Group = ARMOR_PROPS,
    Price = 50,
    Health = 400,
    DonatorOnly = false
})
addProp({
    Description = "Rack",
    Model = "models/props_trainstation/traincar_rack001.mdl",
    Group = ARMOR_PROPS,
    Price = 50,
    Health = 400,
    DonatorOnly = false
})
addProp({
    Description = "Metal Door",
    Model = "models/props_borealis/borealis_door001a.mdl",
    Group = ARMOR_PROPS,
    Price = 60,
    Health = 500,
    DonatorOnly = false
})
addProp({
    Description = "Dumpster Lid",
    Model = "models/props_junk/trashdumpster02b.mdl",
    Group = ARMOR_PROPS,
    Price = 60,
    Health = 600,
    DonatorOnly = false
})
addProp({
    Description = "Blast Door",
    Model = "models/props_lab/blastdoor001b.mdl",
    Group = ARMOR_PROPS,
    Price = 150,
    Health = 1250,
    DonatorOnly = false
})
addProp({
    Description = "Double Blast Door",
    Model = "models/props_lab/blastdoor001c.mdl",
    Group = ARMOR_PROPS,
    Price = 300,
    Health = 2500,
    DonatorOnly = false
})
addProp({
    Description = "Radiator",
    Model = "models/props_c17/furnitureradiator001a.mdl",
    Group = ARMOR_PROPS,
    Price = 30,
    Health = 250,
    DonatorOnly = false
})
addProp({
    Description = "Metal Arch",
    Model = "models/props_trainstation/trainstation_arch001.mdl",
    Group = ARMOR_PROPS,
    Price = 40,
    Health = 250,
    DonatorOnly = false
})
addProp({
    Description = "Bathtub",
    Model = "models/props_c17/furniturebathtub001a.mdl",
    Group = ARMOR_PROPS,
    Price = 45,
    Health = 300,
    DonatorOnly = false
})
addProp({
    Description = "Push Cart",
    Model = "models/props_junk/pushcart01a.mdl",
    Group = ARMOR_PROPS,
    Price = 60,
    Health = 500,
    DonatorOnly = false
})
addProp({
    Description = "Lockers",
    Model = "models/props_c17/lockers001a.mdl",
    Group = ARMOR_PROPS,
    Price = 75,
    Health = 700,
    DonatorOnly = false
})
addProp({
    Description = "Concrete Barrier",
    Model = "models/props_c17/concrete_barrier001a.mdl",
    Group = ARMOR_PROPS,
    Price = 75,
    Health = 700,
    DonatorOnly = false
})
addProp({
    Description = "Coffin Piece",
    Model = "models/props_c17/gravestone_coffinpiece001a.mdl",
    Group = ARMOR_PROPS,
    Price = 85,
    Health = 750,
    DonatorOnly = false
})
addProp({
    Description = "Washing Machine",
    Model = "models/props_c17/furniturewashingmachine001a.mdl",
    Group = ARMOR_PROPS,
    Price = 50,
    Health = 500,
    DonatorOnly = false
})
addProp({
    Description = "Stove",
    Model = "models/props_c17/furniturestove001a.mdl",
    Group = ARMOR_PROPS,
    Price = 100,
    Health = 1000,
    DonatorOnly = false
})
addProp({
    Description = "Combine Barrier",
    Model = "models/props_combine/combine_barricade_short02a.mdl",
    Group = ARMOR_PROPS,
    Price = 250,
    Health = 2000,
    DonatorOnly = false
})


-- CS:GO props.
if INCLUDE_CSGO_PROPS then
  -- Bouyant props.
  addProp({
      Description = "Couch",
      Model = "models/props/cs_militia/couch.mdl",
      Group = FLOAT_PROPS,
      Price = 150,
      Health = 500,
      DonatorOnly = false
  })
  addProp({
      Description = "Fence Door",
      Model = "models/props/cs_militia/housefence_door.mdl",
      Group = FLOAT_PROPS,
      Price = 100,
      Health = 300,
      DonatorOnly = false
  })

  -- Armor props.
  addProp({
      Description = "Window",
      Model = "models/props/cs_militia/militiawindow01.mdl",
      Group = ARMOR_PROPS,
      Price = 30,
      Health = 250,
      DonatorOnly = false
  })

  -- Donator props.
  addProp({
      Description = "Pallet of Money",
      Model = "models/props/cs_assault/moneypallet.mdl",
      Group = DONATOR_PROPS,
      Price = 600,
      Health = 2000,
      DonatorOnly = true
  })
end


-- Add all weapons.
addWeapon({
    Name = "Crossbow",
    Model = "models/weapons/w_crossbow.mdl",
    Group = 1,
    Class = "weapon_crossbow",
    Price = 25000,
    Ammo = 1000,
    AmmoClass = "XBowBolt",
    Damage = 10,
    DonatorOnly = false
})
addWeapon({
    Name = "RPG",
    Model = "models/weapons/w_rocket_launcher.mdl",
    Group = 1,
    Class = "weapon_rpg",
    Price = 37500,
    Ammo = 3,
    AmmoClass = "RPG_Round",
    Damage = 50,
    DonatorOnly = false
})
addWeapon({
    Name = "357 Magnum",
    Model = "models/weapons/W_357.mdl",
    Group = 1,
    Class = "weapon_357",
    Price = 10000,
    Ammo = 1000,
    AmmoClass = "357",
    Damage = 4,
    DonatorOnly = false
})
addWeapon({
    Name = "Frag Grenade",
    Model = "models/weapons/w_grenade.mdl",
    Group = 1,
    Class = "weapon_frag",
    Price = 11250,
    Ammo = 3,
    AmmoClass = "Grenade",
    Damage = 15,
    DonatorOnly = false
})
addWeapon({
    Name = "Crowbar",
    Model = "models/weapons/w_crowbar.mdl",
    Group = 1,
    Class = "weapon_crowbar",
    Price = 5000,
    Ammo = 0,
    AmmoClass = "Pistol",
    Damage = 20,
    DonatorOnly = false
})
addWeapon({
    Name = "Shotgun",
    Model = "models/weapons/w_shotgun.mdl",
    Group = 1,
    Class = "weapon_shotgun",
    Price = 200000,
    Ammo = 100,
    AmmoClass = "Buckshot",
    Damage = 8,
    DonatorOnly = false
})
addWeapon({
    Name = "SLAM",
    Model = "models/weapons/w_slam.mdl",
    Group = 1,
    Class = "weapon_slam",
    Price = 12500,
    Ammo = 2,
    AmmoClass = "slam",
    Damage = 25,
    DonatorOnly = false
})
addWeapon({
    Name = "SMG",
    Model = "models/weapons/w_smg1.mdl",
    Group = 1,
    Class = "weapon_smg1",
    Price = 250000,
    Ammo = 500,
    AmmoClass = "SMG1",
    Damage = 2,
    DonatorOnly = false
})
addWeapon({
    Name = "AR2",
    Model = "models/weapons/w_irifle.mdl",
    Group = 1,
    Class = "weapon_ar2",
    Price = 750000,
    Ammo = 1000,
    AmmoClass = "AR2",
    Damage = 3,
    DonatorOnly = false
})
