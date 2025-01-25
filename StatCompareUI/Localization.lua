--[[

	File containing localized strings
	for Simplified Chinese and English versions, defaults to English

]]

if ( GetLocale() == "zhCN" ) then

	-- 界面相关
	STATCOMPARE_OPTIONS = "属性比较配置窗口";
	STATCOMPARE_BASIC_CONFIG = "常规选项";
	STATCOMPARE_ADVANCE_CONFIG = "高级选项";
	STATCOMPARE_OK = "确定";
	STATCOMPARE_DISPLAY_IN_LIST = "选择需要显示的属性";
	STATCOMPARE_DISPLAY_STR = "力量";
	STATCOMPARE_DISPLAY_AGI = "敏捷";
	STATCOMPARE_DISPLAY_STA = "耐力";
	STATCOMPARE_DISPLAY_INT = "智力";
	STATCOMPARE_DISPLAY_SPI = "精神";
	STATCOMPARE_DISPLAY_ARMOR = "护甲";
	STATCOMPARE_DISPLAY_ENARMOR = "强化护甲";
	STATCOMPARE_DISPLAY_DR = "物理免伤";
	STATCOMPARE_DISPLAY_ARCANERES = "奥术抗性";
	STATCOMPARE_DISPLAY_FIRERES	= "火焰抗性";
	STATCOMPARE_DISPLAY_NATURERES = "自然抗性";
	STATCOMPARE_DISPLAY_FROSTRES	= "冰霜抗性";
	STATCOMPARE_DISPLAY_SHADOWRES	= "阴影抗性";
	STATCOMPARE_DISPLAY_DETARRES	= "降低目标抗性";

	STATCOMPARE_DISPLAY_FISHING	= "钓鱼";
	STATCOMPARE_DISPLAY_MINING	= "挖矿";
	STATCOMPARE_DISPLAY_HERBALISM	= "草药";
	STATCOMPARE_DISPLAY_SKINNING	= "剥皮";
	STATCOMPARE_DISPLAY_DEFENSE	= "防御技能";
		
	STATCOMPARE_DISPLAY_BLOCK = "格挡";
	STATCOMPARE_DISPLAY_TOBLOCK = "格挡率";
	STATCOMPARE_DISPLAY_DODGE = "躲闪";
	STATCOMPARE_DISPLAY_PARRY = "招架";
	STATCOMPARE_DISPLAY_AP = "攻击强度";
	STATCOMPARE_DISPLAY_CRIT = "致命";
	STATCOMPARE_DISPLAY_RAP = "远程攻击强度";
	STATCOMPARE_DISPLAY_RCRIT = "远程攻击致命";
	STATCOMPARE_DISPLAY_TOHIT = "命中率";
	STATCOMPARE_DISPLAY_HEALTHREGEN = "生命再生";
	STATCOMPARE_DISPLAY_MANAREGEN = "法力再生";
	STATCOMPARE_DISPLAY_MANAREGENSPI = "精神回魔";
	STATCOMPARE_DISPLAY_HEALTH = "生命值";
	STATCOMPARE_DISPLAY_MANA = "法力值";

	STATCOMPARE_TOOLTIP_MINIMAP = "装备属性统计&比较\n点击打开配置主窗口\n";
	STATCOMPARE_TOOLTIP_MINIMAP1 = "装备属性统计&比较\n点击打开配置主窗口\n";
	STATCOMPARE_MINIMAPBUTTONPOS = "小地图按钮位置";
	STATCOMPARE_MINIMAPBUTTON_POS_TOOLTIP = "允许你移动装备属性统计&比较窗口图标在迷离地图上的位置";
	STATCOMPARE_SHOW_MINIMAP_BUTTON = "显示/隐藏小地图按钮";
	STATCOMPARE_SHOW_SELFFRAME = "察看对方玩家信息时显示自己的属性比较窗口";
	STATCOMPARE_SHOW_BUFFBONUS = "统计装备属性时加入Buf加成统计信息";

elseif( GetLocale() == "zhTW" ) then
	-- TW Chinese localized variables
	-- general

	-- UI related
	STATCOMPARE_OPTIONS		= "StatCompare 选项窗口";
	STATCOMPARE_BASIC_CONFIG	= "常規";
	STATCOMPARE_ADVANCE_CONFIG	= "高級";
	STATCOMPARE_OK			= "OK";
	STATCOMPARE_DISPLAY_IN_LIST	= "選擇需要顯示的屬性";
	STATCOMPARE_DISPLAY_STR		= "力量";
	STATCOMPARE_DISPLAY_AGI		= "敏捷";
	STATCOMPARE_DISPLAY_STA		= "耐力";
	STATCOMPARE_DISPLAY_INT		= "智力";
	STATCOMPARE_DISPLAY_SPI		= "精神";
	STATCOMPARE_DISPLAY_ARMOR	= "護甲";
	STATCOMPARE_DISPLAY_ENARMOR	= "強化護甲";
	STATCOMPARE_DISPLAY_DR		= "物理免傷";
	STATCOMPARE_DISPLAY_ARCANERES	= "祕法抗性";
	STATCOMPARE_DISPLAY_FIRERES	= "火焰抗性";
	STATCOMPARE_DISPLAY_NATURERES	= "自然抗性";
	STATCOMPARE_DISPLAY_FROSTRES	= "冰霜抗性";
	STATCOMPARE_DISPLAY_SHADOWRES	= "陰影抗性";
	STATCOMPARE_DISPLAY_DETARRES	= "降低目標抗性";

	STATCOMPARE_DISPLAY_FISHING	= "釣魚";
	STATCOMPARE_DISPLAY_MINING	= "挖礦";
	STATCOMPARE_DISPLAY_HERBALISM	= "草藥";
	STATCOMPARE_DISPLAY_SKINNING	= "剝皮";
	STATCOMPARE_DISPLAY_DEFENSE	= "防禦技能";
		
	STATCOMPARE_DISPLAY_BLOCK = "格擋";
	STATCOMPARE_DISPLAY_TOBLOCK = "格擋率";
	STATCOMPARE_DISPLAY_DODGE = "躲閃";
	STATCOMPARE_DISPLAY_PARRY = "招架";
	STATCOMPARE_DISPLAY_AP = "攻擊強度";
	STATCOMPARE_DISPLAY_CRIT = "致命一擊";
	STATCOMPARE_DISPLAY_RAP = "遠程攻擊強度";
	STATCOMPARE_DISPLAY_RCRIT = "遠程攻擊致命";
	STATCOMPARE_DISPLAY_TOHIT = "命中率";
	STATCOMPARE_DISPLAY_HEALTHREGEN = "生命再生";
	STATCOMPARE_DISPLAY_MANAREGEN = "法力再生";
	STATCOMPARE_DISPLAY_MANAREGENSPI = "精神回魔";
	STATCOMPARE_DISPLAY_HEALTH = "生命力";
	STATCOMPARE_DISPLAY_MANA = "法力";

	STATCOMPARE_TOOLTIP_MINIMAP = "裝備屬性統計&比較\n左鍵點擊打開配置主窗口\n";
	STATCOMPARE_TOOLTIP_MINIMAP1 = "裝備屬性統計&比較\n左鍵點擊打開配置主窗口\n右鍵點擊打開裝備集主窗口\n";
	STATCOMPARE_MINIMAPBUTTONPOS = "小地圖按鈕位置";
	STATCOMPARE_MINIMAPBUTTON_POS_TOOLTIP = "允許你移動裝備屬性統計&比較窗口圖標在迷離地圖上的位置";
	STATCOMPARE_SHOW_MINIMAP_BUTTON = "顯示/隱藏小地圖按鈕";
	STATCOMPARE_SHOW_SELFFRAME = "察看對方玩家信息時顯示自己的屬性比較窗口";
	STATCOMPARE_SHOW_BUFFBONUS = "裝備屬性統計时加入Buf統計信息";
else
	-- English localized variables (default)
	-- general

	-- UI related
	STATCOMPARE_OPTIONS		= "StatCompare Options Window";
	STATCOMPARE_BASIC_CONFIG	= "General";
	STATCOMPARE_ADVANCE_CONFIG	= "Advance";
	STATCOMPARE_OK			= "OK";
	STATCOMPARE_DISPLAY_IN_LIST	= "Choose the stats be showed";
	STATCOMPARE_DISPLAY_STR		= "Strength";
	STATCOMPARE_DISPLAY_AGI		= "Agility";
	STATCOMPARE_DISPLAY_STA		= "Stamina";
	STATCOMPARE_DISPLAY_INT		= "Intellect";
	STATCOMPARE_DISPLAY_SPI		= "Spirit";
	STATCOMPARE_DISPLAY_ARMOR	= "Armor";
	STATCOMPARE_DISPLAY_ENARMOR	= "Reinforced Armor";
	STATCOMPARE_DISPLAY_DR		= "Damage Reduce";
	STATCOMPARE_DISPLAY_ARCANERES	= "Arcane Resist";
	STATCOMPARE_DISPLAY_FIRERES	= "Fire Resist";
	STATCOMPARE_DISPLAY_NATURERES	= "Nature Resist";
	STATCOMPARE_DISPLAY_FROSTRES	= "Frost Resist";
	STATCOMPARE_DISPLAY_SHADOWRES	= "Shadow Resist";
	STATCOMPARE_DISPLAY_DETARRES	= "Reduced Resist";

	STATCOMPARE_DISPLAY_FISHING	= "Fishing";
	STATCOMPARE_DISPLAY_MINING	= "Mining";
	STATCOMPARE_DISPLAY_HERBALISM	= "Herbalism";
	STATCOMPARE_DISPLAY_SKINNING	= "Skinning";
	STATCOMPARE_DISPLAY_DEFENSE	= "Defense";
		
	STATCOMPARE_DISPLAY_BLOCK = "Block";
	STATCOMPARE_DISPLAY_TOBLOCK = "Chance to Block";
	STATCOMPARE_DISPLAY_DODGE = "Dodge";
	STATCOMPARE_DISPLAY_PARRY = "Parry";
	STATCOMPARE_DISPLAY_AP = "Attack Power";
	STATCOMPARE_DISPLAY_CRIT = "Critical Hit";
	STATCOMPARE_DISPLAY_RAP = "Ranged Attack Power";
	STATCOMPARE_DISPLAY_RCRIT = "Critical Shot";
	STATCOMPARE_DISPLAY_TOHIT = "Chance to Hit";
	STATCOMPARE_DISPLAY_HEALTHREGEN = "Health Regen";
	STATCOMPARE_DISPLAY_MANAREGEN = "Mana Regen";
	STATCOMPARE_DISPLAY_MANAREGENSPI = "Mana Regen with Spirit";
	STATCOMPARE_DISPLAY_HEALTH = "Life";
	STATCOMPARE_DISPLAY_MANA = "Mana";

	STATCOMPARE_TOOLTIP_MINIMAP = "StatCompare\nLeft click to open Option Window\n";
	STATCOMPARE_TOOLTIP_MINIMAP1 = "StatCompare\nLeft click to open Option Window\nRight click to open StatCompareSets Window\n";
	STATCOMPARE_MINIMAPBUTTONPOS = "Button position on the Minimap";
	STATCOMPARE_MINIMAPBUTTON_POS_TOOLTIP = "Allow you adjust the position of StatCompare button on the minimap";
	STATCOMPARE_SHOW_MINIMAP_BUTTON = "Show/Hide button on the minimap";
	STATCOMPARE_SHOW_SELFFRAME = "Show self stats info when view the others";
	STATCOMPARE_SHOW_BUFFBONUS = "Show buf bonus info in StatCompare window";
end