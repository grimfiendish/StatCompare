-- StatCompare Tutorial
-- Note: Use concise wording so it doesn't stretch the dialog.

StatCompare_IsTutorialInstalled = true

StatCompare_TutorialIconExplanation = {}

function StatCompare_GetTutorialText()
	local retval = STATCOMPARE_TUTORIAL_INTRO

	for iconpath,text in pairs(StatCompare_TutorialIconExplanation) do
		retval = retval .. "\n* "..text
	end

	return retval
end
