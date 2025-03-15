--
--  $Id: slashboy @ DreamLand 九藜方舟 & lasthime @ 艾森纳 幻物梵天
--  $ver: v1.8.005
--  $Date: 2025-01-25 18:00:00
--  &Note: Thanks for crowley@headshot.de , the author of Titan Plugin - Item Bonuses.
--

StatCompareSelfFrameShowSpells = false;
StatCompareTargetFrameShowSpells = false;
StatCompare_ItemCollection = {};
StatCompare_ItemCache = {};
StatCompare_bonuses_single = {};
StatCompare_IsDebugMode = false;

--STATCOMPARE_SETNAME_PATTERN = "^(.*)%d/%d.*$";
STATCOMPARE_SETNAME_PATTERN = "^(.*)%d/(%d).*$";

STATCOMPARE_PREFIX_PATTERN = "^%+(%d+)%%?(.*)$";
STATCOMPARE_SUFFIX_PATTERN = "^(.*)%+(%d+)%%?$";

STATCOMPARE_ITEMLINK_PATTERN = "|cff(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r";
STATCOMPARE_DISPLAY_GROUPS = { "EquippedItems", "EquippedEnchants", "ActiveBuffs", "BasicStats", "TalentSpec", "SpellPowerStats" }
STATCOMPARE_TEXT_INDENT1 = "    "
STATCOMPARE_TEXT_INDENT2 = "        "
StatCompre_ColorList = {
	X = 'FFD200',  -- attributes
	Y = '20FF20',  -- skills
	M = 'FFFFFF',  -- melee
	R = '00C0C0',  -- ranged
	C = 'FFFF00',  -- spells
	A = 'FF60FF',  -- arcane
	I = 'FF3600',  -- fire
	F = '00C0FF',  -- frost
	H = 'FFA400',  -- holy
	N = '00FF60',  -- nature
	S = 'AA12AC',  -- shadow
	L = '20FF20',  -- life
	P = '6060FF',  -- mana
};

STATCOMPARE_SELFSTAT = {};

STATCOMPARE_EFFECTS = {
	{ effect = "STR",		name = STATCOMPARE_STR,	 		format = "+%d",	lformat = "%d",		short = "XSTR",	cat = "ATT",	opt="ShowSTR" },
	{ effect = "AGI",		name = STATCOMPARE_AGI, 			format = "+%d",	lformat = "%d",		short = "XAGI",	cat = "ATT",	opt="ShowAGI" },
	{ effect = "STA",		name = STATCOMPARE_STA, 			format = "+%d",	lformat = "%d",		short = "XSTA",	cat = "ATT",	opt="ShowSTA" },
	{ effect = "INT",		name = STATCOMPARE_INT, 			format = "+%d",	lformat = "%d",		short = "XINT",	cat = "ATT",	opt="ShowINT" },
	{ effect = "SPI",		name = STATCOMPARE_SPI,	 		format = "+%d",	lformat = "%d",		short = "XSPI",	cat = "ATT",	opt="ShowSPI" },
	{ effect = "ARMOR",		name = STATCOMPARE_ARMOR,	 		format = "+%d",	lformat = "%d",		show = 1,	short = "XARM",	cat = "ATT",	opt="ShowArmor" },
	{ effect = "ENARMOR",		name = STATCOMPARE_ENARMOR,	 		format = "+%d",	lformat = "%d",	show = 0,		short = "EARM",	cat = "ATT",	opt="ShowEnArmor" },
	{ effect = "DAMAGEREDUCE",	name = STATCOMPARE_DAMAGEREDUCE,	format = "+%d%%",	lformat = "%.2f%%",	show = 1,	short = "DR",	cat = "ATT",	opt="ShowDR" },

	{ effect = "VAMPIRISM",		name = STATCOMPARE_VAMPIRISM,		format = "+%d%%",	lformat = "%.2f%%",	show = 1,	short = "",	cat = "MISC",	opt="ShowVampirism" },
	{ effect = "HASTE",			name = STATCOMPARE_SPEED,			format = "+%d%%",	lformat = "%.2f%%",	show = 1,	short = "",	cat = "MISC",	opt="ShowHaste" },
	{ effect = "ARMORPEN",		name = STATCOMPARE_ARMORPEN,		format = "+%d",		lformat = "%d",		show = 1,	short = "",	cat = "MISC",	opt="ShowArmorPen" },
	
	{ effect = "ARCANERES",		name = STATCOMPARE_ARCANERES,		format = "+%d",	lformat = "%d",		short = "AR",	cat = "RES",	opt="ShowArcaneRes" },
	{ effect = "FIRERES",		name = STATCOMPARE_FIRERES, 		format = "+%d",	lformat = "%d",		short = "IR",	cat = "RES",	opt="ShowFireRes" },
	{ effect = "NATURERES", 	name = STATCOMPARE_NATURERES, 		format = "+%d",	lformat = "%d",		short = "NR",	cat = "RES",	opt="ShowNatureRes" },
	{ effect = "FROSTRES",		name = STATCOMPARE_FROSTRES, 		format = "+%d",	lformat = "%d",		short = "FR",	cat = "RES",	opt="ShowFrostRes" },
	{ effect = "SHADOWRES",		name = STATCOMPARE_SHADOWRES,		format = "+%d",	lformat = "%d",		short = "SR",	cat = "RES",	opt="ShowShadowRes" },
	{ effect = "DETARRES",		name = STATCOMPARE_DETARRES,		format = "-%d",	lformat = "%d",		short = "XR",	cat = "RES",	opt="ShowDetarRes" },
	{ effect = "ALLRES",		name = STATCOMPARE_ALLRES,		format = "+%d",	short="AR",		cat = "RES",	show = 0},

	{ effect = "DEFENSE",		name = STATCOMPARE_DEFENSE, 		format = "+%d",	lformat = "%d",		short = "YDEF",	cat = "SKILL",	opt="ShowDefense" },
	{ effect = "STEALTH",		name = STATCOMPARE_STEALTH,		format = "+%d", lformat = "%d",		short = "YDEF", cat = "SKILL"},
	{ effect = "MINING",		name = STATCOMPARE_MINING,		format = "+%d",		short = "YMIN",	cat = "SKILL",	opt="ShowMining" },
	{ effect = "HERBALISM",		name = STATCOMPARE_HERBALISM, 		format = "+%d",		short = "YHER",	cat = "SKILL",	opt="ShowHerbalism" },
	{ effect = "SKINNING", 		name = STATCOMPARE_SKINNING, 		format = "+%d",		short = "YSKI",	cat = "SKILL",	opt="ShowSkinning" },
	{ effect = "FISHING",		name = STATCOMPARE_FISHING,		format = "+%d",		short = "YFIS",	cat = "SKILL",	opt="ShowFishing" },
	{ effect = "SWIMMING",		name = STATCOMPARE_SWIMMING,		format = "+%d%%",	short = "SWI",	cat = "SKILL",	opt="ShowSwimming" },

	{ effect = "ATTACKPOWER",	name = STATCOMPARE_ATTACKPOWER, 		format = "+%d",	lformat = "%d",		show = 1,	short = "MA",	cat = "BON",	opt="ShowAP" },
	{ effect = "BEARAP",		name = STATCOMPARE_DRUID_BEAR,		format = "+%d", lformat = "%d",		short = "MA",	cat = "BON",	opt="ShowAP" },
	{ effect = "CATAP",		name = STATCOMPARE_DRUID_CAT,		format = "+%d", lformat = "%d",		short = "MA",	cat = "BON",	opt="ShowAP" },
	{ effect = "ATTACKPOWERUNDEAD",	name = STATCOMPARE_ATTACKPOWERUNDEAD, 		format = "+%d",	lformat = "%d",		show = 1,	short = "MA",	cat = "BON",	opt="ShowAP" },
	{ effect = "CRIT",		name = STATCOMPARE_CRIT, 			format = "+%d%%",	lformat = "%.2f%%",	show = 1,	short = "MC",	cat = "BON",	opt="ShowCrit" },
	{ effect = "BLOCK",		name = STATCOMPARE_BLOCK, 		format = "+%d",	lformat = "%d",	short = "MB",	show = 1,	cat = "BON",	opt="ShowBlock" },
	{ effect = "TOBLOCK",		name = STATCOMPARE_TOBLOCK, 		format = "+%d%%",	lformat = "%.2f%%",	short = "MB",	cat = "BON",	opt="ShowToBlock" },
	{ effect = "DODGE",		name = STATCOMPARE_DODGE, 		format = "+%d%%",	lformat = "%.2f%%",	show = 1,	short = "MD",	cat = "BON",	opt="ShowDodge" },
	{ effect = "PARRY", 		name = STATCOMPARE_PARRY, 		format = "+%d%%",	lformat = "%.2f%%",	short = "MP",	cat = "BON",	opt="ShowParry" },
	{ effect = "TOHIT", 		name = STATCOMPARE_TOHIT, 		format = "+%d%%",	lformat = "%.2f%%",	short = "MH",	cat = "BON",	opt="ShowToHit" },
	{ effect = "RANGEDATTACKPOWER", name = STATCOMPARE_RANGEDATTACKPOWER,	format = "+%d",	lformat = "%d",		show = 1,	short = "RA",	cat = "BON",	opt="ShowRAP" },
	{ effect = "RANGEDCRIT",	name = STATCOMPARE_RANGEDCRIT,		format = "+%d%%",	lformat = "%.2f%%",	show = 1,	short = "RC",	cat = "BON",	opt="ShowRCrit" },
--TODO	{ effect = "RANGEDHIT",	name = STATCOMPARE_RANGEDHIT,		format = "+%d%%",	lformat = "%.2f%%",	show = 1,	short = "RH",	cat = "BON",	opt="ShowRHit" },

	{ effect = "DMG",		name = STATCOMPARE_DMG, 			format = "+%d",		short = "CD",	cat = "SBON" },
	{ effect = "DMGUNDEAD",		name = STATCOMPARE_DMGUNDEAD, 			format = "+%d",		short = "CD",	cat = "SBON" },
	{ effect = "HEAL",		name = STATCOMPARE_HEAL, 			format = "+%d",		short = "CH",	cat = "SBON"},
	{ effect = "FLASHHOLYLIGHTHEAL",		name = STATCOMPARE_FLASHHOLYLIGHT_HEAL, 			format = "+%d",		short = "CH",	cat = "SBON"},
	{ effect = "LESSERHEALWAVE",	name = STATCOMPARE_LESSER_HEALING_WAVE_HEAL, 			format = "+%d",		short = "CH",	cat = "SBON"},
	{ effect = "CHAINLIGHTNING",	name = STATCOMPARE_CHAIN_LIGHTNING_DAM, 			format = "+%d",		short = "ND",	cat = "SBON"},
	{ effect = "EARTHSHOCK",	name = STATCOMPARE_EARTH_SHOCK_DAM, 			format = "+%d",		short = "ND",	cat = "SBON"},
	{ effect = "FLAMESHOCK",	name = STATCOMPARE_FLAME_SHOCK_DAM, 			format = "+%d",		short = "ID",	cat = "SBON"},
	{ effect = "FROSTSHOCK",	name = STATCOMPARE_FROST_SHOCK_DAM, 			format = "+%d",		short = "FD",	cat = "SBON"},
	{ effect = "LIGHTNINGBOLT",	name = STATCOMPARE_LIGHTNING_BOLT_DAM, 			format = "+%d",		short = "ND",	cat = "SBON"},
	{ effect = "NATURECRIT", 		name = STATCOMPARE_NATURECRIT,		format = "+%d%%",	lformat = "%.2f%%",	short = "CNC",	cat = "SBON" },
	{ effect = "HOLYCRIT", 		name = STATCOMPARE_HOLYCRIT,		format = "+%d%%",	lformat = "%.2f%%",	short = "CHC",	cat = "SBON" },
	{ effect = "SPELLCRIT", 	name = STATCOMPARE_SPELLCRIT,		format = "+%d%%",	lformat = "%.2f%%",	short = "CSC",	cat = "SBON" },
	{ effect = "SPELLTOHIT", 	name = STATCOMPARE_SPELLTOHIT,		format = "+%d%%",	lformat = "%.2f%%",	short = "CSH",	cat = "SBON" },
	{ effect = "ARCANEDMG", 	name = STATCOMPARE_ARCANEDMG, 		format = "+%d",		short = "AD",	cat = "SBON" },
	{ effect = "FIREDMG", 		name = STATCOMPARE_FIREDMG, 		format = "+%d",		short = "ID",	cat = "SBON" },
	{ effect = "FROSTDMG",		name = STATCOMPARE_FROSTDMG, 		format = "+%d",		short = "FD",	cat = "SBON" },
	{ effect = "HOLYDMG",		name = STATCOMPARE_HOLYDMG, 		format = "+%d",		short = "HD",	cat = "SBON" },
	{ effect = "NATUREDMG",		name = STATCOMPARE_NATUREDMG, 		format = "+%d",		short = "ND",	cat = "SBON" },
	{ effect = "SHADOWDMG",		name = STATCOMPARE_SHADOWDMG, 		format = "+%d",		short = "SD",	cat = "SBON" },

	{ effect = "HEALTH",		name = STATCOMPARE_HEALTH,		format = "+%d",	lformat = "%d",		show = 1,	short = "LP",	cat = "OBON",	opt="ShowHealth" },
	{ effect = "HEALTHREG",		name = STATCOMPARE_HEALTHREG,		format = "%d HP/5s",	short = "LR",	cat = "OBON",	opt="ShowHealthRegen" },
	{ effect = "MANA",		name = STATCOMPARE_MANA, 			format = "+%d",	lformat = "%d",	show = 1,	short = "PP",	cat = "OBON",	opt="ShowMana" },
	{ effect = "MANAREG",		name = STATCOMPARE_MANAREG, 		format = "%d",	lformat = "%d", short = "PR",	cat = "OBON",	opt="ShowManaRegen" },
	{ effect = "MANAREGSPI",	name = STATCOMPARE_MANAREGSPI, 		format = "%d MP/2s",	lformat = "%d MP/2s",	show = 1,	short = "PR",	cat = "OBON",	opt="ShowManaRegenSPI" },

	{ effect = "MANAREGCOMBAT",	name = STATCOMPARE_MANAREG,		format = "+%d%%",	show = 0, short = "PR", cat = "OBON"},
};

STATCOMPARE_CATEGORIES = {'ATT', 'MISC', 'BON', 'SBON', 'RES', 'SKILL', 'OBON'};

if StatCompare_TutorialIconExplanation then
	StatCompare_TutorialIconExplanation["Interface\\Icons\\INV_Misc_Note_01"] = STATCOMPARE_TUTORIAL_NOTE_ICON
end

local function nvl(value, default)
    return value ~= nil and value or default
end
local function nvls(value, default)
    return value ~= nil and tostring(value) or default or ""
end
local function nvld(value, default)
    return value ~= nil and tonumber(value) or default or 0
end

function StatCompare_GetDisplayGroupSetting(bSelfStat, setting)
	-- Display Group is the visual groups you see in the pane, like "Stats", "Equipped Items" etc.
	local valid = false
	for _, grp in ipairs(STATCOMPARE_DISPLAY_GROUPS) do if grp == setting then valid = true; end; end
	local settingName = "Show"..(bSelfStat == 1 and "Player" or "Target")..setting
	if valid and StatCompare_GetSetting(settingName) == 1 then return true; else return false; end
end

function StatCompare_SetDisplayGroupSetting(bSelfStat, setting, val)
	-- Display Group is the visual groups you see in the pane, like "Stats", "Equipped Items" etc.
	local valid = false
	for _, grp in ipairs(STATCOMPARE_DISPLAY_GROUPS) do if grp == setting then valid = true; end; end
	if valid then
		local ival = (val == true or val == 1) and 1 or 0 -- exisitng settings store 1/0...
	local settingName = "Show"..(bSelfStat == 1 and "Player" or "Target")..setting
		StatCompare_SetSetting(settingName, ival)
	end
end

function StatCompare_OnLoad()
	InspectFrame_LoadUI();

	-- hook
	StatCompare_SetupHook(StatCompare_enable);
	--
	StatCompare_Register(StatCompare_enable);

	UnitPopupButtons["INSPECT"] = { text = TEXT(INSPECT), dist = 0 };

  	SlashCmdList["StatCompare"] = STATCOMPARE_SlashCmdHandler;
  	SLASH_StatCompare1 = "/statc";

	DEFAULT_CHAT_FRAME:AddMessage("StatCompare loaded. "..GREEN_FONT_COLOR_CODE.."作者：slashboy @ DreamLand 九藜方舟 "..FONT_COLOR_CODE_CLOSE);
	DEFAULT_CHAT_FRAME:AddMessage("增强版 - "..GREEN_FONT_COLOR_CODE.."作者：lasthime @ 艾森纳 幻物梵天 "..FONT_COLOR_CODE_CLOSE);


	STATCOMPARE_SELFSTAT["STR"]=1;
	STATCOMPARE_SELFSTAT["AGI"]=2;
	STATCOMPARE_SELFSTAT["STA"]=3;
	STATCOMPARE_SELFSTAT["INT"]=4;
	STATCOMPARE_SELFSTAT["SPI"]=5;

end

function StatCompare_SetupHook(enable)
	StatCompare_SetupDressHook();
	StatCompare_SetupItemLinkHook();
	if (enable == 1) then
		if ((PaperDollFrame_OnShow ~=SCPaperDollFrame_OnShow) and (oldPaperDollFrame_OnShow ==nil)) then
			oldPaperDollFrame_OnShow =  PaperDollFrame_OnShow;
			PaperDollFrame_OnShow = SCPaperDollFrame_OnShow;
		end
		if ((PaperDollFrame_OnHide ~=SCPaperDollFrame_OnHide) and (oldPaperDollFrame_OnHide ==nil)) then
			oldPaperDollFrame_OnHide =  PaperDollFrame_OnHide;
			PaperDollFrame_OnHide = SCPaperDollFrame_OnHide;
		end
		if ((InspectFrame_Show ~=SCInspectFrame_Show) and (oldInspectFrame_Show ==nil)) then
			oldInspectFrame_Show =  InspectFrame_Show;
			InspectFrame_Show = SCInspectFrame_Show;
		end
		if ((InspectFrame_OnHide ~=SCInspectFrame_OnHide) and (oldInspectFrame_OnHide ==nil)) then
			oldInspectFrame_OnHide =  InspectFrame_OnHide;
			InspectFrame_OnHide = SCInspectFrame_OnHide;
		end
	else
		-- Unhook the function

		if (PaperDollFrame_OnShow == SCPaperDollFrame_OnShow) then
			PaperDollFrame_OnShow = oldPaperDollFrame_OnShow;
			oldPaperDollFrame_OnShow = nil;
		end
		if (PaperDollFrame_OnHide == SCPaperDollFrame_OnHide) then
			PaperDollFrame_OnHide = oldPaperDollFrame_OnHide;
			oldPaperDollFrame_OnHide = nil;
		end
		if (InspectFrame_Show == SCInspectFrame_Show) then
			InspectFrame_Show = oldInspectFrame_Show;
			oldInspectFrame_Show = nil;
		end
		if (InspectFrame_OnHide == SCInspectFrame_OnHide) then
			InspectFrame_OnHide = oldInspectFrame_OnHide;
			oldInspectFrame_OnHide = nil;
		end
	end
	-- 支持Inpector的处理
	if(InspectorFrame) then
		if (enable == 1) then
			if ((InspectorFrameShow ~=SCInspectorFrameShow) and (oldInspectorFrameShow ==nil)) then
				oldInspectorFrameShow =  InspectorFrameShow;
				InspectorFrameShow = SCInspectorFrameShow;
			end
			if ((InspectorFrameHide ~=SCInspectorFrameHide) and (oldInspectorFrameHide ==nil)) then
				oldInspectorFrameHide =  InspectorFrameHide;
				InspectorFrameHide = SCInspectorFrameHide;
			end
		else
			if (InspectorFrameShow == SCInspectorFrameShow) then
				InspectorFrameShow = oldInspectorFrameShow;
				oldInspectorFrameShow = nil;
			end
			if (InspectorFrameHide == SCInspectorFrameHide) then
				InspectorFrameHide = oldInspectorFrameHide;
				oldInspectorFrameHide = nil;
			end
		end
	end
	-- 支持GoodInpector的处理
	if(GoodInspectFrame) then
		if (enable == 1) then
			if ((GoodInspect_InspectFrame_Show ~=SCGoodInspect_InspectFrame_Show) and (oldGoodInspect_InspectFrame_Show ==nil)) then
				oldGoodInspect_InspectFrame_Show =  GoodInspect_InspectFrame_Show;
				GoodInspect_InspectFrame_Show = SCGoodInspect_InspectFrame_Show;
			end
		else
			if (GoodInspect_InspectFrame_Show == SCGoodInspect_InspectFrame_Show) then
				GoodInspect_InspectFrame_Show = oldGoodInspect_InspectFrame_Show;
				oldGoodInspect_InspectFrame_Show = nil;
			end
		end
	end
	-- 支持SuperInspect的处理
	if(SuperInspectFrame) then
		if (enable == 1) then
			if ((SuperInspect_InspectFrame_Show ~=SCSuperInspect_InspectFrame_Show) and (scoldSuperInspect_InspectFrame_Show ==nil)) then
				scoldSuperInspect_InspectFrame_Show =  SuperInspect_InspectFrame_Show;
				SuperInspect_InspectFrame_Show = SCSuperInspect_InspectFrame_Show;
			end
			if ((ClearInspectPlayer ~=SCClearInspectPlayer) and (scoldClearInspectPlayer ==nil)) then
				scoldClearInspectPlayer =  ClearInspectPlayer;
				ClearInspectPlayer = SCClearInspectPlayer;
			end
		else
			if (SuperInspect_InspectFrame_Show == SCSuperInspect_InspectFrame_Show) then
				SuperInspect_InspectFrame_Show = scoldSuperInspect_InspectFrame_Show;
				scoldSuperInspect_InspectFrame_Show = nil;
			end
			if (ClearInspectPlayer == SCClearInspectPlayer) then
				ClearInspectPlayer = scoldClearInspectPlayer;
				scoldClearInspectPlayer = nil;
			end
		end
	end

end

function StatCompare_SetupDressHook()
	if(StatCompare_IsDressUpStat==1 and StatCompare_enable==1) then
		if ((DressUpItemLink ~=SCDressUpItemLink) and (oldDressUpItemLink ==nil)) then
			oldDressUpItemLink =  DressUpItemLink;
			DressUpItemLink = SCDressUpItemLink;
		end
		if ((HideUIPanel ~=SCHideUIPanel) and (oldHideUIPanel ==nil)) then
			oldHideUIPanel =  HideUIPanel;
			HideUIPanel = SCHideUIPanel;
		end
	else -- unhook
		if (DressUpItemLink == SCDressUpItemLink) then
			DressUpItemLink = oldDressUpItemLink;
			oldDressUpItemLink = nil;
		end
		if (HideUIPanel == SCHideUIPanel) then
			HideUIPanel = oldHideUIPanel;
			oldHideUIPanel = nil;
		end
	end

end

function StatCompare_Register(register)
	if (register == 1) then
		this:RegisterEvent("PLAYER_ENTERING_WORLD");
		this:RegisterEvent("UNIT_INVENTORY_CHANGED");
		this:RegisterEvent("PLAYER_LOGOUT");
		this:RegisterEvent("PLAYER_ENTERING_WORLD");
		this:RegisterEvent("UNIT_NAME_UPDATE");
	else
		this:UnregisterEvent("PLAYER_ENTERING_WORLD");
		this:UnregisterEvent("UNIT_INVENTORY_CHANGED");
		this:UnregisterEvent("PLAYER_LOGOUT");
		this:UnregisterEvent("PLAYER_ENTERING_WORLD");
		this:UnregisterEvent("UNIT_NAME_UPDATE");
	end
end

function STATCOMPARE_SlashCmdHandler(msg)
	local GREEN = GREEN_FONT_COLOR_CODE;
	local CLOSE = FONT_COLOR_CODE_CLOSE;
	local NORMAL = NORMAL_FONT_COLOR_CODE;

	if ( (not msg) or (strlen(msg) <= 0 ) or (msg == "help") ) then
		DEFAULT_CHAT_FRAME:AddMessage(NORMAL.."StatCompare "..STATCOMPARE_CFG_USAGE..": "..CLOSE);
		DEFAULT_CHAT_FRAME:AddMessage(GREEN.." /statc help    "..CLOSE.." - ".. STATCOMPARE_CFG_HELP);
		DEFAULT_CHAT_FRAME:AddMessage(GREEN.." /statc item    "..CLOSE.." - ".. STATCOMPARE_CFG_OPEN_ITEM_CONFIG);
		DEFAULT_CHAT_FRAME:AddMessage(GREEN.." /statc on | off"..CLOSE.." - ".. STATCOMPARE_CFG_ON_OFF_ADDON);
		DEFAULT_CHAT_FRAME:AddMessage(GREEN.." /statc debug on | off"..CLOSE.." - ".. STATCOMPARE_CFG_TOGGLE_DEBUG);
		if(StatCompareOptFrame) then
			DEFAULT_CHAT_FRAME:AddMessage(GREEN.." /statc config  "..CLOSE.." - "..STATCOMPARE_CFG_SHOW_OPTIONS_WINDOW);
		end
		if(StatCompareSetsFrame) then
			DEFAULT_CHAT_FRAME:AddMessage(GREEN.." /statc sets  "..CLOSE.." - "..STATCOMPARE_CFG_SHOW_SETS_WINDOW);
		end
	elseif (msg == "sets") then
		if(StatCompareSetsFrame) then
			StatCompareSetsFrame:Show();
		else
			DEFAULT_CHAT_FRAME:AddMessage(NORMAL.."Need load StatCompareSets plugin first."..CLOSE);
		end
	elseif (msg == "config") then
		if(StatCompareOptFrame) then
			StatCompare_Toggle();
		else
			DEFAULT_CHAT_FRAME:AddMessage(NORMAL.."Need load StatCompareUI plugin first."..CLOSE);
		end
	elseif (msg == "debug on") then
		StatCompare_IsDebugMode = true
			DEFAULT_CHAT_FRAME:AddMessage(GREEN.." StatCompare  "..CLOSE.." Debugging enabled");
	elseif (msg == "debug off") then
		StatCompare_IsDebugMode = false
			DEFAULT_CHAT_FRAME:AddMessage(GREEN.." StatCompare  "..CLOSE.." Debugging disabled");
	elseif (msg == "on") then
		StatCompare_Register(1);
		StatCompare_SetupHook(1);
		StatCompare_SaveVar["enable"]=1;
		StatCompare_enable=1;
		DEFAULT_CHAT_FRAME:AddMessage("StatCompare "..GREEN..STATCOMPARE_MSG_ADDON_ENABLED..CLOSE);
	elseif (msg == "off") then
		StatCompare_Register(0);
		StatCompare_SetupHook(0);
		StatCompare_SaveVar["enable"]=0;
		StatCompare_enable=0;
		DEFAULT_CHAT_FRAME:AddMessage("StatCompare "..GREEN..STATCOMPARE_MSG_ADDON_DISABLED..CLOSE);
	elseif (msg == "DressOn") then
		StatCompare_IsDressUpStat=1;
		StatCompare_SaveVar["IsDressUpStat"]=1;
		StatCompare_SetupDressHook();
		DEFAULT_CHAT_FRAME:AddMessage("StatCompare "..GREEN..STATCOMPARE_MSG_FITTING_ROOM_ENABLED..CLOSE);
	elseif (msg == "DressOff") then
		StatCompare_IsDressUpStat=0;
		StatCompare_SaveVar["IsDressUpStat"]=0;
		StatCompare_SetupDressHook();
		DEFAULT_CHAT_FRAME:AddMessage("StatCompare "..GREEN..STATCOMPARE_MSG_FITTING_ROOM_DISABLED..CLOSE);
	elseif (msg == "item") then
		StatCompare_ItemCollectionFrame:Show();
	else
		DEFAULT_CHAT_FRAME:AddMessage(STATCOMPARE_MSG_UNKNOWN_COMMAND..": "..GREEN..msg..CLOSE..
					      ", "..STATCOMPARE_MSG_TRY..GREEN.." /statc help"..CLOSE);
	end
end

local StatCompare_isLoaded=0
function StatCompare_OnEvent()
	if( event == "VARIABLES_LOADED" ) then
		if( not StatCompare_SaveVar ) then
			StatCompare_SaveVar = { };
			StatCompare_SaveVar["enable"]=1;
			StatCompare_SaveVar["IsDressUpStat"]=0;
			StatCompare_SaveVar["ItemCollection"]={};
		end
		StatCompare_enable = StatCompare_SaveVar["enable"];
		StatCompare_IsDressUpStat = StatCompare_SaveVar["IsDressUpStat"];
		if (not StatCompare_SaveVar["ItemCollection"]) then
			StatCompare_SaveVar["ItemCollection"]={};
		end
		StatCompare_ItemCollection = StatCompare_SaveVar["ItemCollection"];
		StatCompare_BuildItemCache();
		StatCompare_OnLoad();
		if(StatCompareOptFrame and StatCompareOptFrame:IsVisible()) then
			StatCompareOptFrame:Hide();
		end
	end

	if ((event == "PLAYER_ENTERING_WORLD" or event=="UNIT_NAME_UPDATE") and StatCompare_enable) then
		if(StatCompare_isLoaded ~= 1) then
			StatCompare_InitConfig();
		end
		if (not StatCompare_CharStats_Scan) then
			-- in 2006 i think dude made a separate addon but changed the base addon to make it work.
			-- So there's this spell book that does nothing but is always visible.
			-- I can't find the addon online but it surely exists somewhere,
			-- so I haven't removed the code but.. now it'll only show when it's abble to be useful.
			StatCompareSelfFrameSpellsButton:Hide()
			StatCompareTargetFrameSpellsButton:Hide()
		end
		local showIcon = StatCompare_GetSetting("ShowMinimapIcon");
		if(showIcon == 0 and StatCompareMinimapFrame and StatCompareMinimapFrame:IsVisible()) then
			StatCompareMinimapFrame:Hide();
		elseif(showIcon == 1 and StatCompareMinimapFrame and not StatCompareMinimapFrame:IsVisible()) then
			StatCompareMinimapFrame:Show();
			StatCompareMinimapButton_UpdatePosition()
		end
		StatCompare_isLoaded=1;
	end
	if ( (event == "UNIT_INVENTORY_CHANGED") and StatCompare_enable and StatCompare_isLoaded==1) then
		if ((arg1 == "player") and StatCompareSelfFrame:IsVisible()) then
			SCHideFrame(StatCompareSelfFrame);
			local tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,1);
			if (StatCompareTargetFrame:IsVisible()) then
				SCShowFrame(StatCompareSelfFrame,StatCompareTargetFrame,UnitName("player"),tiptext,0,0);
			else
				SCShowFrame(StatCompareSelfFrame,PaperDollFrame,UnitName("player"),tiptext,-30,-12);
			end
		elseif ((arg1 == "target") and StatCompare_enable and StatCompare_isLoaded==1 and StatCompareTargetFrame:IsVisible()) then
			SCHideFrame(StatCompareTargetFrame);
			local tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,0);
			SCShowFrame(StatCompareTargetFrame,InspectFrame,UnitName("target"),tiptext,-5,-12);

			tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,1);
			SCShowFrame(StatCompareSelfFrame,StatCompareTargetFrame,UnitName("player"),tiptext,0,0);
		end
	elseif ( event == "PLAYER_LOGOUT" ) then
		-- save the player settings
		StatCompare_SaveConfigInfo();
	end
end

function SCDressUpItemLink(link)
	local item = gsub(link, ".*(item:%d+:%d+:%d+:%d+).*", "%1", 1);
	StatScanner_Scan(item);
	StatCompare_bonuses_single = StatScanner_bonuses;
	local tiptext = StatCompare_GetTooltipText(StatCompare_bonuses_single,0);
	SCShowFrame(StatCompareItemStatFrame,SCItemTooltip,"",tiptext,0,0);

	StatScanner_bonuses = {};

	oldDressUpItemLink(link);
end

function SCPaperDollFrame_OnShow()
	local tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,1);
	SCShowFrame(StatCompareSelfFrame,PaperDollFrame,UnitName("player"),tiptext,-30,-12);

	oldPaperDollFrame_OnShow();
end

function SCInspectorFrameShow()
	local tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,0);
	SCShowFrame(StatCompareTargetFrame,InspectorFrame,UnitName("target"),tiptext,-5,-12);

	StatScanner_ScanAll();
	if(SC_BuffScanner_ScanAllInspect) then
		-- Scan the buffers
		SC_BuffScanner_ScanAllInspect(StatScanner_bonuses, "player");
	end
	if(StatCompare_CharStats_Scan) then
		StatCompare_CharStats_Scan(StatScanner_bonuses, "player");
	end
	tiptext = StatCompare_GetTooltipText(StatScanner_bonuses,1);
	SCShowFrame(StatCompareSelfFrame,StatCompareTargetFrame,UnitName("player"),tiptext,0,0);

	oldInspectorFrameShow();
end
function SCGoodInspect_InspectFrame_Show(unit)
	oldGoodInspect_InspectFrame_Show(unit);
	if ( not UnitIsPlayer(unit)) then return; end

	local tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,0);
	SCShowFrame(StatCompareTargetFrame,InspectFrame,UnitName("target"),tiptext,-5,-12);

	tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,1);
	SCShowFrame(StatCompareSelfFrame,StatCompareTargetFrame,UnitName("player"),tiptext,0,0);

end
function SCInspectorFrameHide()
	SCHideFrame(StatCompareTargetFrame);
	SCHideFrame(StatCompareSelfFrame);
	oldInspectorFrameHide();
end
function SCSuperInspect_InspectFrame_Show(unit)
	SCHideFrame(StatCompareTargetFrame);
	SCHideFrame(StatCompareSelfFrame);
	if (UnitExists(unit) and UnitIsPlayer(unit) and UnitIsFriend(unit, "player")) then
		local tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,0);
		SCShowFrame(StatCompareTargetFrame,SuperInspectFrame,UnitName("target"),tiptext,-5,-12);

		tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,1);
		SCShowFrame(StatCompareSelfFrame,StatCompareTargetFrame,UnitName("player"),tiptext,0,0);

		if IsAddOnLoaded("S_ItemTip") then
			local score, r, g, b = ItemSocre:ScanUnit("target")
			if score and score > 0 then
				TargetItemGS:SetText(STATCOMPARE_MSG_EQUIPMENT_LEVEL..": " .. score)
				TargetItemGS:SetTextColor(r, g, b)
			else
				TargetItemGS:SetText()
			end
		end
	end
	scoldSuperInspect_InspectFrame_Show(unit);
end
function SCClearInspectPlayer()
	SCHideFrame(StatCompareTargetFrame);
	SCHideFrame(StatCompareSelfFrame);
	scoldClearInspectPlayer();
end

function StatCompare_GetTitlebarText(prefix)
	return (prefix and prefix .. " / " or "")..GREEN_FONT_COLOR_CODE..STATCOMPARE_ADDON_NAME..FONT_COLOR_CODE_CLOSE.." "..STATCOMPARE_ADDON_VERSION
end

function SCShowFrame(frame,target,tiptitle,tiptext,anchorx,anchory)
	local unit = target:GetName() == "InspectFrame" and "target" or "player"

	StatCompare_UpdateFrameContent(frame:GetName(), tiptext, unit, tiptitle)

	if IsAddOnLoaded("S_ItemTip") then
		local score = ItemSocre:ScanUnit("player")
		if score and score > 0 then frame:SetHeight(frame:GetHeight()+30) end
	end

	if(IsAddOnLoaded("oSkin") or IsAddOnLoaded("Skinner")) then
		if(target:GetName() == "InspectFrame" or target:GetName() == "PaperDollFrame") then
			frame:SetPoint("TOPLEFT", target:GetName(), "TOPRIGHT", anchorx + 30, anchory + 12);
		else
			frame:SetPoint("TOPLEFT", target:GetName(), "TOPRIGHT", anchorx, anchory);
		end
	else
		frame:SetPoint("TOPLEFT", target:GetName(), "TOPRIGHT", anchorx, anchory);
	end
	if(tiptext=="") then
		frame:Hide();
	else
		local showSelfFrame = StatCompare_GetSetting("ShowSelfFrame");
		if(StatCompareTargetFrame:IsVisible() and showSelfFrame == 0 and frame == StatCompareSelfFrame) then
			frame:Hide();
		else
			frame:Show();
		end
	end
end

function SCHideFrame(frame)
	frame:Hide();
end

function SCPaperDollFrame_OnHide()
	SCHideFrame(StatCompareSelfFrame);
	oldPaperDollFrame_OnHide();
end

function SCInspectFrame_Show(unit)
	HideUIPanel(InspectFrame);
	oldInspectFrame_Show(unit);
	if (not UnitIsVisible(unit)) then return; end
	if(UnitExists(unit) and UnitIsPlayer(unit)) then
		NotifyInspect(unit);
		InspectFrame.unit = unit;
		ShowUIPanel(InspectFrame);

		local tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,0);
		SCShowFrame(StatCompareTargetFrame,InspectFrame,UnitName("target"),tiptext,-5,-12);

		tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses,1);
		SCShowFrame(StatCompareSelfFrame,StatCompareTargetFrame,UnitName("player"),tiptext,0,0);
	end
end

function SCInspectFrame_OnHide()
	SCHideFrame(StatCompareTargetFrame);
	SCHideFrame(StatCompareSelfFrame);
	oldInspectFrame_OnHide();
end

function SCHideUIPanel(frame)
	if (frame == DressUpFrame) then
		SCItemTooltip:Hide();
		SCHideFrame(StatCompareItemStatFrame);
	end
	oldHideUIPanel(frame);
end

function StatScanner_GetStatsDisplayText(bonuses,bSelfStat)
	local retstr,cat,val,lval = "","","","","";
	local i;
	local baseval = {};
	if(bSelfStat==1) then
		_, baseval["STR"], _, _ = UnitStat("player", 1);
		_, baseval["AGI"], _, _ = UnitStat("player", 2);
		_, baseval["STA"], _, _ = UnitStat("player", 3);
		_, baseval["INT"], _, _ = UnitStat("player", 4);
		_, baseval["SPI"], _, _ = UnitStat("player", 5);

		_, baseval["ARCANERES"], _, _ = UnitResistance("player",6);
		_, baseval["FIRERES"], _, _ = UnitResistance("player",2);
		_, baseval["NATURERES"], _, _ = UnitResistance("player",3);
		_, baseval["FROSTRES"], _, _ = UnitResistance("player",4);
		_, baseval["SHADOWRES"], _, _ = UnitResistance("player",5);

		baseval["DODGE"] = GetDodgeChance();
		baseval["CRIT"] = StatCompare_CharStats_GetCritChance()
		baseval["TOBLOCK"] = GetBlockChance();
		baseval["PARRY"] = GetParryChance();
		if(baseval["TOBLOCK"] == 0) then
			baseval["TOBLOCK"] = nil;
		end
		if(baseval["PARRY"] == 0) then
			baseval["PARRY"] = nil;
		end
		baseval["ATTACKPOWER"], posBuff, negBuff = UnitAttackPower("player");
		baseval["ATTACKPOWER"] = baseval["ATTACKPOWER"] + posBuff + negBuff;
		baseval["RANGEDATTACKPOWER"], posBuff, negBuff = UnitRangedAttackPower("player");
		baseval["RANGEDATTACKPOWER"] = baseval["RANGEDATTACKPOWER"] + posBuff + negBuff;
		baseval["DEFENSE"], armorDefense = UnitDefense("player");
		baseval["DEFENSE"] = baseval["DEFENSE"] + armorDefense;
		baseval["HEALTH"] = UnitHealthMax("player");
		_, baseval["ARMOR"], _, _, _ = UnitArmor("player");
		baseval["MANA"] = UnitManaMax("player");
	end
	--DEFAULT_CHAT_FRAME:AddMessage("Entering GetTooltipText");
	for i,e in pairs(STATCOMPARE_EFFECTS) do
		if(e.opt and StatCompare_GetSetting(e.opt) and StatCompare_GetSetting(e.opt) ~= 1) then
		elseif(e.show and e.show == 0) then
		elseif(bonuses[e.effect]) then
			if(e.format) then
		   		val = format(e.format,bonuses[e.effect]);
			else
				val = bonuses[e.effect];
			end;
			if(e.cat ~= cat) then
				cat = e.cat;
				if(retstr ~= "") then
					retstr = retstr .. "\n"
				end
				retstr = retstr .. "\n" ..GREEN_FONT_COLOR_CODE.. getglobal('STATCOMPARE_CAT_'..cat)..":"..FONT_COLOR_CODE_CLOSE;
			end

			if (bSelfStat==1) then
				if(baseval[e.effect]) then
					if(e.lformat) then
						lval = format(e.lformat, baseval[e.effect]);
					else
						lval = baseval[e.effect];
					end
					val=val.." / "..lval;
				elseif(CharStats_fullvals and CharStats_fullvals[e.effect]) then
					if(CharStats_fullvals[e.effect] == 0) then
					elseif(e.show and e.show == 0) then
					else
						if(e.lformat) then
							lval = format(e.lformat, CharStats_fullvals[e.effect]);
						else
							lval = CharStats_fullvals[e.effect];
						end
						val = val.." / "..lval;
					end
				end
			elseif(bSelfStat==0 and CharStats_fullvals and CharStats_fullvals[e.effect]) then
				if(e.effect == "SPELLHIT" or e.effect == "TOHIT") then
				elseif(CharStats_fullvals[e.effect] == 0) then
				else
					if(e.lformat) then
						lval = format(e.lformat, CharStats_fullvals[e.effect]);
					else
						lval = CharStats_fullvals[e.effect];
					end
					val = val.." / "..lval;
				end
			end

			if(e.effect == "MANAREG") then
				val = val.." MP/5s"
			end


			-- XXX [[ TEMPORARY / TESTING. Adds an asterisk (*) to lines affected by bcslib.
			local b = BCSLib ~= nil and BCSLib.StatHasCallback and 1 or 0
			local a = BCSLib ~= nil and BCSLib.StatHasCallback ~= nil and BCSLib:StatHasCallback(e.effect) ~= nil
			local bcs_stat = BCSLib and BCSLib.StatHasCallback and BCSLib:StatHasCallback(e.effect) == true and BCSLib:GetStat(e.effect, (bSelfStat == 1 and "player" or "target")) or nil
			if bcs_stat ~= nil then val = bcs_stat.." *" end -- TODO remove
			-- XXX ]]






			retstr = retstr.. "\n".. StatComparePaintText(e.short,e.name)..":\t";
			if(SC_BuffScanner_bonuses and SC_BuffScanner_bonuses[e.effect]) then
				retstr = retstr.. GREEN_FONT_COLOR_CODE..val..FONT_COLOR_CODE_CLOSE;
			else
				retstr = retstr.. NORMAL_FONT_COLOR_CODE..val..FONT_COLOR_CODE_CLOSE;
			end

			-- special hack for DRUID AP
			if(e.effect == "ATTACKPOWER" and CharStats_fullvals and CharStats_fullvals["BEARAP"] and CharStats_fullvals["BEARAP"] > 0) then
				retstr = retstr .. "\n" ..STATCOMPARE_DRUID_BEAR..":\t"..NORMAL_FONT_COLOR_CODE..CharStats_fullvals["BEARAP"]..FONT_COLOR_CODE_CLOSE;
				retstr = retstr .. "\n" ..STATCOMPARE_DRUID_CAT..":\t"..NORMAL_FONT_COLOR_CODE..CharStats_fullvals["CATAP"]..FONT_COLOR_CODE_CLOSE;
			end

		elseif(CharStats_fullvals and CharStats_fullvals[e.effect]) then
			if(e.effect == "SPELLHIT" or e.effect == "TOHIT") then
			elseif(CharStats_fullvals[e.effect] == 0) then
			elseif(e.show and e.show == 0) then
			else
				if(e.lformat) then
					val = format(e.lformat, CharStats_fullvals[e.effect]);
				else
					val = CharStats_fullvals[e.effect];
				end
				if(e.cat ~= cat) then
					cat = e.cat;
					if(retstr ~= "") then
						retstr = retstr .. "\n"
					end
					retstr = retstr .. "\n" ..GREEN_FONT_COLOR_CODE.. getglobal('STATCOMPARE_CAT_'..cat)..":"..FONT_COLOR_CODE_CLOSE;

				end

				if (bSelfStat==1 and baseval[e.effect]) then
					if(e.lformat) then
						lval = format(e.lformat, baseval[e.effect]);
					else
						lval = baseval[e.effect];
					end
					val = lval;
				end

				if(e.effect == "MANAREG") then
					val = val.." MP/5s"
				end

				retstr = retstr.. "\n".. StatComparePaintText(e.short,e.name)..":\t";
				if(SC_BuffScanner_bonuses and SC_BuffScanner_bonuses[e.effect]) then
					retstr = retstr.. GREEN_FONT_COLOR_CODE..val..FONT_COLOR_CODE_CLOSE;
				else
					retstr = retstr.. NORMAL_FONT_COLOR_CODE..val..FONT_COLOR_CODE_CLOSE;
				end

				-- special hack for DRUID AP
				if(e.effect == "ATTACKPOWER" and CharStats_fullvals["BEARAP"] and CharStats_fullvals["BEARAP"] > 0) then
					retstr = retstr .. "\n" ..STATCOMPARE_DRUID_BEAR..":\t"..NORMAL_FONT_COLOR_CODE..CharStats_fullvals["BEARAP"]..FONT_COLOR_CODE_CLOSE;
					retstr = retstr .. "\n" ..STATCOMPARE_DRUID_CAT..":\t"..NORMAL_FONT_COLOR_CODE..CharStats_fullvals["CATAP"]..FONT_COLOR_CODE_CLOSE;
				end
			end
		end
	end
	return retstr;
end

function StatCompare_GetGearsetTooltipText(bonuses,bSelfStat)
	local setstr=""

	local settitle="\n\n"..GREEN_FONT_COLOR_CODE..STATCOMPARE_SET_PREFIX..FONT_COLOR_CODE_CLOSE
	for i,v in pairs(StatScanner_setcount) do
		setstr=setstr.."\n"..'|cff'..v.color..i..v.count.."/"..v.total..") "..FONT_COLOR_CODE_CLOSE;
	end
	if (setstr~="") then setstr=settitle..setstr; end
	return setstr
end

function StatCompare_UpdateAndGetTooltipText(bonuses, bSelfStat)
	StatScanner_ScanAllInspect((bSelfStat == 1 and "player" or nil)) -- this weird function needs `nil` rather than "target". :\

	if(SC_BuffScanner_ScanAllInspect) then
		-- Scan the buffers
		SC_BuffScanner_ScanAllInspect(StatScanner_bonuses, (bSelfStat == 1 and "player" or "target"));
	end
	if(StatCompare_CharStats_Scan) then
		StatCompare_CharStats_Scan(StatScanner_bonuses, (bSelfStat == 1 and "player" or "target"));
	end

	local tiptext = StatCompare_GetTooltipText(StatScanner_bonuses, bSelfStat);
	return tiptext
end


function StatCompare_GetTooltipText(bonuses,bSelfStat)
	local retstr=""

	if StatCompare_GetDisplayGroupSetting(bSelfStat, "BasicStats") then
		retstr= retstr..StatScanner_GetStatsDisplayText(bonuses,bSelfStat)
		retstr= retstr..StatCompare_GetGearsetTooltipText(bonuses,bSelfStat)
	end

	if StatCompare_GetDisplayGroupSetting(bSelfStat, "TalentSpec") and bSelfStat == 1 and StatCompare_GetTalentSpecToolTipText then
		retstr= retstr..StatCompare_GetTalentSpecToolTipText()
	end

	if StatCompare_GetDisplayGroupSetting(bSelfStat, "SpellPowerStats") and StatCompare_GetSpellsTooltipText then
		retstr= retstr..StatCompare_GetSpellsTooltipText(StatScanner_bonuses, bSelfStat == 1 and "player" or "target");
	end

	if StatCompare_GetDisplayGroupSetting(bSelfStat, "EquippedItems") or StatCompare_GetDisplayGroupSetting(bSelfStat, "EquippedEnchants") == true and StatCompare_GetEquippedItemNamesAndEnchantsDisplayText then
		local itemsandenchants=StatCompare_GetEquippedItemNamesAndEnchantsDisplayText(bSelfStat==1 and "player" or "target")
		retstr=retstr.."\n\n"..itemsandenchants
	end
	
	if StatCompare_IsAllHidden(bSelfStat) and nvl(StatCompare_IsTutorialInstalled,false) == true then
		local tutorialtext = StatCompare_GetTutorialText()
		retstr = retstr .. tutorialtext
	end

	return retstr;
end

function StatComparePaintText(short,val)
	local color = 'FFFFFF';
	local text = string.sub(short,2);
	local colorcode = string.sub(short,1,1);
	if(StatCompre_ColorList[colorcode]) then
		color = StatCompre_ColorList[colorcode];
	end;
	if(val) then
		return '|cff'.. color .. val .. FONT_COLOR_CODE_CLOSE
	else
		return '|cff'.. color .. text .. FONT_COLOR_CODE_CLOSE
	end;
end

function StatcompareBinding()
	if(InspectFrame:IsVisible()) then
		HideUIPanel(InspectFrame);
	else
		InspectUnit("target");
	end
end


-- 2006.01.27 edit --
function StatCompare_SetupItemLinkHook()
	if(StatCompare_enable==1) then
		if ((ChatFrame_OnHyperlinkShow ~= StatCompare_ChatFrame_OnHyperlinkShow) and (scoldChatFrame_OnHyperlinkShow == nil)) then
			scoldChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow;
			ChatFrame_OnHyperlinkShow = StatCompare_ChatFrame_OnHyperlinkShow;
		end
		if ((PaperDollItemSlotButton_OnClick ~= StatCompare_PaperDollItemSlotButton_OnClick) and (scoldPaperDollItemSlotButton_OnClick == nil)) then
			scoldPaperDollItemSlotButton_OnClick = PaperDollItemSlotButton_OnClick;
			PaperDollItemSlotButton_OnClick = StatCompare_PaperDollItemSlotButton_OnClick;
		end
		if ((InspectPaperDollItemSlotButton_OnClick ~= StatCompare_InspectPaperDollItemSlotButton_OnClick) and (scoldInspectPaperDollItemSlotButton_OnClick == nil)) then
			scoldInspectPaperDollItemSlotButton_OnClick = InspectPaperDollItemSlotButton_OnClick;
			InspectPaperDollItemSlotButton_OnClick = StatCompare_InspectPaperDollItemSlotButton_OnClick;
		end

	else -- unhook
		if (ChatFrame_OnHyperlinkShow == StatCompare_ChatFrame_OnHyperlinkShow) then
			ChatFrame_OnHyperlinkShow = scoldChatFrame_OnHyperlinkShow;
			scoldChatFrame_OnHyperlinkShow = nil;
		end
		if (PaperDollItemSlotButton_OnClick == StatCompare_PaperDollItemSlotButton_OnClick) then
			PaperDollItemSlotButton_OnClick = scoldPaperDollItemSlotButton_OnClick;
			scoldPaperDollItemSlotButton_OnClick = nil;
		end
		if (InspectPaperDollItemSlotButton_OnClick == StatCompare_InspectPaperDollItemSlotButton_OnClick) then
			InspectPaperDollItemSlotButton_OnClick = scoldInspectPaperDollItemSlotButton_OnClick;
			scoldInspectPaperDollItemSlotButton_OnClick = nil;
		end
	end
end

function StatCompare_ChatFrame_OnHyperlinkShow(link, text, button)
	if(StatCompare_GeneralEditFrameEidtBox:IsVisible()) then
		StatCompare_GeneralEditFrameEidtBox:SetText(text);
	end
	return scoldChatFrame_OnHyperlinkShow(link, text, button);
end

function StatCompare_PaperDollItemSlotButton_OnClick(button, ignoreModifiers)
	if(StatCompare_GeneralEditFrameEidtBox:IsVisible() and IsShiftKeyDown()) then
		StatCompare_GeneralEditFrameEidtBox:SetText(GetInventoryItemLink("player", this:GetID()));
	end
	return scoldPaperDollItemSlotButton_OnClick(button, ignoreModifiers);
end

function StatCompare_InspectPaperDollItemSlotButton_OnClick(button)
	if(StatCompare_GeneralEditFrameEidtBox:IsVisible() and IsShiftKeyDown()) then
		StatCompare_GeneralEditFrameEidtBox:SetText(GetInventoryItemLink(InspectFrame.unit, this:GetID()));
	end
	return scoldInspectPaperDollItemSlotButton_OnClick(button);
end

function StatCompare_ItemCollectionFrame_OnLoad()
end


function StatCompare_ItemCollectionFrame_OnShow()
	StatCompare_ItemCollection_ScrollFrame_Update();
end

local statcompare_editdata = {type="",id="",text="",value=""};
function StatCompare_ItemCollection_Add_OnClick()
	statcompare_editdata.type="edititem";
	statcompare_editdata.id=0;
	statcompare_editdata.text=STATCOMPARE_MSG_SHIFTCLICK_ITEM_OR_LINK
	statcompare_editdata.value="";
	StatCompare_GeneralEditFrame:Show();
end

function StatCompare_GeneralEditFrame_OnShow()
	local control= getglobal(this:GetName().."EditTitle");
	control:SetText(statcompare_editdata.text);
	StatCompare_GeneralEditFrameEidtBox:SetText(statcompare_editdata.value);
	StatCompare_GeneralEditFrameEidtBox:HighlightText();
end

function StatCompare_GeneralEditFrame_Save()
	local s=StatCompare_GeneralEditFrameEidtBox:GetText();
	if (statcompare_editdata.type=="edititem") then
		if (s~="") then
			table.insert(StatCompare_ItemCollection,1,s);
			table.insert(StatCompare_ItemCache,1,s);
		end
	end
	StatCompare_ItemCollection_ScrollFrame_Update();
end


local StatCompare_DelItem="";
StaticPopupDialogs["StatCompare_DelItem"] = {
	text = STATCOMPARE_MSG_CONFIRM_DELETE,
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		StatCompare_DeleteItem(StatCompare_DelItem);
		StatCompare_BuildItemCache();
		StatCompare_ItemCollection_ScrollFrame_Update();
		StatCompare_DelItem="";
	end,
	showAlert = 1,
	timeout = 0,
	hideOnEscape = 1
};
function StatCompare_DeleteItem(sItem)
	if sItem=="" then return; end
	for i=1, getn(StatCompare_ItemCollection) do
		if(sItem==StatCompare_ItemCollection[i]) then
			table.remove(StatCompare_ItemCollection,i);
			break;
		end
	end
end
function StatCompare_ItemCol_Onclick()
	local id=this:GetID();
	local button = getglobal("StatCompareItem"..id.."_Name");
	local s=button:GetText();
	if (s ==nil or s=="") then return; end
	local _,_,_,text,_=string.find(s,"|(.-)|H(.-)|(.-)|h|r");
	if (IsShiftKeyDown()) then
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:Insert(s);
		end
	elseif (IsControlKeyDown() and text) then
		DressUpItemLink(s);
	elseif (IsAltKeyDown()) then
		StatCompare_DelItem=s;
		StaticPopup_Show("StatCompare_DelItem");
	elseif (text) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		GameTooltip:SetHyperlink(text);
		local _,_,_,_,sType,sSubType,_ = GetItemInfo(text);
		--DEFAULT_CHAT_FRAME:AddMessage(sType..":"..sSubType);
	end
end

function StatCompare_ItemCollection_ScrollFrame_Update()
	if not StatCompare_ItemCollectionFrame:IsVisible() then return; end
	local number=getn(StatCompare_ItemCache);
	FauxScrollFrame_Update(StatCompare_ItemCollection_ScrollFrame, number, 10, 22);

	local line;
	local lineplusoffset;
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(StatCompare_ItemCollection_ScrollFrame);
		if (lineplusoffset < number+1) then
			btn = getglobal("StatCompareItem"..line.."_Name");
			local stitle = StatCompare_ItemCache[lineplusoffset];
			btn:SetText(stitle);
			btn:Show();
		else
			getglobal("StatCompareItem"..line.."_Name"):SetText("");
			getglobal("StatCompareItem"..line.."_Name"):Hide();
		end
	end
end

-- 2006.02.03 edit --
-------------------------------------- 物品稀有度下拉框 ------------------------------------------
----------------------------------- Item Rarity Dropdown ---------------------------------------
StatCompare_ItemRarity_DROPDOWN_LIST = {
	{name = STATCOMPARE_ITEMTYPE_ALL, value = -1},
	{name = "|c009d9d9d"..STATCOMPARE_ITEMRARITY_GRAY.."|r", value = 0},
	{name = "|c00ffffff"..STATCOMPARE_ITEMRARITY_WHITE.."|r", value = 1},
	{name = "|c001eff00"..STATCOMPARE_ITEMRARITY_GREEN.."|r", value = 2},
	{name = "|c000070dd"..STATCOMPARE_ITEMRARITY_BLUE.."|r", value = 3},
	{name = "|c00a335ee"..STATCOMPARE_ITEMRARITY_PURPLE.."|r", value = 4},
	{name = "|c00ff8000"..STATCOMPARE_ITEMRARITY_ORANGE.."|r", value = 5},
};

function StatCompare_ItemRarityDropDown_OnLoad()
	UIDropDownMenu_Initialize(StatCompare_ItemRarityDropDown, StatCompare_ItemRarityDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(StatCompare_ItemRarityDropDown,1);
	UIDropDownMenu_SetWidth(70);
end

function StatCompare_ItemRarityDropDown_Initialize()
	local info;
	for i = 1, getn(StatCompare_ItemRarity_DROPDOWN_LIST), 1 do
		info = { };
		info.text = StatCompare_ItemRarity_DROPDOWN_LIST[i].name;
		info.value = StatCompare_ItemRarity_DROPDOWN_LIST[i].value;
		info.func = StatCompare_ItemRarityDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function StatCompare_ItemRarityDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(StatCompare_ItemRarityDropDown, this:GetID());
	StatCompare_BuildItemCache();
	StatCompare_ItemCollection_ScrollFrame_Update();
end

-------------------------------------- 物品类型下拉框 -----------------------------------------
---------------------------------- Item Type Dropdown --------------------------------------
StatCompare_ItemType_DROPDOWN_LIST = {
	{name = STATCOMPARE_ITEMTYPE_ALL, value = STATCOMPARE_ITEMTYPE_ALL, subvalue=STATCOMPARE_ITEMTYPE_ALL},
	{name = STATCOMPARE_ITEMTYPE_ARMS, value = STATCOMPARE_ITEMTYPE_ARMS, subvalue=STATCOMPARE_ITEMTYPE_ALL},
	{name = STATCOMPARE_ITEMTYPE_ARMOR, value = STATCOMPARE_ITEMTYPE_ARMOR, subvalue=STATCOMPARE_ITEMTYPE_ALL},
	{name = "- "..STATCOMPARE_ITEMTYPE_ARMOR_PLATE, value = STATCOMPARE_ITEMTYPE_ARMOR, subvalue=STATCOMPARE_ITEMTYPE_ARMOR_PLATE},
	{name = "- "..STATCOMPARE_ITEMTYPE_ARMOR_MAIL, value = STATCOMPARE_ITEMTYPE_ARMOR, subvalue=STATCOMPARE_ITEMTYPE_ARMOR_MAIL},
	{name = "- "..STATCOMPARE_ITEMTYPE_ARMOR_LEATHER, value = STATCOMPARE_ITEMTYPE_ARMOR, subvalue=STATCOMPARE_ITEMTYPE_ARMOR_LEATHER},
	{name = "- "..STATCOMPARE_ITEMTYPE_ARMOR_CLOTH, value = STATCOMPARE_ITEMTYPE_ARMOR, subvalue=STATCOMPARE_ITEMTYPE_ARMOR_CLOTH},
	{name = "- "..STATCOMPARE_ITEMTYPE_ARMOR_SHIELD, value = STATCOMPARE_ITEMTYPE_ARMOR, subvalue=STATCOMPARE_ITEMTYPE_ARMOR_SHIELD},
	{name = "- "..STATCOMPARE_ITEMTYPE_ARMOR_OTHER, value = STATCOMPARE_ITEMTYPE_ARMOR, subvalue=STATCOMPARE_ITEMTYPE_ARMOR_OTHER},
	{name = STATCOMPARE_ITEMTYPE_ARMOR_OTHER, value = STATCOMPARE_ITEMTYPE_ARMOR_OTHER, subvalue=STATCOMPARE_ITEMTYPE_ALL},
};

function StatCompare_ItemTypeDropDown_OnLoad()
	UIDropDownMenu_Initialize(StatCompare_ItemTypeDropDown, StatCompare_ItemTypeDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(StatCompare_ItemTypeDropDown,1);
	UIDropDownMenu_SetWidth(70);
end

function StatCompare_ItemTypeDropDown_Initialize()
	local info;
	for i = 1, getn(StatCompare_ItemType_DROPDOWN_LIST), 1 do
		info = { };
		info.text = StatCompare_ItemType_DROPDOWN_LIST[i].name;
		info.value = StatCompare_ItemType_DROPDOWN_LIST[i].value;
		info.func = StatCompare_ItemTypeDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function StatCompare_ItemTypeDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(StatCompare_ItemTypeDropDown, this:GetID());
	StatCompare_BuildItemCache();
	StatCompare_ItemCollection_ScrollFrame_Update();
end
----------------------------------------------------------------------------------------------
function StatCompare_BuildItemCache()
	StatCompare_ItemCache={};
	local rarityFilter=StatCompare_ItemRarity_DROPDOWN_LIST[UIDropDownMenu_GetSelectedID(StatCompare_ItemRarityDropDown)].value;
	if(not rarityFilter) then rarityFilter=-1; end

	local typeFilter=StatCompare_ItemType_DROPDOWN_LIST[UIDropDownMenu_GetSelectedID(StatCompare_ItemTypeDropDown)].value;
	local subtypeFilter=StatCompare_ItemType_DROPDOWN_LIST[UIDropDownMenu_GetSelectedID(StatCompare_ItemTypeDropDown)].subvalue;
	if(not typeFilter) then typeFilter=STATCOMPARE_ITEMTYPE_ALL; end
	if(not subtypeFilter) then subtypeFilter=STATCOMPARE_ITEMTYPE_ALL; end

	for i=1,getn(StatCompare_ItemCollection) do
		local _,_,_,sItem,_=string.find(StatCompare_ItemCollection[i],"|(.-)|H(.-)|(.-)|h|r");
		if(sItem) then
			local _,_,iRarity,_,sType,sSubType,_ = GetItemInfo(sItem);
			if (not iRarity) then
				iRarity = -1;
			end
			if (iRarity>=rarityFilter) then
				if (typeFilter==STATCOMPARE_ITEMTYPE_ALL) then
					table.insert(StatCompare_ItemCache,StatCompare_ItemCollection[i]);
				elseif (sType==typeFilter and (subtypeFilter==STATCOMPARE_ITEMTYPE_ALL or sSubType==subtypeFilter)) then
					table.insert(StatCompare_ItemCache,StatCompare_ItemCollection[i]);
				elseif (typeFilter==STATCOMPARE_ITEMTYPE_OTHER and sType~=STATCOMPARE_ITEMTYPE_ARMS and sType~=STATCOMPARE_ITEMTYPE_ARMOR) then
					table.insert(StatCompare_ItemCache,StatCompare_ItemCollection[i]);
				end
			end
		end
	end
end

function StatCompare_IsAllHidden(bSelfStat)
	local allHidden = true
	for _, key in ipairs(STATCOMPARE_DISPLAY_GROUPS) do
		if StatCompare_GetDisplayGroupSetting(bSelfStat, key) == true then
			allHidden = false
			break
		end
	end
	return allHidden
end

function StatCompare_UpdateDisplayedAttributeGroups(attributesToToggle, buttonName, frameName, unit)
	local bSelfStat = (unit == "player" and 1 or 0)
	for _, attributeToToggle in pairs(attributesToToggle) do
		if StatCompare_GetDisplayGroupSetting(bSelfStat, attributeToToggle) == false then
			StatCompare_SetDisplayGroupSetting(bSelfStat, attributeToToggle, true)
			getglobal(buttonName):UnlockHighlight();
		else
			local willHaveAtLeastOneAttributeVisible = false
			for _, key in ipairs(STATCOMPARE_DISPLAY_GROUPS) do
				local value = StatCompare_GetDisplayGroupSetting(bSelfStat, key)
				ignore = false
				for _, toggle in ipairs(attributesToToggle) do
					if key == toggle then ignore = true; break; end
				end
				if ignore == false and value == true then
					willHaveAtLeastOneAttributeVisible = true
					break
				end
			end
			if willHaveAtLeastOneAttributeVisible == true or nvl(StatCompare_IsTutorialInstalled,false) == true then
				StatCompare_SetDisplayGroupSetting(bSelfStat, attributeToToggle, false)
				getglobal(buttonName):LockHighlight();
			else
				DEFAULT_CHAT_FRAME:AddMessage("StatCompare - "..GREEN_FONT_COLOR_CODE..STATCOMPARE_ERROR_CANNOT_HIDE_ALL_FIELDS..FONT_COLOR_CODE_CLOSE);
			end
		end
	end

	local tiptext = StatCompare_UpdateAndGetTooltipText(StatScanner_bonuses, (unit == "player" and 1 or 0))
	StatCompare_UpdateFrameContent(frameName, tiptext, unit, UnitName(unit))
end

function StatCompareTargetFrameArmorButton_OnClick()
	StatCompare_UpdateDisplayedAttributeGroups({"EquippedItems", "EquippedEnchants", "ActiveBuffs"},"StatCompareTargetFrameArmorButton", "StatCompareTargetFrame", "target")
end

function StatCompareTargetFrameStatsButton_OnClick()
	StatCompare_UpdateDisplayedAttributeGroups({"TalentSpec", "BasicStats"}, "StatCompareTargetFrameStatsButton", "StatCompareTargetFrame", "target")
end

function StatCompareSelfFrameArmorButton_OnClick()
	StatCompare_UpdateDisplayedAttributeGroups({"EquippedItems", "EquippedEnchants", "ActiveBuffs"}, "StatCompareSelfFrameArmorButton", "StatCompareSelfFrame", "player")
end

function StatCompareSelfFrameStatsButton_OnClick()
	StatCompare_UpdateDisplayedAttributeGroups({"TalentSpec", "BasicStats"}, "StatCompareSelfFrameStatsButton", "StatCompareSelfFrame", "player")
end

function StatCompareSelfFrameSpellsButton_OnClick()
	StatCompare_UpdateDisplayedAttributeGroups({"SpellPowerStats"}, "StatCompareSelfFrameSpellsButton", "StatCompareSelfFrame", "player")
end

function StatCompareTargetFrameSpellsButton_OnClick()
	StatCompare_UpdateDisplayedAttributeGroups({"SpellPowerStats"}, "StatCompareTargetFrameSpellsButton", "StatCompareTargetFrame", "target")
end

function StatCompare_UpdateFrameContent(frameName, textbody, unit, tiptitle)
	local titletext = StatCompare_GetTitlebarText(tiptitle)
	StatCompare_UpdateFrameText(frameName, textbody, titletext)
	StatBuffs_UpdateBuffs(frameName, unit)
end

function StatCompare_UpdateFrameText(frameName, textbody, titletext)
	local frame = getglobal(frameName);
	local text = getglobal(frameName.."Text");
	local title = getglobal(frameName.."Title");
	local buffFrame = getglobal(frame:GetName().."BuffList")
	local paddingForAesthetics = 20; -- Without this, the content stopped precisely against the words on the right and bottom.
	text:SetText(textbody);
	if (titletext ~= nil) then
		title:SetText(titletext)
	end
	local height = text:GetHeight() + title:GetHeight() + paddingForAesthetics;
	local newwidth = text:GetWidth() + paddingForAesthetics;
	local framewidth = frame:GetWidth();
	if newwidth < framewidth then
		newwidth = framewidth
	end
	local iconwidth = 20*4;
	local titlewidth = title:GetWidth() + iconwidth;
	if(newwidth < titlewidth) then
		newwidth = titlewidth
	end
	frame:SetHeight(height);
	frame:SetWidth(newwidth);
end
