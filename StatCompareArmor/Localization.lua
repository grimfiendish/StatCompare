--[[

	Manage localized strings

]]

function SC_Localization_enUS()
	STATCOMPARE_TUTORIAL_ARMOR_ICON=[["Armor" icon shows equipped items/enchants]]
end

-- English localized variables (default)
SC_Localization_enUS()

-- Override default values if able to
local localization_loader = getglobal("SC_Localization_"..GetLocale())
if( localization_loader ) then 
	localization_loader()
	localization_loader = nil
end
