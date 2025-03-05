--[[

	Manage localized strings

]]

function SC_Localization_enUS()
	STATCOMPARE_TUTORIAL_INTRO = [[
See your character info in one place.

Compare yourself to your target.

The icons above toggle what's shown:]]

	STATCOMPARE_TUTORIAL_SPELLBOOK_ICON=[["Spellbook" icon shows avg attack and crit values]]
end

-- English localized variables (default)
SC_Localization_enUS()

-- Override default values if able to
local localization_loader = getglobal("SC_Localization_"..GetLocale())
if( localization_loader ) then 
	localization_loader()
	localization_loader = nil
end
