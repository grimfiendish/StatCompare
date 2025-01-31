
function StatCompare_CountSelectedTalents()
	local tree = { 0, 0, 0 }
	for i = 1, GetNumTalentTabs() do
		local selectedTalents = 0

		for j = 1,  GetNumTalents(i) do
			local  _, _, _, _, rank = GetTalentInfo(i, j) 
			if rank then
				selectedTalents = selectedTalents + rank
			end
		end
		tree[i] = selectedTalents
    end
	return tree
end

function StatCompare_GetTalentSynopsis() 
	local synopsis = ""
	for _, count in StatCompare_CountSelectedTalents() do
		if synopsis ~= "" then synopsis = synopsis .. "/" .. count
		else synopsis = count
		end
	end
	return synopsis
end

function StatCompare_GetTalentSpecToolTipText()
	return GREEN_FONT_COLOR_CODE.."\n\n"..STATCOMPARE_TALENT_SPECIALIZATION..":"..FONT_COLOR_CODE_CLOSE.."\n"..StatCompare_GetTalentSynopsis();
end
