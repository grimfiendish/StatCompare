--[[

	Manage localized strings

]]

function SC_Localization_enUS()
	STATCOMPARE_TUTORIAL_SPELLBOOK_ICON=[["Spellbook" icon shows avg attack and crit values]]
	STATCOMPARE_TWOW_MOD=" (TWoW)" -- Used to call out that a spell stat has been modified by TurtleWoW.
end

-- English localized variables (default)
SC_Localization_enUS()

-- Override default values if able to
local localization_loader = getglobal("SC_Localization_"..GetLocale())
if( localization_loader ) then 
	localization_loader()
	localization_loader = nil
end
