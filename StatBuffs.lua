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

-- Add buff icons to the StatCompare dialog
function StatCompare_AddBuffIconsToTooltip(tooltipFrame, unit)
    local iconSize = 16
    local spacing = 3
    local totalWidth = 0
	local rows = 1
	local curIconInRow = 0
	local curRow = 1
	
	local iconPaths = StatBuffs_GetBuffs(unit)

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
			curIconInRow = 0
		end

        local iconTexture = tooltipFrame:CreateTexture(nil, "BACKGROUND")
        iconTexture:SetWidth(iconSize)
        iconTexture:SetHeight(iconSize)
        iconTexture:SetTexture(iconPath)

        iconTexture:SetPoint("BOTTOMLEFT", tooltipFrame, "BOTTOMLEFT", (curIconInRow - 1) * (iconSize + spacing), (5 + (20 * (curRow - 1))))
    end
end
