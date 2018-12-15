PropCategories = {}
Props = {}
WeaponCategories = {}
Weapons = {}

local propCount = 0
local weaponCount = 0

--- Adds a prop to the prop list.
-- @param prop Table describing prop.
local function addProp(prop)
  -- TODO: See if table.insert can be used
  propCount = propCount + 1
  Props[propCount] = prop
end

--- Adds a weapon to the weapon list.
-- @param weapon Table describing weapon.
local function addWeapon(weapon)
  -- TODO: See if table.insert can be used
  weaponCount = weaponCount + 1
  Weapons[weaponCount] = weapon
end


-- Prop categories
PropCategories[1] = "Bouyant Props"
PropCategories[2] = "Armor Props"

-- Weapon categories
WeaponCategories[1] = "Basic Weapons"

-- Props
addProp({
    Description = "Wooden Table",
    Model = "models/props_c17/FurnitureTable002a.mdl",
    Group = 1,
    Price = 50,
    Health = 25,
    DonatorOnly = false
})
addProp({
    Description = "Wooden Bench",
    Model = "models/props_c17/bench01a.mdl",
    Group = 1,
    Price = 40,
    Health = 20,
    DonatorOnly = false
})
addProp({
    Description = "Wooden Shelf 1",
    Model = "models/props_c17/shelfunit01a.mdl",
    Group = 1,
    Price = 180,
    Health = 90,
    DonatorOnly = false
})
addProp({
    Description = "Wooden Shelf 2",
    Model = "models/props_c17/FurnitureShelf001a.mdl",
    Group = 1,
    Price = 200,
    Health = 100,
    DonatorOnly = false
})
addProp({
    Description = "Wooden Shelf 3",
    Model = "models/props_interiors/Furniture_shelf01a.mdl",
    Group = 1,
    Price = 450,
    Health = 225,
    DonatorOnly = false
})
addProp({
    Description = "Metal Door",
    Model = "models/props_doors/door03_slotted_left.mdl",
    Group = 1,
    Price = 250,
    Health = 125,
    DonatorOnly = false
})
addProp({
    Description = "Dock Pole 1",
    Model = "models/props_docks/dock01_pole01a_128.mdl",
    Group = 1,
    Price = 200,
    Health = 100,
    DonatorOnly = false
})
addProp({
    Description = "Dock Pole 2",
    Model = "models/props_docks/dock03_pole01a_256.mdl",
    Group = 1,
    Price = 400,
    Health = 200,
    DonatorOnly = false
})
addProp({
    Description = "Wooden Desk",
    Model = "models/props_interiors/Furniture_Desk01a.mdl",
    Group = 1,
    Price = 160,
    Health = 80,
    DonatorOnly = false
})
addProp({
    Description = "Vending Machine",
    Model = "models/props_interiors/VendingMachineSoda01a.mdl",
    Group = 1,
    Price = 1200,
    Health = 600,
    DonatorOnly = false
})
addProp({
    Description = "Vending Machine Door",
    Model = "models/props_interiors/VendingMachineSoda01a_door.mdl",
    Group = 1,
    Price = 600,
    Health = 300,
    DonatorOnly = false
})
addProp({
    Description = "Blue Barrel",
    Model = "models/props_borealis/bluebarrel001.mdl",
    Group = 1,
    Price = 50,
    Health = 25,
    DonatorOnly = false
})
addProp({
    Description = "Gravestone",
    Model = "models/props_c17/gravestone003a.mdl",
    Group = 2,
    Price = 160,
    Health = 80,
    DonatorOnly = false
})
addProp({
    Description = "Oil Drum",
    Model = "models/props_c17/oildrum001.mdl",
    Group = 2,
    Price = 60,
    Health = 30,
    DonatorOnly = false
})
addProp({
    Description = "Concrete Barrier",
    Model = "models/props_c17/concrete_barrier001a.mdl",
    Group = 2,
    Price = 150,
    Health = 75,
    DonatorOnly = false
})
addProp({
    Description = "Coffin Piece",
    Model = "models/props_c17/gravestone_coffinpiece002a.mdl",
    Group = 2,
    Price = 160,
    Health = 80,
    DonatorOnly = false
})
addProp({
    Description = "Display Case",
    Model = "models/props_c17/display_cooler01a.mdl",
    Group = 2,
    Price = 260,
    Health = 130,
    DonatorOnly = false
})
addProp({
    Description = "Red Couch",
    Model = "models/props_c17/FurnitureCouch001a.mdl",
    Group = 2,
    Price = 400,
    Health = 200,
    DonatorOnly = false
})
addProp({
    Description = "Metal Locker",
    Model = "models/props_c17/Lockers001a.mdl",
    Group = 2,
    Price = 700,
    Health = 350,
    DonatorOnly = false
})
addProp({
    Description = "Metal Panel",
    Model = "models/props_debris/metal_panel01a.mdl",
    Group = 2,
    Price = 200,
    Health = 100,
    DonatorOnly = false
})
addProp({
    Description = "Small Metal Panel",
    Model = "models/props_debris/metal_panel02a.mdl",
    Group = 2,
    Price = 100,
    Health = 50,
    DonatorOnly = false
})
addProp({
    Description = "Gas Canister",
    Model = "models/props_c17/canister01a.mdl",
    Group = 2,
    Price = 100,
    Health = 50,
    DonatorOnly = false
})
addProp({
    Description = "Large Gas Canister",
    Model = "models/props_c17/canister_propane01a.mdl",
    Group = 2,
    Price = 150,
    Health = 75,
    DonatorOnly = false
})
addProp({
    Description = "Bathtub",
    Model = "models/props_interiors/BathTub01a.mdl",
    Group = 2,
    Price = 800,
    Health = 400,
    DonatorOnly = false
})
addProp({
    Description = "Refrigerator",
    Model = "models/props_interiors/refrigerator01a.mdl",
    Group = 2,
    Price = 600,
    Health = 300,
    DonatorOnly = false
})
addProp({
    Description = "Refrigerator Door",
    Model = "models/props_interiors/refrigeratorDoor01a.mdl",
    Group = 2,
    Price = 300,
    Health = 150,
    DonatorOnly = false
})
addProp({
    Description = "Metal Bars",
    Model = "models/props_building_details/Storefront_Template001a_Bars.mdl",
    Group = 2,
    Price = 220,
    Health = 110,
    DonatorOnly = false
})

-- Weapons
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
