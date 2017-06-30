--[[
-------------------------------------------------------------------------------
-- Dustman, by Ayantir
-------------------------------------------------------------------------------
This software is under : CreativeCommons CC BY-NC-SA 4.0
Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)

You are free to:

	 Share — copy and redistribute the material in any medium or format
	 Adapt — remix, transform, and build upon the material
	 The licensor cannot revoke these freedoms as long as you follow the license terms.


Under the following terms:

	 Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
	 NonCommercial — You may not use the material for commercial purposes.
	 ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
	 No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.


Please read full licence at : 
http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
]]

if not Dustman then return end

local ADDON_VERSION = "7.5"
local ADDON_WEBSITE = "http://www.esoui.com/downloads/info97-Dustman.html"

--addon menu
function Dustman.CreateSettingsMenu(DustSavedVars, DustMarkAsJunk, defaults)

	--local variables
	local qualityChoices = {}
	local reverseQualityChoices = {}
	for i = 0, ITEM_QUALITY_ARTIFACT do
		local color = GetItemQualityColor(i)
		local qualName = color:Colorize(GetString("SI_ITEMQUALITY", i))
		qualityChoices[i] = qualName
		reverseQualityChoices[qualName] = i
	end
	
	local function GetIdFromName(choice)
		
		local charName, server = zo_strsplit("@", choice)
		local data = Dustman_SavedVariables.Default[GetDisplayName()]
		for entryIndex, entryData in pairs(data) do
			local name = entryData["$LastCharacterName"]
			if charName == name and server == entryData.worldname then
				return entryIndex
			end
		end
	end

	local levelChoices = {}
	levelChoices[1] = GetString(SI_NO)
	levelChoices[2] = GetString(SI_ITEM_FORMAT_STR_LEVEL) .. " 16 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:4487:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelChoices[3] = GetString(SI_ITEM_FORMAT_STR_LEVEL) .. " 26 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:23107:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelChoices[4] = GetString(SI_ITEM_FORMAT_STR_LEVEL) .. " 36 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:6000:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelChoices[5] = GetString(SI_ITEM_FORMAT_STR_LEVEL) .. " 46 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:6001:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelChoices[6] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 1 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:46127:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelChoices[7] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 40 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:46128:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelChoices[8] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 70 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:46129:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelChoices[9] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 90 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:46130:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelChoices[10] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 150 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:64489:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	local reverseLevelChoices = {}
	reverseLevelChoices[GetString(SI_NO)] = 1
	reverseLevelChoices[GetString(SI_ITEM_FORMAT_STR_LEVEL) .. " 16 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:4487:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 16
	reverseLevelChoices[GetString(SI_ITEM_FORMAT_STR_LEVEL) .. " 26 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:23107:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 26
	reverseLevelChoices[GetString(SI_ITEM_FORMAT_STR_LEVEL) .. " 36 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:6000:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 36
	reverseLevelChoices[GetString(SI_ITEM_FORMAT_STR_LEVEL) .. " 46 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:6001:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 46
	reverseLevelChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 1 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:46127:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10001
	reverseLevelChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 40 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:46128:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10040
	reverseLevelChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 70 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:46129:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10070
	reverseLevelChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 90 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:46130:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10090
	reverseLevelChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 150 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:64489:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10150
	local valueLevelChoice = {}
	valueLevelChoice[1] = 1
	valueLevelChoice[16] = 2
	valueLevelChoice[26] = 3
	valueLevelChoice[36] = 4
	valueLevelChoice[46] = 5
	valueLevelChoice[10001] = 6
	valueLevelChoice[10040] = 7
	valueLevelChoice[10070] = 8
	valueLevelChoice[10090] = 9
	valueLevelChoice[10150] = 10

	local levelGlyphChoices = {}
	levelGlyphChoices[1] = GetString(SI_NO)
	levelGlyphChoices[2] = GetString(SI_ITEM_FORMAT_STR_LEVEL) .. " 40 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45811:20:45:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45825:20:45:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelGlyphChoices[3] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 1 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45812:125:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45826:125:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelGlyphChoices[4] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 30 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45813:127:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45827:127:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelGlyphChoices[5] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 50 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45814:129:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45828:129:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelGlyphChoices[6] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 70 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45815:131:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45829:131:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelGlyphChoices[7] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 100 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45816:134:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45830:134:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelGlyphChoices[8] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 150 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:64509:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:64508:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelGlyphChoices[9] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 160 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:68341:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:68340:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	local reverseLevelGlyphChoices = {}
	reverseLevelGlyphChoices[GetString(SI_NO)] = 1
	reverseLevelGlyphChoices[GetString(SI_ITEM_FORMAT_STR_LEVEL) .. " 40 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45811:20:45:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45825:20:45:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 40
	reverseLevelGlyphChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 1 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45812:125:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45826:125:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10001
	reverseLevelGlyphChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 30 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45813:127:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45827:127:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10030
	reverseLevelGlyphChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 50 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45814:129:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45828:129:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10050
	reverseLevelGlyphChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 70 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45815:131:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45829:131:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10070
	reverseLevelGlyphChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 100 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45816:134:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:45830:134:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10100
	reverseLevelGlyphChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 150 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:64509:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:64508:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10150
	reverseLevelGlyphChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 160 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:68341:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " & " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:68340:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10160
	local valueLevelGlyphChoice = {}
	valueLevelGlyphChoice[1] = 1
	valueLevelGlyphChoice[40] = 2
	valueLevelGlyphChoice[10001] = 3
	valueLevelGlyphChoice[10030] = 4
	valueLevelGlyphChoice[10050] = 5
	valueLevelGlyphChoice[10070] = 6
	valueLevelGlyphChoice[10100] = 7
	valueLevelGlyphChoice[10150] = 8
	valueLevelGlyphChoice[10160] = 9

	local levelPotionsChoices = {}
	levelPotionsChoices[1] = GetString(SI_NO)
	levelPotionsChoices[2] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 1 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:27036:111:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelPotionsChoices[3] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 50 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:27036:115:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelPotionsChoices[4] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 100 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:27036:120:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	levelPotionsChoices[5] = GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 150 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:27036:307:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
	local reverseLevelPotionsChoices = {}
	reverseLevelPotionsChoices[GetString(SI_NO)] = 1
	reverseLevelPotionsChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 1 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:27036:111:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10001
	reverseLevelPotionsChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 50 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:27036:115:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10050
	reverseLevelPotionsChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 100 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:27036:120:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10100
	reverseLevelPotionsChoices[GetString(SI_ITEM_FORMAT_STR_CHAMPION) .. " 150 - " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:27036:307:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))] = 10150
	local valueLevelPotionsChoice = {}
	valueLevelPotionsChoice[1] = 1
	valueLevelPotionsChoice[10001] = 2
	valueLevelPotionsChoice[10050] = 3
	valueLevelPotionsChoice[10100] = 4
	valueLevelPotionsChoice[10150] = 5
	
	local lowStolenChoices = {[1] = GetString("DUSTMAN_ACT_LOWTREASURE", 1), [2] = GetString("DUSTMAN_ACT_LOWTREASURE", 2), [3] = GetString("DUSTMAN_ACT_LOWTREASURE", 3)}
	local reverseLowStolenChoices = {[GetString("DUSTMAN_ACT_LOWTREASURE", 1)] = 1, [GetString("DUSTMAN_ACT_LOWTREASURE", 2)] = 2, [GetString("DUSTMAN_ACT_LOWTREASURE", 3)] = 3}
	
	local charactersKnown = {}
	if Dustman_SavedVariables and Dustman_SavedVariables.Default and Dustman_SavedVariables.Default[GetDisplayName()] then
		for id, data in pairs(Dustman_SavedVariables.Default[GetDisplayName()]) do
			if data.worldname then
				if not (data.worldname == GetWorldName() and data["$LastCharacterName"] == GetUnitName("player")) then
					table.insert(charactersKnown, data["$LastCharacterName"].."@"..data.worldname)
				end
			end
		end
	end

	local LAM2 = LibStub("LibAddonMenu-2.0")
	local panelData = {
		type = "panel",
		name = GetString(DUSTMAN_TITLE),
		displayName = ZO_HIGHLIGHT_TEXT:Colorize(GetString(DUSTMAN_TITLE)),
		author = "Garkin & Ayantir",
		version = ADDON_VERSION,
		slashCommand = "/dustman",
		registerForRefresh = true,
		registerForDefaults = true,
		website = ADDON_WEBSITE,
	}
	LAM2:RegisterAddonPanel("Dustman_OptionsPanel", panelData)

	local traitSubmenuControls = {}
	table.insert(traitSubmenuControls, {
		type = "checkbox",
		name = GetString(DUSTMAN_FULLSTACK), 
		tooltip = GetString(DUSTMAN_FULLSTACK_DESC),
		getFunc = function() return DustSavedVars.traitFullStack end,
		setFunc = function(state) DustSavedVars.traitFullStack = state end,
		default = defaults.traitFullStack,
	})
	
	local itemsTraitsSubmenuControls = {}
	table.insert(itemsTraitsSubmenuControls, {
		type = "checkbox",
		name = GetString(DUSTMAN_TRAITSSETS), 
		tooltip = GetString(DUSTMAN_TRAITSSETS_DESC),
		getFunc = function() return DustSavedVars.junkTraitSets end,
		setFunc = function(state) DustSavedVars.junkTraitSets = state end,
		default = defaults.junkTraitSets,
		disabled = function() return not DustSavedVars.equipment.enabled end,
	})
	
	for traitItemIndex = 1, GetNumSmithingTraitItems() do
		local traitType, itemName = GetSmithingTraitItemInfo(traitItemIndex)
		local itemLink = GetSmithingTraitItemLink(traitItemIndex, LINK_STYLE_DEFAULT)
		local itemType = GetItemLinkItemType(itemLink)
		if itemType ~= ITEMTYPE_NONE and not (traitType == ITEM_TRAIT_TYPE_NONE or traitType == ITEM_TRAIT_TYPE_WEAPON_NIRNHONED or traitType == ITEM_TRAIT_TYPE_ARMOR_NIRNHONED) then 
			local itemId = select(4, ZO_LinkHandler_ParseLink(itemLink))
			table.insert(traitSubmenuControls, {
				type = "checkbox",
				name = zo_strformat("<<t:1>>", itemName),
				tooltip = zo_strformat("<<1>>: <<2>>", GetString("SI_ITEMTYPE", itemType), GetString("SI_ITEMTRAITTYPE", traitType)),
				getFunc = function() return DustSavedVars.traitMaterial[itemId] end,
				setFunc = function(state) DustSavedVars.traitMaterial[itemId] = state end,
				default = defaults.traitMaterial[itemId],
			})
			table.insert(itemsTraitsSubmenuControls, {
				type = "checkbox",
				name = GetString("SI_ITEMTRAITTYPE", traitType),
				tooltip = zo_strformat("<<1>>: <<2>>", GetString("SI_ITEMTYPE", itemType), GetString("SI_ITEMTRAITTYPE", traitType)),
				getFunc = function() return DustSavedVars.itemTraits[traitType] end,
				setFunc = function(state) DustSavedVars.itemTraits[traitType] = state end,
				default = defaults.itemTraits[traitType],
				disabled = function() return not DustSavedVars.equipment.enabled end,
			})
		end
	end
	
	local styleSubmenuControls = {}
	for styleItemIndex = 1, GetNumSmithingStyleItems() do
		
		local itemName, _, _, meetsUsageRequirement, itemStyle = GetSmithingStyleItemInfo(styleItemIndex)
		local itemLink = GetSmithingStyleItemLink(styleItemIndex, LINK_STYLE_DEFAULT)
		if meetsUsageRequirement and (Dustman.IsRareStyle(itemStyle) or Dustman.IsRareStyle(itemStyle) == false) then
			local itemId = select(4, ZO_LinkHandler_ParseLink(itemLink))
			table.insert(styleSubmenuControls, {
				type = "checkbox",
				name = zo_strformat("<<1>> (<<2>>)", GetString("SI_ITEMSTYLE", itemStyle), zo_strformat(SI_TOOLTIP_ITEM_NAME, itemName)),
				tooltip = zo_strformat("<<1>> (<<2>>)", GetString("SI_ITEMSTYLE", itemStyle), zo_strformat(SI_TOOLTIP_ITEM_NAME, itemName)),
				getFunc = function() return DustSavedVars.styleMaterial[itemId] end,
				setFunc = function(state) DustSavedVars.styleMaterial[itemId] = state end,
				default = defaults.styleMaterial[itemId],
			})
		end
	end
	table.insert(styleSubmenuControls, {
		type = "checkbox",
		name = GetString(DUSTMAN_FULLSTACK), 
		tooltip = GetString(DUSTMAN_FULLSTACK_DESC),
		getFunc = function() return DustSavedVars.styleFullStack end,
		setFunc = function(state) DustSavedVars.styleFullStack = state end,
		default = defaults.styleFullStack,
	})
	
	local optionsData = {
		{
			type = "submenu",
			name = zo_strformat("<<1>> & <<2>>", GetString(SI_ITEMFILTERTYPE1), GetString(SI_ITEMFILTERTYPE2)), --GetString(SI_GAMEPAD_INVENTORY_EQUIPMENT_HEADER)
			controls = {
				{
					type = "checkbox",
					name = GetString(DUSTMAN_EQUIP_NOTRAIT),
					tooltip = GetString(DUSTMAN_EQUIP_NOTRAIT_DESC),
					getFunc = function() return DustSavedVars.equipment.notrait end,
					setFunc = function(state) DustSavedVars.equipment.notrait = state; if state then DustSavedVars.equipment.whiteZeroValue = true end end,
					width = "half",
					default = defaults.equipment.notrait,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.equipment.notraitQuality] end,
					setFunc = function(choice) DustSavedVars.equipment.notraitQuality = reverseQualityChoices[choice] end,
					width = "half",
					disabled = function() return not DustSavedVars.equipment.notrait end,
					default = qualityChoices[defaults.equipment.notraitQuality],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_EQUIPMENT),
					tooltip = GetString(DUSTMAN_EQUIPMENT_DESC),
					getFunc = function() return DustSavedVars.equipment.enabled end,
					setFunc = function(state) DustSavedVars.equipment.enabled = state; if state then DustSavedVars.equipment.whiteZeroValue = true end end,
					width = "half",
					default = defaults.equipment.enabled,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.equipment.equipmentQuality] end,
					setFunc = function(choice) DustSavedVars.equipment.equipmentQuality = reverseQualityChoices[choice] end,
					width = "half",
					disabled = function() return not DustSavedVars.equipment.enabled end,
					default = qualityChoices[defaults.equipment.equipmentQuality],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_ORNATE),
					tooltip = GetString(DUSTMAN_ORNATE_DESC),
					getFunc = function() return DustSavedVars.equipment.ornate end,
					setFunc = function(state) DustSavedVars.equipment.ornate = state end,
					width = "half",
					default = defaults.equipment.ornate,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.equipment.ornateQuality] end,
					setFunc = function(choice) DustSavedVars.equipment.ornateQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.equipment.ornate end,
					width = "half",
					default = qualityChoices[defaults.equipment.ornateQuality],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_BOOSTERS),
					tooltip = GetString(DUSTMAN_BOOSTERS_DESC),
					getFunc = function() return DustSavedVars.smithing.smithingBoosters end,
					setFunc = function(state) DustSavedVars.smithing.smithingBoosters = state end,
					width = "half",
					default = defaults.smithing.smithingBoosters,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.smithing.boosterQuality] end,
					setFunc = function(choice) DustSavedVars.smithing.boosterQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.smithing.smithingBoosters end,
					width = "half",
					default = qualityChoices[defaults.smithing.boosterQuality],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK), 
					tooltip = GetString(DUSTMAN_FULLSTACK_DESC),
					getFunc = function() return DustSavedVars.smithing.boosterFullStack end,
					setFunc = function(state) DustSavedVars.smithing.boosterFullStack = state end,
					disabled = function() return not DustSavedVars.smithing.smithingBoosters end,
					default = defaults.smithing.boosterFullStack,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_WHITE_ZERO),
					tooltip = GetString(DUSTMAN_WHITE_ZERO_DESC),
					getFunc = function() return DustSavedVars.equipment.whiteZeroValue end,
					setFunc = function(state) DustSavedVars.equipment.whiteZeroValue = state end,
					disabled = function() return DustSavedVars.equipment.enabled end,
					default = defaults.equipment.whiteZeroValue,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_RESEARCH),
					tooltip = GetString(DUSTMAN_RESEARCH_DESC),
					getFunc = function() return DustSavedVars.equipment.keepResearchable end,
					setFunc = function(state) DustSavedVars.equipment.keepResearchable = state end,
					disabled = function() return not DustSavedVars.equipment.enabled end,
					default = defaults.equipment.keepResearchable,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_NIRNHONED),
					tooltip = GetString(DUSTMAN_NIRNHONED_DESC),
					getFunc = function() return DustSavedVars.equipment.keepNirnhoned end,
					setFunc = function(state) DustSavedVars.equipment.keepNirnhoned = state end,
					disabled = function() return not DustSavedVars.equipment.enabled end,
					default = defaults.equipment.keepNirnhoned,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_INTRICATE),
					tooltip = GetString(DUSTMAN_INTRICATE_DESC),
					getFunc = function() return DustSavedVars.equipment.keepIntricate end,
					setFunc = function(state) DustSavedVars.equipment.keepIntricate = state end,
					disabled = function() return not DustSavedVars.equipment.enabled end,
					default = defaults.equipment.keepIntricate,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_INTRIC_MAX),
					tooltip = GetString(DUSTMAN_INTRIC_MAX_DESC),
					getFunc = function() return DustSavedVars.equipment.keepIntricateIfNotMaxed end,
					setFunc = function(state) DustSavedVars.equipment.keepIntricateIfNotMaxed = state end,
					disabled = function() return not (DustSavedVars.equipment.enabled and defaults.equipment.keepIntricate) end,
					default = defaults.equipment.keepIntricateIfNotMaxed,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_SET),
					tooltip = GetString(DUSTMAN_SET_DESC),
					getFunc = function() return DustSavedVars.equipment.keepSetItems end,
					setFunc = function(state) DustSavedVars.equipment.keepSetItems = state end,
					disabled = function() return not DustSavedVars.equipment.enabled end,
					default = defaults.equipment.keepSetItems,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_RARE),
					tooltip = GetString(DUSTMAN_RARE_DESC),
					getFunc = function() return DustSavedVars.equipment.keepRareStyle end,
					setFunc = function(state) DustSavedVars.equipment.keepRareStyle = state end,
					disabled = function() return not DustSavedVars.equipment.enabled end,
					default = defaults.equipment.keepRareStyle,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_NCENCHANT),
					tooltip = GetString(DUSTMAN_NCENCHANT_DESC),
					getFunc = function() return DustSavedVars.equipment.keepNCEnchants end,
					setFunc = function(state) DustSavedVars.equipment.keepNCEnchants = state end,
					disabled = function() return not DustSavedVars.equipment.enabled end,
					default = defaults.equipment.keepNCEnchants,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_LEVEL),
					tooltip = GetString(DUSTMAN_LEVEL_DESC),
					choices = levelChoices,
					getFunc = function() return levelChoices[valueLevelChoice[DustSavedVars.equipment.keepLevel]] end,
					setFunc = function(choice)
						if reverseLevelChoices[choice] then
							DustSavedVars.equipment.keepLevel = reverseLevelChoices[choice]
						else
							DustSavedVars.equipment.keepLevel = defaults.equipment.keepLevel
						end
					end,
					disabled = function() return not DustSavedVars.equipment.enabled end,
					default = levelChoices[defaults.equipment.keepLevel],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_LEVEL_ORNATE),
					tooltip = GetString(DUSTMAN_LEVEL_ORNATE_DESC),
					getFunc = function() return DustSavedVars.equipment.keepLevelOrnate end,
					setFunc = function(state) DustSavedVars.equipment.keepLevelOrnate = state end,
					disabled = function() return not DustSavedVars.equipment.ornate or DustSavedVars.equipment.keepLevel == 1 end,
					default = defaults.equipment.keepLevelOrnate,
				},
			},
		},
		{
			type = "submenu",
			name = GetString(SI_GAMEPADITEMCATEGORY38),
			controls = {
				{
					type = "checkbox",
					name = GetString(DUSTMAN_JEWELS_NOTRAIT),
					tooltip = GetString(DUSTMAN_JEWELS_NOTRAIT_DESC),
					getFunc = function() return DustSavedVars.equipment.notraitJewels end,
					setFunc = function(state) DustSavedVars.equipment.notraitJewels = state; if state then DustSavedVars.equipment.whiteZeroValue = true end end,
					default = defaults.equipment.notraitJewels,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_JEWELS),
					tooltip = GetString(DUSTMAN_JEWELS_DESC),
					getFunc = function() return DustSavedVars.equipment.jewelsEnabled end,
					setFunc = function(state) DustSavedVars.equipment.jewelsEnabled = state; if state then DustSavedVars.equipment.whiteZeroValue = true end end,
					width = "half",
					default = defaults.equipment.jewelsEnabled,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.equipment.jewelsQuality] end,
					setFunc = function(choice) DustSavedVars.equipment.jewelsQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.equipment.jewelsEnabled end,
					width = "half",
					default = qualityChoices[defaults.equipment.jewelsQuality],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_ORNATE_JEWELS),
					tooltip = GetString(DUSTMAN_ORNATE_JEWELS_DESC),
					getFunc = function() return DustSavedVars.equipment.jewelsOrnate end,
					setFunc = function(state) DustSavedVars.equipment.jewelsOrnate = state end,
					width = "half",
					default = defaults.equipment.jewelsOrnate,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.equipment.jewelsOrnateQuality] end,
					setFunc = function(choice) DustSavedVars.equipment.jewelsOrnateQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.equipment.jewelsOrnate end,
					width = "half",
					default = qualityChoices[defaults.equipment.jewelsOrnateQuality],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_JEWELS_SET),
					tooltip = GetString(DUSTMAN_JEWELS_SET_DESC),
					getFunc = function() return DustSavedVars.equipment.keepJewelsSetItems end,
					setFunc = function(state) DustSavedVars.equipment.keepJewelsSetItems = state end,
					default = defaults.equipment.keepJewelsSetItems,
					width = "half",
					disabled = function() return not DustSavedVars.equipment.jewelsEnabled end,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY_SUPP),
					tooltip = GetString(DUSTMAN_QUALITY_SUPP_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.equipment.jewelsSetQuality] end,
					setFunc = function(choice) DustSavedVars.equipment.jewelsSetQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.equipment.keepJewelsSetItems end,
					width = "half",
					default = qualityChoices[defaults.equipment.jewelsSetQuality],
				},
			},
		},
		{
			type = "submenu",
			name = zo_strformat("<<1>>", GetString("SI_ITEMTYPE", ITEMTYPE_STYLE_MATERIAL)),
			controls = styleSubmenuControls,
		},
		{
			type = "submenu",
			name = zo_strformat("<<1>> & <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_ARMOR_TRAIT), GetString("SI_ITEMTYPE", ITEMTYPE_WEAPON_TRAIT)),
			controls = traitSubmenuControls,
		},
		{
			type = "submenu",
			name = zo_strformat("<<1>> & <<2>> (<<3>>)", GetString("SI_ITEMTYPE", ITEMTYPE_WEAPON), GetString(SI_SPECIALIZEDITEMTYPE300), GetString(SI_CRAFTING_COMPONENT_TOOLTIP_TRAITS)),
			controls = itemsTraitsSubmenuControls,
		},
		{
			type = "submenu",
			name = GetString(SI_GAMEPADITEMCATEGORY19), --Provisioning
			controls = {
				{
					type = "checkbox",
					name = GetString(DUSTMAN_INGR_ALL),
					tooltip = GetString(DUSTMAN_INGR_ALL_DESC),
					getFunc = function() return DustSavedVars.provisioning.all end,
					setFunc = function(state) DustSavedVars.provisioning.all = state end,
					default = defaults.provisioning.all,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_INGR_UNUS),
					tooltip = GetString(DUSTMAN_INGR_UNUS_DESC),
					getFunc = function() return DustSavedVars.provisioning.unusable end,
					setFunc = function(state) DustSavedVars.provisioning.unusable = state end,
					disabled = function() return DustSavedVars.provisioning.all end, 
					default = defaults.provisioning.unusable,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK), 
					tooltip = GetString(DUSTMAN_FULLSTACK_DESC),
					getFunc = function() return DustSavedVars.provisioning.fullStack end,
					setFunc = function(state) DustSavedVars.provisioning.fullStack = state end,
					default = defaults.provisioning.fullStack,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_INGR_DISH),
					tooltip = GetString(DUSTMAN_INGR_DISH_DESC),
					getFunc = function() return DustSavedVars.provisioning.dish end,
					setFunc = function(state) DustSavedVars.provisioning.dish = state end,
					disabled = function() return not (DustSavedVars.provisioning.all or DustSavedVars.provisioning.unusable) end, 
					default = defaults.provisioning.dish,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_INGR_DRINK),
					tooltip = GetString(DUSTMAN_INGR_DRINK_DESC),
					getFunc = function() return DustSavedVars.provisioning.drink end,
					setFunc = function(state) DustSavedVars.provisioning.drink = state end,
					disabled = function() return not (DustSavedVars.provisioning.all or DustSavedVars.provisioning.unusable) end, 
					default = defaults.provisioning.drink,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_INGR_RARE),
					tooltip = GetString(DUSTMAN_INGR_RARE_DESC),
					getFunc = function() return DustSavedVars.provisioning.excludeRareAdditives end,
					setFunc = function(state) DustSavedVars.provisioning.excludeRareAdditives = state end,
					disabled = function() return not (DustSavedVars.provisioning.all or DustSavedVars.provisioning.unusable) end, 
					default = defaults.provisioning.excludeRareAdditives,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_RECIPE),
					tooltip = GetString(DUSTMAN_RECIPE_DESC),
					getFunc = function() return DustSavedVars.provisioning.recipe end,
					setFunc = function(state) DustSavedVars.provisioning.recipe = state end,
					width = "half",
					default = defaults.provisioning.recipe,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.provisioning.recipeQuality] end,
					setFunc = function(choice) DustSavedVars.provisioning.recipeQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.provisioning.recipe end,
					width = "half",
					default = qualityChoices[defaults.provisioning.recipeQuality],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_INGR_OLD),
					tooltip = GetString(DUSTMAN_INGR_OLD_DESC),
					getFunc = function() return DustSavedVars.provisioning.oldIngredients end,
					setFunc = function(state) DustSavedVars.provisioning.oldIngredients = state end,
					default = defaults.provisioning.oldIngredients,
				},
			},
		},
		{
			type = "submenu",
			name = zo_strformat("<<1>> & <<2>>", GetString(SI_GAMEPADITEMCATEGORY13), GetString("SI_ITEMTYPE", ITEMTYPE_ENCHANTING_RUNE_ASPECT)), --Glyphs
			controls = {
				{
					type = "checkbox",
					name = GetString(DUSTMAN_GLYPHS),
					tooltip = GetString(DUSTMAN_GLYPHS_DESC),
					getFunc = function() return DustSavedVars.glyphs end,
					setFunc = function(state) DustSavedVars.glyphs = state end,
					width = "half",
					default = defaults.glyphs,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.glyphsQuality] end,
					setFunc = function(choice) DustSavedVars.glyphsQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.glyphs end,
					width = "half",
					default = qualityChoices[defaults.glyphsQuality],
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_LEVELGLYPH),
					tooltip = GetString(DUSTMAN_LEVELGLYPH_DESC),
					choices = levelGlyphChoices,
					getFunc = function() return levelGlyphChoices[valueLevelGlyphChoice[DustSavedVars.keepLevelGlyphs]] end,
					setFunc = function(choice)
						if reverseLevelGlyphChoices[choice] then
							DustSavedVars.keepLevelGlyphs = reverseLevelGlyphChoices[choice]
						else
							DustSavedVars.keepLevelGlyphs = defaults.keepLevelGlyphs
						end
					end,
					disabled = function() return not DustSavedVars.glyphs end,
					default = levelGlyphChoices[defaults.keepLevelGlyphs],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_ASPECT_RUNES),
					tooltip = GetString(DUSTMAN_ASPECT_RUNES_DESC),
					getFunc = function() return DustSavedVars.enchanting.enchantingAspect end,
					setFunc = function(state) DustSavedVars.enchanting.enchantingAspect = state end,
					width = "half",
					default = defaults.enchanting.enchantingAspect,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.enchanting.aspectQuality] end,
					setFunc = function(choice) DustSavedVars.enchanting.aspectQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.enchanting.enchantingAspect end,
					width = "half",
					default = qualityChoices[defaults.enchanting.aspectQuality],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK), 
					tooltip = GetString(DUSTMAN_FULLSTACK_DESC),
					getFunc = function() return DustSavedVars.enchanting.aspectFullStack end,
					setFunc = function(state) DustSavedVars.enchanting.aspectFullStack = state end,
					disabled = function() return not DustSavedVars.enchanting.enchantingAspect end,
					default = defaults.enchanting.aspectFullStack,
				},
			},
		},
		{
			type = "submenu",
			name = GetString(SI_ITEMFILTERTYPE3), --Consumable
			controls = {
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FOOD_ALL),
					tooltip = GetString(DUSTMAN_FOOD_ALL_DESC),
					getFunc = function() return DustSavedVars.foodAll end,
					setFunc = function(state) DustSavedVars.foodAll = state end,
					default = defaults.foodAll,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FOOD_BAD),
					tooltip = GetString(DUSTMAN_FOOD_BAD_DESC),
					getFunc = function() return DustSavedVars.food end,
					setFunc = function(state) DustSavedVars.food = state end,
					disabled = function() return DustSavedVars.foodAll end,
					default = defaults.food,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.foodQuality] end,
					setFunc = function(choice) DustSavedVars.foodQuality = reverseQualityChoices[choice] end,
					disabled = function()
							if DustSavedVars.foodAll then
								return false
							elseif DustSavedVars.food then
								return false
							end
							return true
						end,
					default = qualityChoices[defaults.foodQuality],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_TROPHIES),
					tooltip = GetString(DUSTMAN_TROPHIES_DESC),
					getFunc = function() return DustSavedVars.trophies end,
					setFunc = function(state) DustSavedVars.trophies = state end,
					default = defaults.trophies,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_POTIONS),
					tooltip = GetString(DUSTMAN_POTIONS_DESC),
					getFunc = function() return DustSavedVars.potions end,
					setFunc = function(state) DustSavedVars.potions = state end,
					default = defaults.potions,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK_BAG),
					tooltip = GetString(DUSTMAN_FULLSTACK_BAG_DESC),
					getFunc = function() return DustSavedVars.fullStackBagPotions end,
					setFunc = function(state) DustSavedVars.fullStackBagPotions = state end,
					default = defaults.fullStackBagPotions,
					disabled = function() return not DustSavedVars.potions end,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK),
					tooltip = GetString(DUSTMAN_FULLSTACK_DESC),
					getFunc = function() return DustSavedVars.fullStackBankPotions end,
					setFunc = function(state) DustSavedVars.fullStackBankPotions = state end,
					default = defaults.fullStackBankPotions,
					disabled = function() return not DustSavedVars.potions end,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_LEVELPOTIONS),
					tooltip = GetString(DUSTMAN_LEVELPOTIONS_DESC),
					choices = levelPotionsChoices,
					getFunc = function() return levelPotionsChoices[valueLevelPotionsChoice[DustSavedVars.keepPotionsLevel]] end,
					setFunc = function(choice)
						if reverseLevelPotionsChoices[choice] then
							DustSavedVars.keepPotionsLevel = reverseLevelPotionsChoices[choice]
						else
							DustSavedVars.keepPotionsLevel = defaults.keepPotionsLevel
						end
					end,
					disabled = function() return not DustSavedVars.potions end,
					default = levelPotionsChoices[defaults.keepPotionsLevel],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_POISONS),
					tooltip = GetString(DUSTMAN_POISONS_DESC),
					getFunc = function() return DustSavedVars.poisons end,
					setFunc = function(state) DustSavedVars.poisons = state end,
					default = defaults.poisons,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK_BAG),
					tooltip = GetString(DUSTMAN_FULLSTACK_BAG_DESC),
					getFunc = function() return DustSavedVars.fullStackBagPoisons end,
					setFunc = function(state) DustSavedVars.fullStackBagPoisons = state end,
					default = defaults.fullStackBagPoisons,
					disabled = function() return not DustSavedVars.poisons end,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK),
					tooltip = GetString(DUSTMAN_FULLSTACK_DESC),
					getFunc = function() return DustSavedVars.fullStackBankPoisons end,
					setFunc = function(state) DustSavedVars.fullStackBankPoisons = state end,
					default = defaults.fullStackBankPoisons,
					disabled = function() return not DustSavedVars.poisons end,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_LEVELPOISONS),
					tooltip = GetString(DUSTMAN_LEVELPOISONS_DESC),
					choices = levelPotionsChoices,
					getFunc = function() return levelPotionsChoices[valueLevelPotionsChoice[DustSavedVars.keepPoisonsLevel]] end,
					setFunc = function(choice)
						if reverseLevelPotionsChoices[choice] then
							DustSavedVars.keepPoisonsLevel = reverseLevelPotionsChoices[choice]
						else
							DustSavedVars.keepPoisonsLevel = defaults.keepPoisonsLevel
						end
					end,
					disabled = function() return not DustSavedVars.poisons end,
					default = levelPotionsChoices[defaults.keepPoisonsLevel],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_POISONS_SOLVANTS),
					tooltip = GetString(DUSTMAN_POISONS_SOLVANTS_DESC),
					getFunc = function() return DustSavedVars.poisonsSolvants end,
					setFunc = function(state) DustSavedVars.poisonsSolvants = state end,
					default = defaults.poisonsSolvants,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK_BAG),
					tooltip = GetString(DUSTMAN_FULLSTACK_BAG_DESC),
					getFunc = function() return DustSavedVars.fullStackBagPoisonsSolvants end,
					setFunc = function(state) DustSavedVars.fullStackBagPoisonsSolvants = state end,
					default = defaults.fullStackBagPoisonsSolvants,
					disabled = function() return not DustSavedVars.poisonsSolvants end,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK),
					tooltip = GetString(DUSTMAN_FULLSTACK_DESC),
					getFunc = function() return DustSavedVars.fullStackBankPoisonsSolvants end,
					setFunc = function(state) DustSavedVars.fullStackBankPoisonsSolvants = state end,
					default = defaults.fullStackBankPoisonsSolvants,
					disabled = function() return not DustSavedVars.poisonsSolvants end,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_EMPTYGEMS),
					tooltip = GetString(DUSTMAN_EMPTYGEMS_DESC),
					getFunc = function() return DustSavedVars.emptyGems end,
					setFunc = function(state) DustSavedVars.emptyGems = state end,
					default = defaults.emptyGems,
				},
			},
		},
		{
			type = "submenu",
			name = GetString(SI_GAMECAMERAACTIONTYPE16), --Fish
			controls = {
				{
					type = "checkbox",
					name = GetString(DUSTMAN_LURE),
					tooltip = GetString(DUSTMAN_LURE_DESC),
					getFunc = function() return DustSavedVars.lure end,
					setFunc = function(state) DustSavedVars.lure = state end,
					default = defaults.lure,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK_BAG),
					tooltip = GetString(DUSTMAN_FULLSTACK_BAG_DESC),
					getFunc = function() return DustSavedVars.lureFullStack end,
					setFunc = function(state) DustSavedVars.lureFullStack = state end,
					default = defaults.lureFullStack,
					disabled = function() return not DustSavedVars.lure end,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FULLSTACK),
					tooltip = GetString(DUSTMAN_FULLSTACK_DESC),
					getFunc = function() return DustSavedVars.lureFullStackBank end,
					setFunc = function(state) DustSavedVars.lureFullStackBank = state end,
					default = defaults.lureFullStackBank,
					disabled = function() return not DustSavedVars.lure end,
				},
				{
					 type = "checkbox",
					 name = GetString(DUSTMAN_TROPHY),
					 tooltip = GetString(DUSTMAN_TROPHY_DESC),
					 getFunc = function() return DustSavedVars.trophy end,
					 setFunc = function(state) DustSavedVars.trophy = state end,
					 default = defaults.trophy,
				 },
			},
		},
		{
			type = "submenu",
			name =  GetString(SI_HOUSING_BOOK_TITLE),
			controls = {
				{
					type = "checkbox",
					name = GetString(DUSTMAN_HOUSING_RECIPES),
					tooltip = GetString(DUSTMAN_HOUSING_RECIPES_DESC),
					getFunc = function() return DustSavedVars.housingRecipes end,
					setFunc = function(state) DustSavedVars.housingRecipes = state end,
					width = "half",
					default = defaults.housingRecipes,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.housingRecipesQuality] end,
					setFunc = function(choice) DustSavedVars.housingRecipesQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.housingRecipes end,
					width = "half",
					default = qualityChoices[defaults.housingRecipesQuality],
				},
			},
		},
		{
			type = "submenu", -- Stolen
			name = GetString(SI_GAMEPAD_ITEM_STOLEN_LABEL),
			controls = {
				{
					type = "checkbox",
					name = GetString(DUSTMAN_STOLEN),
					tooltip = GetString(DUSTMAN_STOLEN_DESC),
					width = "half",
					getFunc = function() return DustSavedVars.stolen end,
					setFunc = function(state) DustSavedVars.stolen = state end,
					default = defaults.stolen,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY_SUPP),
					tooltip = GetString(DUSTMAN_QUALITY_SUPP_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.stolenQuality] end,
					setFunc = function(choice) DustSavedVars.stolenQuality = reverseQualityChoices[choice] end,
					width = "half",
					disabled = function() return not DustSavedVars.stolen end,
					default = qualityChoices[defaults.stolenQuality],
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_ACT_LOWTREASURES),
					tooltip = GetString(DUSTMAN_ACT_LOWTREASURES_DESC),
					choices = lowStolenChoices,
					getFunc = function() return lowStolenChoices[DustSavedVars.lowStolen] end,
					setFunc = function(choice)
						DustSavedVars.lowStolen = reverseLowStolenChoices[choice]
						DustSavedVars.excludeLaunder[ITEMTYPE_TREASURE] = (choice == lowStolenChoices[2])
					end,
					disabled = function()
							if	DustSavedVars.stolen and DustSavedVars.stolenQuality > defaults.stolenQuality then return false end
							return true
						end,
					default = lowStolenChoices[defaults.lowStolen],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_STOLEN_LAUNDER),
					tooltip = GetString(DUSTMAN_STOLEN_LAUNDER_DESC),
					getFunc = function() return DustSavedVars.launder end,
					setFunc = function(state) DustSavedVars.launder = state end,
					default = defaults.launder,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_STOLEN_CLOTHES),
					tooltip = GetString(DUSTMAN_STOLEN_CLOTHES_DESC),
					getFunc = function() return DustSavedVars.excludeStolenClothes end,
					setFunc = function(state) DustSavedVars.excludeStolenClothes = state end,
					default = defaults.excludeStolenClothes,
				},
				{
					type = "checkbox",
					name = zo_strformat(GetString(DUSTMAN_NOLAUNDER), GetString("SI_ITEMTYPE", ITEMTYPE_SOUL_GEM)),
				  tooltip = zo_strformat(GetString(DUSTMAN_NOLAUNDER_DESC), GetString("SI_ITEMTYPE", ITEMTYPE_SOUL_GEM)),
					getFunc = function() return DustSavedVars.excludeLaunder[ITEMTYPE_SOUL_GEM] end,
					setFunc = function(state) DustSavedVars.excludeLaunder[ITEMTYPE_SOUL_GEM] = state end,
					default = defaults.excludeLaunder[ITEMTYPE_SOUL_GEM],
				},
				{
					type = "checkbox",
					name = zo_strformat(GetString(DUSTMAN_NOLAUNDER), GetString("SI_ITEMTYPE", ITEMTYPE_LOCKPICK)), -- Better to understand
					tooltip = zo_strformat(GetString(DUSTMAN_NOLAUNDER_DESC), GetString("SI_ITEMTYPE", ITEMTYPE_LOCKPICK)),
					getFunc = function() return DustSavedVars.excludeLaunder[ITEMTYPE_TOOL] end,
					setFunc = function(state) DustSavedVars.excludeLaunder[ITEMTYPE_TOOL] = state end,
					default = defaults.excludeLaunder[ITEMTYPE_TOOL],
				},
				{
					type = "checkbox",
					name = zo_strformat(GetString(DUSTMAN_NOLAUNDER), GetString("SI_ITEMTYPE", ITEMTYPE_POTION_BASE)),
					tooltip = zo_strformat(GetString(DUSTMAN_NOLAUNDER_DESC), GetString("SI_ITEMTYPE", ITEMTYPE_POTION_BASE)),
					getFunc = function() return DustSavedVars.excludeLaunder[ITEMTYPE_POTION_BASE] end,
					setFunc = function(state) DustSavedVars.excludeLaunder[ITEMTYPE_POTION_BASE] = state end,
					default = defaults.excludeLaunder[ITEMTYPE_POTION_BASE],
				},
				{
					type = "checkbox",
					name = zo_strformat(GetString(DUSTMAN_NOLAUNDER), GetString("SI_ITEMTYPE", ITEMTYPE_POISON_BASE)),
					tooltip = zo_strformat(GetString(DUSTMAN_NOLAUNDER_DESC), GetString("SI_ITEMTYPE", ITEMTYPE_POISON_BASE)),
					getFunc = function() return DustSavedVars.excludeLaunder[ITEMTYPE_POISON_BASE] end,
					setFunc = function(state) DustSavedVars.excludeLaunder[ITEMTYPE_POISON_BASE] = state end,
					default = defaults.excludeLaunder[ITEMTYPE_POISON_BASE],
				},
				{
					type = "checkbox",
					name = zo_strformat(GetString(DUSTMAN_NOLAUNDER), GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT)),
					tooltip = zo_strformat(GetString(DUSTMAN_NOLAUNDER_DESC), GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT)),
					getFunc = function() return DustSavedVars.excludeLaunder[ITEMTYPE_INGREDIENT] end,
					setFunc = function(state) DustSavedVars.excludeLaunder[ITEMTYPE_INGREDIENT] = state end,
					default = defaults.excludeLaunder[ITEMTYPE_INGREDIENT],
				},
				{
					type = "checkbox",
					name = zo_strformat(GetString(DUSTMAN_NOLAUNDER), GetString("SI_ITEMTYPE", ITEMTYPE_FOOD)),
					tooltip = zo_strformat(GetString(DUSTMAN_NOLAUNDER_DESC), GetString("SI_ITEMTYPE", ITEMTYPE_FOOD)),
					getFunc = function() return DustSavedVars.excludeLaunder[ITEMTYPE_FOOD] end,
					setFunc = function(state) DustSavedVars.excludeLaunder[ITEMTYPE_FOOD] = state end,
					default = defaults.excludeLaunder[ITEMTYPE_FOOD],
				},
				{
					type = "checkbox",
					name = zo_strformat(GetString(DUSTMAN_NOLAUNDER), GetString("SI_ITEMTYPE", ITEMTYPE_DRINK)),
					tooltip = zo_strformat(GetString(DUSTMAN_NOLAUNDER_DESC), GetString("SI_ITEMTYPE", ITEMTYPE_DRINK)),
					getFunc = function() return DustSavedVars.excludeLaunder[ITEMTYPE_DRINK] end,
					setFunc = function(state) DustSavedVars.excludeLaunder[ITEMTYPE_DRINK] = state end,
					default = defaults.excludeLaunder[ITEMTYPE_DRINK],
				},
				{
					type = "checkbox",
					name = zo_strformat(GetString(DUSTMAN_NOLAUNDER), GetString("SI_ITEMTYPE", ITEMTYPE_STYLE_MATERIAL)),
					tooltip = zo_strformat(GetString(DUSTMAN_NOLAUNDER_DESC), GetString("SI_ITEMTYPE", ITEMTYPE_STYLE_MATERIAL)),
					getFunc = function() return DustSavedVars.excludeLaunder[ITEMTYPE_STYLE_MATERIAL] end,
					setFunc = function(state) DustSavedVars.excludeLaunder[ITEMTYPE_STYLE_MATERIAL] = state end,
					default = defaults.excludeLaunder[ITEMTYPE_STYLE_MATERIAL],
				},
				{
					type = "checkbox",
					name = zo_strformat(GetString(DUSTMAN_NOLAUNDER), GetString("SI_ITEMTYPE", ITEMTYPE_TRASH)),
					tooltip = zo_strformat(GetString(DUSTMAN_NOLAUNDER_DESC), GetString("SI_ITEMTYPE", ITEMTYPE_TRASH)),
					getFunc = function() return DustSavedVars.excludeLaunder[ITEMTYPE_TRASH] end,
					setFunc = function(state) DustSavedVars.excludeLaunder[ITEMTYPE_TRASH] = state end,
					default = defaults.excludeLaunder[ITEMTYPE_TRASH],
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_NON_LAUNDERED),
					tooltip = GetString(DUSTMAN_NON_LAUNDERED_DESC),
					getFunc = function() return DustSavedVars.destroyNonLaundered end,
					setFunc = function(state) DustSavedVars.destroyNonLaundered = state end,
					default = defaults.destroyNonLaundered,
				},
			},
		},
		{
			type = "submenu", -- Destroy
			name = GetString(SI_ITEM_ACTION_DESTROY),
			controls = {
				{
					type = "checkbox",
					name = GetString(DUSTMAN_DESTROY),
					tooltip = GetString(DUSTMAN_DESTROY_DESC),
					getFunc = function() return DustSavedVars.destroy end,
					setFunc = function(state) DustSavedVars.destroy = state end,
					default = defaults.destroy,
				},
				{
					type = "slider",
					name = GetString(DUSTMAN_DESTROY_VAL),
					tooltip = GetString(DUSTMAN_DESTROY_VAL_DESC),
					min = 0,
					max = 200,
					getFunc = function() return DustSavedVars.destroyValue end,
					setFunc = function(value) DustSavedVars.destroyValue = value end,
					disabled = function() return not DustSavedVars.destroy end,
					default = defaults.destroyValue,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.destroyQuality] end,
					setFunc = function(choice) DustSavedVars.destroyQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.destroy end,
					default = qualityChoices[defaults.destroyQuality]
				},
				{
					type = "slider",
					name = GetString(DUSTMAN_DESTROY_STOLEN),
					tooltip = GetString(DUSTMAN_DESTROY_STOLEN_DESC),
					min = 0,
					max = 500,
					getFunc = function() return DustSavedVars.destroyStolenValue end,
					setFunc = function(value) DustSavedVars.destroyStolenValue = value end,
					disabled = function() return not DustSavedVars.destroy end,
					default = defaults.destroyStolenValue,
				},
				{
					type = "dropdown",
					name = GetString(DUSTMAN_QUALITY),
					tooltip = GetString(DUSTMAN_QUALITY_DESC),
					choices = qualityChoices,
					getFunc = function() return qualityChoices[DustSavedVars.destroyStolenQuality] end,
					setFunc = function(choice) DustSavedVars.destroyStolenQuality = reverseQualityChoices[choice] end,
					disabled = function() return not DustSavedVars.destroy end,
					default = qualityChoices[defaults.destroyStolenQuality]
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_DESTROY_STACK),
					tooltip = GetString(DUSTMAN_DESTROY_STACK_DESC),
					getFunc = function() return DustSavedVars.destroyExcludeStackable end,
					setFunc = function(state) DustSavedVars.destroyExcludeStackable = state end,
					default = defaults.destroyExcludeStackable,
				},
			},
		},
		{
			type = "submenu",
			name = GetString(SI_MAIN_MENU_NOTIFICATIONS),
			controls = {
				{
					type = "checkbox",
					name = GetString(DUSTMAN_VERBOSE),
					tooltip = GetString(DUSTMAN_VERBOSE_DESC),
					getFunc = function() return DustSavedVars.notifications.verbose end,
					setFunc = function(state) DustSavedVars.notifications.verbose = state end,
					default = defaults.notifications.verbose
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_FOUND),
					tooltip = GetString(DUSTMAN_FOUND_DESC),
					getFunc = function() return DustSavedVars.notifications.found end,
					setFunc = function(state) DustSavedVars.notifications.found = state end,
					default = defaults.notifications.found
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_ALLITEMS),
					tooltip = GetString(DUSTMAN_ALLITEMS_DESC),
					getFunc = function() return DustSavedVars.notifications.allItems end,
					setFunc = function(state) DustSavedVars.notifications.allItems = state end,
					default = defaults.notifications.allItems
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_TOTAL),
					tooltip = GetString(DUSTMAN_TOTAL_DESC),
					getFunc = function() return DustSavedVars.notifications.total end,
					setFunc = function(state) DustSavedVars.notifications.total = state end,
					default = defaults.notifications.total
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_CONFIRM),
					tooltip = GetString(DUSTMAN_CONFIRM_DESC),
					getFunc = function() return DustSavedVars.notifications.sellDialog end,
					setFunc = function(state) DustSavedVars.notifications.sellDialog = state end,
					default = defaults.notifications.sellDialog,
				},
				{
					type = "checkbox",
					name = GetString(DUSTMAN_DONTSELL),
					tooltip = GetString(DUSTMAN_DONTSELL_DESC),
					getFunc = function() return DustSavedVars.notifications.sell end,
					setFunc = function(state) DustSavedVars.notifications.sell = state end,
					default = defaults.notifications.sell,
				},
			},
		},
		{
			type = "checkbox",
			name = GetString(DUSTMAN_REMEMBER),
			tooltip = GetString(DUSTMAN_REMEMBER_DESC),
			getFunc = function() return DustSavedVars.memory end,
			setFunc = function(state) DustSavedVars.memory = state end,
			default = defaults.memory,
		},
		{
			type = "checkbox",
			name = GetString(DUSTMAN_MEMORYFIRST),
			tooltip = GetString(DUSTMAN_MEMORYFIRST_DESC),
			getFunc = function() return DustSavedVars.useMemoryFirst end,
			setFunc = function(state) DustSavedVars.useMemoryFirst = state end,
			disabled = function() return not DustSavedVars.memory end,
			default = defaults.useMemoryFirst,
		},
		{
			type = "dropdown",
			name = GetString(DUSTMAN_IMPORT),
			tooltip = GetString(DUSTMAN_IMPORT_DESC),
			choices = charactersKnown,
			width = "full",
			getFunc = function() return GetUnitName('player') end,
			warning = "ReloadUI",
			setFunc = function(choice)
			
				local playerId = GetCurrentCharacterId()
				local referenceId = GetIdFromName(choice)
				
				if referenceId then
					
					for entryIndex, entryData in pairs(Dustman_SavedVariables.Default[GetDisplayName()][referenceId]) do
						if entryIndex ~= "$LastCharacterName" then
							DustSavedVars[entryIndex] = entryData
							Dustman_SavedVariables.Default[GetDisplayName()][playerId][entryIndex] = entryData
						end
					end
					
					SCENE_MANAGER:ShowBaseScene()
					CHAT_SYSTEM:AddMessage(zo_strformat(DUSTMAN_IMPORTED, choice))
					
					zo_callLater(function() ReloadUI() end, 2000)
					
				end
			end,
		},
		{
			type = "button",
			name = GetString(DUSTMAN_SWEEP),
			tooltip = GetString(DUSTMAN_SWEEP_DESC),
			func = function() Dustman.Sweep() end,
			width = "half",
		},
		{
			type = "button",
			name = GetString(DUSTMAN_CLEAR_MARKED),
			tooltip = GetString(DUSTMAN_CLEAR_MARKED_DESC),
			func = function() Dustman.ClearMarkedAsJunk() end,
			width = "half",
		},	
	}
	LAM2:RegisterOptionControls("Dustman_OptionsPanel", optionsData)
end