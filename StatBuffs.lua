-- Functions to add the target's buffs to the pane. 
-- This is because usually people crop the screen and thus you can't see whether their stats are artificially improved.

function StatBuffs_GetBuffs(unit)
	local buffs = {}
    local i = 1

    while true do
        local buffIconPath, rank = UnitBuff(unit, i)

        if not buffIconPath then
            break
        end

		table.insert(buffs, buffIconPath)
        i = i + 1
    end
	return buffs
end

--[[ debugging - uncomment and it'll print a big pile of your first couple buffs repeated a lot
function StatBuffs_GetBuffs(unit)
	local buffs = {}
    local i = 1
	local buffIconPath, rank = UnitBuff(unit, 1)
		table.insert(buffs, buffIconPath)

    while true do
        local buffIconPath, rank = UnitBuff(unit, 2)
        --local buffIconPath, rank = UnitBuff(unit, i)

        if not buffIconPath or i > 25 then
            break
        end

		table.insert(buffs, buffIconPath)
        i = i + 1
    end
	return buffs
end
--]]

function StatCompare_ResetBuffIcons(tooltipFrame, unit)

	if tooltipFrame.buffTextures == nil then
		tooltipFrame.buffTextures = {}
	else
		for i, tx in ipairs(tooltipFrame.buffTextures) do
			tx:Hide()
			tx:ClearAllPoints()
		end
	end
	
	tooltipFrame:Hide()
end
-- Add buff icons to the StatCompare dialog
function StatCompare_AddBuffIconsToTooltip(tooltipFrame, unit)
    local iconSize = 16
    local spacing = 3
    local totalWidth = 0
	local rows = 1
	local curIconInRow = 0
	local curRow = 1
	
	local iconPaths = StatBuffs_GetBuffs(unit)

	StatCompare_ResetBuffIcons(tooltipFrame, unit)

    local iconCount = 0
    for _, _ in pairs(iconPaths) do
        iconCount = iconCount + 1
    end

    totalWidth = (iconSize + spacing) * iconCount - spacing
	local iconsPerRow = math.floor(tooltipFrame:GetWidth() / (iconSize + spacing))
	
	rows = math.ceil(totalWidth / tooltipFrame:GetWidth())
	tooltipFrame:SetHeight((iconSize + spacing) * rows)

    for i, iconPath in ipairs(iconPaths) do
		curIconInRow = curIconInRow + 1
		if curIconInRow > iconsPerRow then
			curRow = curRow + 1
			curIconInRow = 1
		end

        if tooltipFrame.buffTextures[i] == nil then
			tooltipFrame.buffTextures[i] = tooltipFrame:CreateTexture(nil, "BACKGROUND")
		end
        tooltipFrame.buffTextures[i]:SetWidth(iconSize)
        tooltipFrame.buffTextures[i]:SetHeight(iconSize)
        tooltipFrame.buffTextures[i]:SetTexture(iconPath)
		tooltipFrame.buffTextures[i]:Show()

        tooltipFrame.buffTextures[i]:SetPoint("BOTTOMLEFT", tooltipFrame, "BOTTOMLEFT", (curIconInRow - 1) * (iconSize + spacing), (5 + (20 * (curRow - 1))))
    end
	tooltipFrame:Show()
end


function StatBuffs_UpdateBuffs(frameName, unit)
	local frame = getglobal(frameName)
	-- Here we're after the buff list, which displays icons at the bottom of the dialog. Expected values are StatCompareTargetFrame or PaperDollFrame.
	local buffFrame = getglobal(frame:GetName().."BuffList")

	if buffFrame ~= nil then
		if StatCompare_Display["Buffs"] == true then
			local frameWidth = frame:GetWidth()
			buffFrame:SetWidth(frameWidth)
			-- GerName here is PaperDollFrame (for self view) or InspectFrame (other player) and StatCompareTargetFrame (self view next to inspection view)
			StatCompare_AddBuffIconsToTooltip(buffFrame, unit)
			
			local buffFrameTitle = getglobal(frame:GetName().."BuffListTitle")
			buffFrameTitle:SetText(GREEN_FONT_COLOR_CODE..STATCOMPARE_ACTIVEBUFFS..":"..FONT_COLOR_CODE_CLOSE)
		else
			StatCompare_ResetBuffIcons(buffFrame, unit)
		end
	end
end