--[[

	Manage localized strings

]]

function SC_Localization_enUS()
	STATCOMPARE_TUTORIAL_ARMOR_ICON=[["Armor" icon shows equipped items/enchants]]

	STATCOMPARE_UNITSLOT = {}
	STATCOMPARE_UNITSLOT[ 1] = "Helm"
	STATCOMPARE_UNITSLOT[ 2] = "Neck"
	STATCOMPARE_UNITSLOT[ 3] = "Mantle"
	STATCOMPARE_UNITSLOT[ 4] = "Shirt" --?
	STATCOMPARE_UNITSLOT[ 5] = "Chest"
	STATCOMPARE_UNITSLOT[ 6] = "Belt"
	STATCOMPARE_UNITSLOT[ 7] = "Leg"
	STATCOMPARE_UNITSLOT[ 8] = "Feet"
	STATCOMPARE_UNITSLOT[ 9] = "Wrist"
	STATCOMPARE_UNITSLOT[10] = "Gloves"
	STATCOMPARE_UNITSLOT[11] = "Finger" -- Top ring
	STATCOMPARE_UNITSLOT[12] = "Finger" -- Bottom ring
	STATCOMPARE_UNITSLOT[13] = "Trinket" -- Top trinket
	STATCOMPARE_UNITSLOT[14] = "Trinket" -- Bottom trinket
	STATCOMPARE_UNITSLOT[15] = "Cloak"
	STATCOMPARE_UNITSLOT[16] = "Mainhand"
	STATCOMPARE_UNITSLOT[17] = "Offhand"
	STATCOMPARE_UNITSLOT[18] = "Ranged"
	STATCOMPARE_UNITSLOT[19] = "Tabard"
end

-- English localized variables (default)
SC_Localization_enUS()

-- Override default values if able to
local localization_loader = getglobal("SC_Localization_"..GetLocale())
if( localization_loader ) then 
	localization_loader()
	localization_loader = nil
end
