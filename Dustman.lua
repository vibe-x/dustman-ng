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

-- Leaked for menu & data
Dustman = {}

local ADDON_NAME = "Dustman"

-- Libraries ------------------------------------------------------------------
local LR = LibStub("libResearch-2")

-- Local variables ------------------------------------------------------------
local usableIngredients = {}
local savedVars
local markedAsJunk = {}

local WAILING_PRISON_ZONE = 586
local TUTORIAL_ACHIEVEMENT = 993
local inventorySingleSlotUpdate

local defaults = {
	worldname = GetWorldName(),
	--equipable items
	equipment = {
		notrait = false,
		notraitQuality = ITEM_QUALITY_NORMAL,
		enabled = false,
		equipmentQuality = ITEM_QUALITY_NORMAL,
		ornate = true,
		ornateQuality = ITEM_QUALITY_MAGIC,
		whiteZeroValue = false,
		keepIntricate = true,
		keepIntricateIfNotMaxed = false,
		keepResearchable = true,
		keepNirnhoned = true,
		keepSetItems = true,
		keepRareStyle = false,
		keepNCEnchants = true,
		keepLevel = 1,
		keepLevelOrnate = false,
		--jewels
		notraitJewels = false,
		jewelsEnabled = false,
		jewelsQuality = ITEM_QUALITY_NORMAL,
		jewelsOrnate = true,
		jewelsOrnateQuality = ITEM_QUALITY_MAGIC,
		keepJewelsSetItems = true,
		jewelsSetQuality = ITEM_QUALITY_MAGIC,
	},
	--provisioning
	provisioning = {
		recipe = false,
		recipeQuality = ITEM_QUALITY_MAGIC,
		unusable = false,
		all = false,
		dish = true,
		drink = true,
		excludeRareAdditives = true,
		fullStack = false,
		oldIngredients = true,
	},
	--glyphs
	glyphs = false,
	glyphsQuality = ITEM_QUALITY_NORMAL,
	keepLevelGlyphs = 1,
	--food/drink
	food = false,
	foodAll = false,
	foodQuality = ITEM_QUALITY_NORMAL,
	--fishing
	lure = false,
	lureFullStack = false,
	lureFullStackBank = false,
	trophy = false,
	trophies = false,
	-- Smithing
	smithing = {
		smithingBoosters = false,
		boosterQuality = ITEM_QUALITY_MAGIC,
		boosterFullStack = false,
	},
	-- Enchanting
	enchanting = {
		enchantingAspect = false,
		aspectQuality = ITEM_QUALITY_NORMAL,
		aspectFullStack = false,
	},
	--potions
	potions = false,
	fullStackBagPotions = false,
	fullStackBankPotions = false,
	keepPotionsLevel = 1,
	--poisons
	poisons = false,
	fullStackBagPoisons = false,
	fullStackBankPoisons = false,
	poisonsSolvants = false,
	fullStackBagPoisonsSolvants = false,
	fullStackBankPoisonsSolvants = false,
	keepPoisonsLevel = 1,
	-- soul gems
	emptyGems = false,
	-- treasures
	treasures = false,
	--style
	styleMaterial = {
		["33252"] = false, --Adamantite (Altmer)
		["46150"] = false, --Argentum (Primal)
		["33194"] = false, --Bone (Bosmer)
		["46149"] = false, --Copper (Barbaric)
		["33256"] = false, --Corundum (Nord)
		["46151"] = false, --Daedra Heart (Daedric)
		["57665"] = false, --Dwemer Scrap (Dwemer)
		["33150"] = false, --Flint (Argonian)
		["33257"] = false, --Manganese (Orc)
		["33251"] = false, --Molybdenum (Breton)
		["33255"] = false, --Moonstone (Khajiit)
		["33254"] = false, --Nickel (Imperial)
		["33253"] = false, --Obsidian (Dunmer)
		["46152"] = false, --Palladium (Ancient Elf)
		["33258"] = false, --Starmetal (Redguard)
	},
	--traits
	traitMaterial = {
		--armor traits
		["23221"] = false, --Almandine (Well-Fitted) 
		["30219"] = false, --Bloodstone (Infused) 
		["23219"] = false, --Diamond (Impenetrable)
		["4442"]  = false, --Emerald (Training) 
		["23171"] = false, --Garnet (Exploration)
		["4456"]  = false, --Quartz (Sturdy) 
		["23173"] = false, --Sapphire (Divines) 
		["30221"] = false, --Sardonyx (Reinforced)
		--weapon traits
		["23204"] = false, --Amethyst (Charged) 
		["23165"] = false, --Carnelian (Training) 
		["23203"] = false, --Chysolite (Powered)
		["16291"] = false, --Citrine (Weighted)
		["23149"] = false, --Fire Opal (Sharpened)
		["810"]	= false, --Jade (Infused)
		["4486"]  = false, --Ruby (Precise)
		["813"]	= false, --Turquoise (Defending)
	},
	itemTraits = {
		[ITEM_TRAIT_TYPE_ARMOR_DIVINES] = false,
		[ITEM_TRAIT_TYPE_ARMOR_EXPLORATION] = false,
		[ITEM_TRAIT_TYPE_ARMOR_IMPENETRABLE] = false,
		[ITEM_TRAIT_TYPE_ARMOR_INFUSED] = false,
		[ITEM_TRAIT_TYPE_ARMOR_PROSPEROUS] = false,
		[ITEM_TRAIT_TYPE_ARMOR_REINFORCED] = false,
		[ITEM_TRAIT_TYPE_ARMOR_STURDY] = false,
		[ITEM_TRAIT_TYPE_ARMOR_TRAINING] = false,
		[ITEM_TRAIT_TYPE_ARMOR_WELL_FITTED] = false,
		[ITEM_TRAIT_TYPE_WEAPON_CHARGED] = false,
		[ITEM_TRAIT_TYPE_WEAPON_DECISIVE] = false,
		[ITEM_TRAIT_TYPE_WEAPON_DEFENDING] = false,
		[ITEM_TRAIT_TYPE_WEAPON_INFUSED] = false,
		[ITEM_TRAIT_TYPE_WEAPON_POWERED] = false,
		[ITEM_TRAIT_TYPE_WEAPON_PRECISE] = false,
		[ITEM_TRAIT_TYPE_WEAPON_SHARPENED] = false,
		[ITEM_TRAIT_TYPE_WEAPON_TRAINING] = false,
		[ITEM_TRAIT_TYPE_WEAPON_WEIGHTED] = false,
	},
	junkTraitSets = false,
	styleFullStack = false,
	traitFullStack = false,
	--destroy items
	destroy = false,
	destroyExcludeStackable = false,
	destroyValue = 0,
	destroyQuality = ITEM_QUALITY_NORMAL,
	destroyStolenValue = 0,
	destroyStolenQuality = ITEM_QUALITY_NORMAL,
	--notifications
	notifications = {
		verbose = false,
		found = false,
		allItems = true,
		total = true,
		sellDialog = true,
		sell = true,
	},
	--stolen items
	stolen = false,
	lowStolen = 1,
	excludeStolenClothes = true,
	launder = false,
	stolenQuality = ITEM_QUALITY_NORMAL,
	excludeLaunder = {
		[ITEMTYPE_SOUL_GEM] = false,
		[ITEMTYPE_TOOL] = false,
		[ITEMTYPE_POTION_BASE] = false,
		[ITEMTYPE_POISON_BASE] = false,
		[ITEMTYPE_INGREDIENT] = false,
		[ITEMTYPE_STYLE_MATERIAL] = false,
		[ITEMTYPE_FOOD] = false,
		[ITEMTYPE_DRINK] = false,
		[ITEMTYPE_TRASH] = false,
		[ITEMTYPE_TREASURE] = false,
	},
	destroyNonLaundered = false,
	--remember user marked junk
	memory = false,
	useMemoryFirst = false,
	housingRecipe = false,
	housingRecipesQuality = ITEM_QUALITY_NORMAL,
}

-- Local functions ------------------------------------------------------------
local function MyPrint(message)
	CHAT_SYSTEM:AddMessage(message)
end

local function BuildUsableIngredientsList()
	local RECIPE_LIST_INDEX_MAX_PROVISIONNER = 16
	for recipeListIndex = 1, RECIPE_LIST_INDEX_MAX_PROVISIONNER do -- 16 provisionning, after it's housing
		local _, numRecipes = GetRecipeListInfo(recipeListIndex)
		for recipeIndex = 1, numRecipes do
			local known, _, numIngredients, _, _, _  = GetRecipeInfo(recipeListIndex, recipeIndex)
			for ingredientIndex = 1, numIngredients do
				local link = GetRecipeIngredientItemLink(recipeListIndex, recipeIndex, ingredientIndex, LINK_STYLE_DEFAULT)
				if link ~= "" then
					local itemId = select(4, ZO_LinkHandler_ParseLink(link))
					if itemId then
						usableIngredients[itemId] = known
					end
				end
			end
		end
	end
end

local function IsFullStackInBag(BackPackSlotId, bagId, itemLink)
	local stackCountBackpack, stackCountBank, stackCountCraftBag = GetItemLinkStacks(itemLink)
	local _, maxStack = GetSlotStackSize(BAG_BACKPACK, BackPackSlotId)
	if bagId == BAG_BACKPACK then
		return stackCountBackpack >= maxStack
	elseif bagId == BAG_BANK then
		return stackCountBank + stackCountCraftBag >= maxStack
	end
end

local function IsItemProtected(bagId, slotId)

	-- ESOUI
	if IsItemPlayerLocked(bagId, slotId) then
		return true
	end

	--Item Saver support
	if ItemSaver_IsItemSaved and ItemSaver_IsItemSaved(bagId, slotId) then
		return true
	end

	--FCO ItemSaver support
	if FCOIS then
		--FCOIS version <1.0.0
		if FCOIsMarked then
			local FCOiconsToCheck = {}
			--Build icons to check table, and don't add the "coin" icon, because these items should be sold
			for i=1, FCOIS.numVars.gFCONumFilterIcons, 1 do
				if i ~= FCOIS_CON_ICON_SELL then
					FCOiconsToCheck[i] = i
				end
			end
			return FCOIsMarked(GetItemInstanceId(bagId, slotId), FCOiconsToCheck)
		else
			--FCOIS version 1.0.0 and higher
			--Check all marker icons but exclude the icon #5 (Coins symbol = item marked to sell) and check dynamic icons if sell is allowed
			if FCOIS.IsJunkLocked then
				return FCOIS.IsJunkLocked(bagId, slotId)
			end
		end
	end

	--FilterIt support
	if FilterIt and FilterIt.AccountSavedVariables and FilterIt.AccountSavedVariables.FilteredItems then
		local sUniqueId = Id64ToString(GetItemUniqueId(bagId, slotId))
		if FilterIt.AccountSavedVariables.FilteredItems[sUniqueId] then
			return FilterIt.AccountSavedVariables.FilteredItems[sUniqueId] ~= FILTERIT_VENDOR
		end
	end

	return false
	
end

local function IsItemNeededForResearch(itemLink)

	--CraftStore 3.30 support
	if CS and CS.GetTrait and CS.account and CS.account.crafting then
		local craft, row, trait = CS.GetTrait(itemLink)
		-- Loop all chars known by CS
		for char, data in pairs(CS.account.crafting.studies) do
			--if a char study this item
			if data[craft] and data[craft][row] and (data[craft][row]) then
				-- If this char didn't yet researched this item
				if CS.account.crafting.research[char][craft] and CS.account.crafting.research[char][craft][row] and CS.account.crafting.research[char][craft][row][trait] == false then
					return true
				end
			end
		end
		return false
	end

	--libResearch
	local _, isResearchable = LR:GetItemTraitResearchabilityInfo(itemLink)
	return isResearchable
end

local function pairsByQuality(bagCache)

	local arraySorted = {}
	for key, data in pairs(bagCache) do table.insert(arraySorted, data) end
	
	local function sortByPosition(a, b)
		return a.quality > b.quality
	end
	
	table.sort(arraySorted, sortByPosition)
	
	return arraySorted
	
end

local function SellJunkItems(isFence)
	
	if GetInteractionType() == INTERACTION_VENDOR then
		
		local total = 0
		local count = 0
		local transactions = 0
		local transactionsMessage = true
		local hagglingBonus, hasHagglingBonus
		
		local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
		
		if isFence then
			hagglingBonus = GetNonCombatBonus(NON_COMBAT_BONUS_HAGGLING)
			hasHagglingBonus = hagglingBonus > 0
			bagCache = pairsByQuality(bagCache)
		end
		
		for slotId, data in pairs(bagCache) do
			if transactions < 98 then
				if data.isJunk then
					if data.stolen == isFence then
						if isFence then
							local totalSells, sellsUsed = GetFenceSellTransactionInfo()
							if sellsUsed == totalSells then
								ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.NEGATIVE_CLICK, GetString("SI_STOREFAILURE", STORE_FAILURE_AT_FENCE_LIMIT))
								if total > 0 and savedVars.notifications.total then
									MyPrint(zo_strformat(DUSTMAN_FORMAT_TOTAL, count, total))
								end
								return
							end
						end
						local name = GetItemLink(BAG_BACKPACK, data.slotIndex)
						
						if IsItemProtected(BAG_BACKPACK, data.slotIndex) then
							SetItemIsJunk(BAG_BACKPACK, data.slotIndex, false)
							MyPrint(zo_strformat(DUSTMAN_FORMAT_NOTSOLD, name))
						else
							SellInventoryItem(BAG_BACKPACK, data.slotIndex, data.stackCount)

							local sellPrice = data.sellPrice
							if isFence and hasHagglingBonus then
								sellPrice = zo_round(sellPrice * (1 + hagglingBonus / 100))
							end
							
							if savedVars.notifications.allItems then
								local RECEIPT_FORMAT
								if sellPrice == 0 then
									RECEIPT_FORMAT = GetString(DUSTMAN_FORMAT_ZERO)
								else
									RECEIPT_FORMAT = GetString(DUSTMAN_FORMAT_GOLD)
								end
								
								MyPrint(zo_strformat(RECEIPT_FORMAT, name, data.stackCount, sellPrice * data.stackCount))
							end
							count = count + data.stackCount
							transactions = transactions + 1
							total = total + sellPrice * data.stackCount
						end
					end
				end
			elseif transactionsMessage then
				transactionsMessage = false
				MyPrint(GetString(DUSTMAN_ZOS_RESTRICTIONS))
			end
		end
		
		if total > 0 and savedVars.notifications.total then
			MyPrint(zo_strformat(DUSTMAN_FORMAT_TOTAL, count, total))
		end
		
	end
	
end

local function LaunderingItem(bagCache)
	local total = 0
	local count = 0
	local transactions = 0
	local transactionsMessage = true
	
	bagCache = pairsByQuality(bagCache)
	
	for slotId, data in pairs(bagCache) do
		if transactions < 98 then
			if data.toLaunder then
				local totalSells, sellsUsed = GetFenceLaunderTransactionInfo()
				if sellsUsed == totalSells then
					ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.NEGATIVE_CLICK, GetString("SI_ITEMLAUNDERRESULT", ITEM_LAUNDER_RESULT_AT_LIMIT))
					if total > 0 and savedVars.notifications.total then
						MyPrint(zo_strformat(DUSTMAN_FORMATL_TOTAL, count, total))
					end
					return
				end
				local name = GetItemLink(BAG_BACKPACK, data.slotIndex)
				if IsItemProtected(BAG_BACKPACK, data.slotIndex) then
					MyPrint(zo_strformat(DUSTMAN_FORMATL_NOTSOLD, name))
				else
				
					local numFreeSlots = GetNumBagFreeSlots(BAG_BACKPACK)
					local qtyToLaunder = math.min(data.stackCount, (totalSells - sellsUsed))
					
					if numFreeSlots > 0 or data.stackCount <= (totalSells - sellsUsed) then
						LaunderItem(BAG_BACKPACK, data.slotIndex, qtyToLaunder)
						if savedVars.notifications.allItems then
							local RECEIPT_FORMAT
							if data.launderPrice == 0 then
								RECEIPT_FORMAT = GetString(DUSTMAN_FORMATL_ZERO)
							else
								RECEIPT_FORMAT = GetString(DUSTMAN_FORMATL_GOLD)
							end
							MyPrint(zo_strformat(RECEIPT_FORMAT, name, qtyToLaunder, data.launderPrice * qtyToLaunder))
						end
						transactions = transactions + 1
						count = count + qtyToLaunder
						total = total + data.launderPrice * qtyToLaunder
					end
				end
			end
		elseif transactionsMessage then
			transactionsMessage = false
			MyPrint(GetString(DUSTMAN_ZOS_RESTRICTIONS))
		end
	end

	if total > 0 and savedVars.notifications.total then
		MyPrint(zo_strformat(DUSTMAN_FORMATL_TOTAL, count, total))
	end
	
end

local function HandleJunk(bagId, slotId, itemLink, sellPrice, forceDestroy, ruleName, itemCode)

	if savedVars.destroy or forceDestroy then
		local destroy = false
		if forceDestroy then
			destroy = true
		else
			local quality = GetItemLinkQuality(itemLink)
			local isStolen = IsItemLinkStolen(itemLink)

			local _, maxStack = GetSlotStackSize(bagId, slotId)
			if isStolen then
				destroy = quality <= savedVars.destroyStolenQuality and (sellPrice <= savedVars.destroyStolenValue and ((not savedVars.destroyExcludeStackable) or (savedVars.destroyExcludeStackable and maxStack <= 1)))
			else
				destroy = quality <= savedVars.destroyQuality and (sellPrice == 0 or (sellPrice <= savedVars.destroyValue and ((not savedVars.destroyExcludeStackable) or (savedVars.destroyExcludeStackable and maxStack <= 1))))
			end
		end

		if destroy then
			DestroyItem(bagId, slotId)
			if savedVars.notifications.verbose then
				MyPrint(zo_strformat(DUSTMAN_NOTE_DESTROY, itemLink, ruleName))
			end
			return
		end
	end

	if not IsItemJunk(bagId, slotId) then
		local memory = savedVars.memory-- should be deleted, same line next and last
		savedVars.memory = false
		if not itemCode or (itemCode and markedAsJunk[itemCode]) then
			SetItemIsJunk(bagId, slotId, true) -- We do mark as junk all basic items and those who have been manually set as junk. if they have been moved out from junk by users, no need to re-re-mark them as non junk.
			if savedVars.notifications.verbose then
				MyPrint(zo_strformat(DUSTMAN_NOTE_JUNK, itemLink, ruleName))
			end
		end
		savedVars.memory = memory
	end
	
end

-- Event handlers -------------------------------------------------------------
local function OnInventorySingleSlotUpdate(_, bagId, slotId, isNewItem)
	
	if IsUnderArrest() then return end -- Avoid check when a guard destroy stolen items
	if IsItemJunk(bagId, slotId) then return end --we do not need to check junk again
	if Roomba and Roomba.WorkInProgress and Roomba.WorkInProgress() then return end --support for Roomba
	if BankManagerRevived_inProgress and BankManagerRevived_inProgress() then return end --support for BankManagerRevived
	
	local _, stackCount, sellPrice, _, _, equipType, itemStyle, quality = GetItemInfo(bagId, slotId)
	
	if stackCount < 1 then return end -- empty slot
	if quality == ITEM_QUALITY_LEGENDARY then return end
	
	local itemLink = GetItemLink(bagId, slotId)
	local itemType, specializedItemType = GetItemLinkItemType(itemLink)
	local itemId = select(4, ZO_LinkHandler_ParseLink(itemLink))
	local level = GetItemLevel(bagId, slotId)
	
	local dontLaunder
	-- Stolen item to do not launder, not in the main block because it must be re-evaluated.
	if IsItemLinkStolen(itemLink) then
		if itemType ~= ITEMTYPE_TREASURE then
			if savedVars.excludeLaunder[itemType] and quality <= ITEM_QUALITY_NORMAL and (itemType ~= ITEMTYPE_STYLE_MATERIAL or (itemType == ITEMTYPE_STYLE_MATERIAL and savedVars.styleMaterial[itemId] ~= nil)) then
				if savedVars.destroyNonLaundered then
					HandleJunk(bagId, slotId, itemLink, sellPrice, true, "FENCE-TO-DESTROY") -- Will destroy the item directly
					return
				else
					dontLaunder = true
				end
			end
		else
			if savedVars.lowStolen == 2 and quality < savedVars.stolenQuality then
				HandleJunk(bagId, slotId, itemLink, sellPrice, true, "FENCE-TO-DESTROY") -- Will destroy the item directly
				return
			elseif savedVars.lowStolen ~= 3 then
				dontLaunder = true
			end
		end
	end
	
	--ignored items
	if Dustman.IsOnIgnoreList(itemId) then
		return
	--support for Item Saver and FCO ItemSaver
	elseif IsItemProtected(bagId, slotId) then
		return
	--items marked by user (if it is set as a high priority filter)
	elseif savedVars.useMemoryFirst and savedVars.memory then
		local itemCode = zo_strjoin("_", itemId, quality, level)
		if markedAsJunk[itemCode] ~= nil then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "USER-BEFORE", itemCode)
			return
		end
	end
	
	-- stolen clothes
	if savedVars.excludeStolenClothes and itemType == ITEMTYPE_ARMOR and GetItemLinkArmorType(itemLink) == ARMORTYPE_NONE and
	equipType ~= EQUIP_TYPE_NECK and equipType ~= EQUIP_TYPE_RING and equipType ~= EQUIP_TYPE_COSTUME and equipType ~= EQUIP_TYPE_INVALID then
		return
	--stolen items with no other use then selling to fence
	elseif savedVars.stolen and IsItemLinkStolen(itemLink) and itemType == ITEMTYPE_TREASURE and equipType == EQUIP_TYPE_INVALID and quality >= savedVars.stolenQuality then
		HandleJunk(bagId, slotId, itemLink, sellPrice, false, "FENCE")
		return
	--trash items
	elseif itemType == ITEMTYPE_TRASH then
		HandleJunk(bagId, slotId, itemLink, sellPrice, false, "TRASH")
		return
	--style material
	elseif itemType == ITEMTYPE_STYLE_MATERIAL then
		if savedVars.styleMaterial[itemId] and ((not savedVars.styleFullStack) or (savedVars.styleFullStack and IsFullStackInBag(slotId, BAG_BANK, itemLink))) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "STYLE")
			return
		end
	--armor/weapon traits
	elseif itemType == ITEMTYPE_ARMOR_TRAIT or itemType == ITEMTYPE_WEAPON_TRAIT then
		if isNewItem and savedVars.notifications.found and (itemId == "56862" or itemId == "56863") and not savedVars.traitMaterial[itemId] then
			MyPrint(zo_strformat(DUSTMAN_NOTE_INTERESTING, itemLink))
		end
		if savedVars.traitMaterial[itemId] and ((not savedVars.traitFullStack) or (savedVars.traitFullStack and IsFullStackInBag(slotId, BAG_BANK, itemLink))) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "TRAIT")
			return
		end
	--potions, IsItemBound is here for crown store potions. 24th item flag is ~= 0 when a potion is crafted
	elseif itemType == ITEMTYPE_POTION and IsItemBound(bagId, slotId) == false then
		if savedVars.potions and select(24, ZO_LinkHandler_ParseLink(itemLink)) == "0" and (not Dustman.IsWhitelistedPotion(itemId)) then
			if (not (savedVars.fullStackBagPotions and (not IsFullStackInBag(slotId, BAG_BACKPACK, itemLink)))) and (not (savedVars.fullStackBankPotions and (not IsFullStackInBag(slotId, BAG_BANK, itemLink)))) then
				local requiredChampionPoints = GetItemLinkRequiredChampionPoints(itemLink)
				if savedVars.keepPotionsLevel == 1 or (savedVars.keepPotionsLevel > 1 and requiredChampionPoints and requiredChampionPoints + 10000 < savedVars.keepPotionsLevel) then
					HandleJunk(bagId, slotId, itemLink, sellPrice, false, "POTION")
					return
				end
			end
		end
	--poisons, IsItemBound is here for crown store poisons. 24th item flag is ~= 0 when a poison is crafted
	elseif itemType == ITEMTYPE_POISON and IsItemBound(bagId, slotId) == false then
		if savedVars.poisons and select(24, ZO_LinkHandler_ParseLink(itemLink)) == "0" and (not Dustman.IsWhitelistedPotion(itemId)) then
			if (not (savedVars.fullStackBagPoisons and (not IsFullStackInBag(slotId, BAG_BACKPACK, itemLink)))) and (not (savedVars.fullStackBankPoisons and (not IsFullStackInBag(slotId, BAG_BANK, itemLink)))) then
				local requiredChampionPoints = GetItemLinkRequiredChampionPoints(itemLink)
				if savedVars.keepPoisonsLevel == 1 or (savedVars.keepPoisonsLevel > 1 and requiredChampionPoints and requiredChampionPoints + 10000 < savedVars.keepPoisonsLevel) then
					HandleJunk(bagId, slotId, itemLink, sellPrice, false, "POISON")
					return
				end
			end
		end
	--poisons
	elseif itemType == ITEMTYPE_POISON_BASE and savedVars.poisonsSolvants then
		if (not (savedVars.fullStackBagPoisonsSolvants and (not IsFullStackInBag(slotId, BAG_BACKPACK, itemLink)))) and (not (savedVars.fullStackBankPoisonsSolvants and (not IsFullStackInBag(slotId, BAG_BANK, itemLink)))) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "POISON-BASE")
			return
		end
	--equipable items
	elseif itemType == ITEMTYPE_ARMOR or itemType == ITEMTYPE_WEAPON then
		
		--exclude crafted items
		if IsItemLinkCrafted(itemLink) then return end

		local trait = GetItemTrait(bagId, slotId)
		local isResearchable = IsItemNeededForResearch(itemLink)
		local craftingType = LR:GetItemCraftingSkill(itemLink)
		local isRareStyle = (craftingType ~= -1) and (Dustman.IsRareStyle(itemStyle) or Dustman.IsRareStyle(itemStyle) == nil)
		local isSet, setName = GetItemLinkSetInfo(itemLink, false)
		local isNirnhoned = trait == ITEM_TRAIT_TYPE_ARMOR_NIRNHONED or trait == ITEM_TRAIT_TYPE_WEAPON_NIRNHONED
		local requiredLevel = GetItemLinkRequiredLevel(itemLink)
		local requiredChampionPoints = GetItemLinkRequiredChampionPoints(itemLink)
		
		local sv = savedVars.equipment
		local svN = savedVars.notifications

		if isNewItem and svN.found then
			if isResearchable and sv.keepResearchable then
				MyPrint(zo_strformat(DUSTMAN_NOTE_RESEARCH, itemLink, GetString("SI_ITEMTRAITTYPE", trait)))
			elseif isNirnhoned and sv.keepNirnhoned then
				MyPrint(zo_strformat(DUSTMAN_NOTE_NIRNHONED, GetString("SI_ITEMTRAITTYPE", trait), itemLink))
			end
			if isRareStyle and sv.keepRareStyle then
				MyPrint(zo_strformat(DUSTMAN_NOTE_RARESTYLE, itemLink, GetString("SI_ITEMSTYLE", itemStyle)))
			end
			if isSet and sv.keepSetItems and not (equipType == EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING) then
				MyPrint(zo_strformat(DUSTMAN_NOTE_SETITEM, itemLink, setName))
			end
			if isSet and sv.keepJewelsSetItems and (equipType == EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING) then
				MyPrint(zo_strformat(DUSTMAN_NOTE_SETITEM, itemLink, setName))
			end
		end

		--exclude researchable items
		if isResearchable and sv.keepResearchable then return end
		--exclude rare style items
		if isRareStyle and sv.keepRareStyle then return end
		
		-- Exclude items with a specific trait
		if not (equipType == EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING) then
			if sv.enabled and quality <= sv.equipmentQuality and (not isSet or savedVars.junkTraitSets) then
				if not ((sv.keepLevel > 1 and requiredLevel >= sv.keepLevel) or (sv.keepLevel > 1 and requiredChampionPoints and requiredChampionPoints + 10000 >= sv.keepLevel)) then
					if savedVars.itemTraits[trait] then
						HandleJunk(bagId, slotId, itemLink, sellPrice, false, "ITEM-TRAIT")
						return
					end
				end
			end
		end
		
		--exclude set armors & weapons
		if isSet and sv.keepSetItems and not (equipType == EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING) then return end
		
		--exclude set jewels
		if isSet and sv.keepJewelsSetItems and (equipType == EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING) and quality >= sv.jewelsSetQuality then return end
		
		--exclude items with Nirnhoned trait
		if isNirnhoned and sv.keepNirnhoned then return end
		
		--exclude intricate items
		if trait == ITEM_TRAIT_TYPE_ARMOR_INTRICATE or trait == ITEM_TRAIT_TYPE_WEAPON_INTRICATE then
			if sv.keepIntricate then
				--only if crafting skill in not maxed
				if sv.keepIntricateIfNotMaxed then
					local _, rank = GetSkillLineInfo(GetCraftingSkillLineIndices(craftingType))
					if rank < 50 then return end
				else
					return
				end
			end
		end
		
		-- Items with non-craftable enchants
		if sv.keepNCEnchants then
			local _, enchantHeader = GetItemLinkEnchantInfo(itemLink)
			-- Non craftable enchants have an header set to "Enchantment", other get a more detailled header (EN/FR/DE)
			if enchantHeader ~= "" and (enchantHeader == "Enchantment" or enchantHeader == "Enchantement" or enchantHeader == "Verzauberung") then
				return
			end
		end

		--zero value items
		if sv.whiteZeroValue and quality == ITEM_QUALITY_NORMAL and sellPrice == 0 then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "0 GOLD")
			return
		end
		
		if ( not (equipType == EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING) ) then
			--exclude items based on level/vetrank. 10000 is added to cprank
			if ((sv.keepLevel > 1 and requiredLevel >= sv.keepLevel)
			or (sv.keepLevel > 1 and requiredChampionPoints and requiredChampionPoints + 10000 >= sv.keepLevel))
			and (not sv.keepLevelOrnate or sv.keepLevelOrnate and (trait ~= ITEM_TRAIT_TYPE_ARMOR_ORNATE and trait ~= ITEM_TRAIT_TYPE_WEAPON_ORNATE)) then
				return
			end
		end
		
		-- notrait
		if sv.notrait and quality <= sv.notraitQuality then
			if trait == ITEM_TRAIT_TYPE_NONE and (GetItemLinkArmorType(itemLink) ~= ARMORTYPE_NONE or GetItemLinkWeaponType(itemLink) ~= WEAPONTYPE_NONE) then
				HandleJunk(bagId, slotId, itemLink, sellPrice, false, "TRAITLESS ITEM")
				return
			end
		end
		-- notrait jewels
		if sv.notraitJewels then
			if trait == ITEM_TRAIT_TYPE_NONE and GetItemLinkArmorType(itemLink) == ARMORTYPE_NONE and (equipType == EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING) then
				HandleJunk(bagId, slotId, itemLink, sellPrice, false, "TRAITLESS JEWEL")
				return
			end
		end
		--ornate weapons & armor
		if sv.ornate and quality <= sv.ornateQuality then
			if trait == ITEM_TRAIT_TYPE_ARMOR_ORNATE or trait == ITEM_TRAIT_TYPE_WEAPON_ORNATE then
				HandleJunk(bagId, slotId, itemLink, sellPrice, false, "ORNATE ITEM")
				return
			end
		end
		--ornate jewels
		if sv.jewelsOrnate and quality <= sv.jewelsOrnateQuality then
			if trait == ITEM_TRAIT_TYPE_JEWELRY_ORNATE then
				HandleJunk(bagId, slotId, itemLink, sellPrice, false, "ORNATE JEWEL")
				return
			end
		end
		--mark items with the selected item quality
		if sv.enabled and quality <= sv.equipmentQuality and not (equipType == EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "STD ITEM")
			return
		end		
		--mark items with the selected item quality
		if sv.jewelsEnabled and quality <= sv.jewelsQuality and (equipType == EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "STD JEWEL")
			return
		end
	--fishing lure
	elseif itemType == ITEMTYPE_LURE then
		if itemId == "42878" then --always mark used bait
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "LURE-USED")
			return
		elseif savedVars.lure and ((not (savedVars.lureFullStack and (not IsFullStackInBag(slotId, BAG_BACKPACK, itemLink)))) and (not (savedVars.lureFullStackBank and (not IsFullStackInBag(slotId, BAG_BANK, itemLink))))) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "LURE")
			return
		end
	--glyphs
	elseif (itemType == ITEMTYPE_GLYPH_ARMOR or itemType == ITEMTYPE_GLYPH_JEWELRY or itemType == ITEMTYPE_GLYPH_WEAPON) and IsItemLinkCrafted(itemLink) == false and savedVars.glyphs and quality <= savedVars.glyphsQuality then
		local minLevel, minChampionPoints = GetItemLinkGlyphMinLevels(itemLink)
		if savedVars.keepLevelGlyphs == 1 or (savedVars.keepLevelGlyphs > 1 and ((minLevel and minLevel < savedVars.keepLevelGlyphs) or (minChampionPoints and (minChampionPoints + 10000) < savedVars.keepLevelGlyphs))) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "GLYPH")
			return
		end
	--provisioning recipes
	elseif itemType == ITEMTYPE_RECIPE  and IsItemLinkRecipeKnown(itemLink) then
		if savedVars.provisioning.recipe and (specializedItemType == SPECIALIZED_ITEMTYPE_RECIPE_PROVISIONING_STANDARD_FOOD or specializedItemType == SPECIALIZED_ITEMTYPE_RECIPE_PROVISIONING_STANDARD_FOOD) and quality <= savedVars.provisioning.recipeQuality then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "RECIPE")
			return
		elseif savedVars.housingRecipe and (not (specializedItemType == SPECIALIZED_ITEMTYPE_RECIPE_PROVISIONING_STANDARD_FOOD or specializedItemType == SPECIALIZED_ITEMTYPE_RECIPE_PROVISIONING_STANDARD_FOOD)) and quality <= savedVars.provisioning.recipeQuality then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "HOUSING RECIPE")
			return
		end
	--collected fish & collected trophies
	elseif itemType == ITEMTYPE_COLLECTIBLE then
		
		if specializedItemType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_MONSTER_TROPHY and savedVars.trophies then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "TROPHY")
			return
		 end
		 
		if specializedItemType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_RARE_FISH and savedVars.trophy then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "FISH TROPHY")
			return
		 end
		 
	--provisioning ingredients
	elseif itemType == ITEMTYPE_INGREDIENT then
		local sv = savedVars.provisioning
		if Dustman.IsOldIngredient(itemId) and sv.oldIngredients then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "INGREDIENT")
			return
		else
			local recipeType, ingredientType = Dustman.GetIngredientInfo(itemId)
			if sv.all then
				if sv.dish and recipeType == 1 then
					if not (ingredientType == 5 and sv.excludeRareAdditives) and (not sv.fullStack or (sv.fullStack and IsFullStackInBag(slotId, BAG_BANK, itemLink))) then
						HandleJunk(bagId, slotId, itemLink, sellPrice, false, "FOOD INGR.")
						return
					end
				elseif sv.drink and recipeType == 2 then
					if not (ingredientType == 5 and sv.excludeRareAdditives) and (not sv.fullStack or (sv.fullStack and IsFullStackInBag(slotId, BAG_BANK, itemLink))) then
						HandleJunk(bagId, slotId, itemLink, sellPrice, false, "DRINK INGR.")
						return
					end
				end
			elseif sv.unusable and (not usableIngredients[itemId]) then
				if sv.dish and recipeType == 1 then
					if not (ingredientType == 5 and sv.excludeRareAdditives) and (not sv.fullStack or (sv.fullStack and IsFullStackInBag(slotId, BAG_BANK, itemLink))) then
						HandleJunk(bagId, slotId, itemLink, sellPrice, false, "UN. FOOD INGR.")
						return
					end
				elseif sv.drink and recipeType == 2 then
					if not (ingredientType == 5 and sv.excludeRareAdditives) and (not sv.fullStack or (sv.fullStack and IsFullStackInBag(slotId, BAG_BANK, itemLink))) then
						HandleJunk(bagId, slotId, itemLink, sellPrice, false, "UN. DRINK INGR.")
						return
					end
				end
			end
		end
	--consumables
	elseif itemType == ITEMTYPE_FOOD and quality <= savedVars.foodQuality then
		if savedVars.foodAll then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "FOOD")
			return
		elseif savedVars.food and Dustman.IsBadFood(itemId) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "BAD FOOD")
			return
		end
	elseif itemType == ITEMTYPE_DRINK and quality <= savedVars.foodQuality then
		if savedVars.foodAll then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "DRINK")
			return
		elseif savedVars.food and Dustman.IsBadDrink(itemId) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "BAD DRINK")
			return
		end
	elseif (itemType == ITEMTYPE_BLACKSMITHING_BOOSTER or itemType == ITEMTYPE_CLOTHIER_BOOSTER or itemType == ITEMTYPE_WOODWORKING_BOOSTER) and quality <= savedVars.smithing.boosterQuality then 
		local sv = savedVars.smithing
		if sv.smithingBoosters and (not sv.boosterFullStack or (sv.boosterFullStack and IsFullStackInBag(slotId, BAG_BANK, itemLink))) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "BOOSTER")
			return
		end
	elseif itemType == ITEMTYPE_ENCHANTING_RUNE_ASPECT and quality <= savedVars.enchanting.aspectQuality then 
		local sv = savedVars.enchanting
		if sv.enchantingAspect and (not sv.aspectFullStack or (sv.aspectFullStack and IsFullStackInBag(slotId, BAG_BANK, itemLink))) then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "ASPECT RUNE")
			return
		end
	elseif itemType == ITEMTYPE_SOUL_GEM and quality == ITEM_QUALITY_NORMAL and savedVars.emptyGems then 
		HandleJunk(bagId, slotId, itemLink, sellPrice, false, "SOULGEM")
		return
	end
	
	--items marked by user
	if savedVars.memory then
		local itemCode = zo_strjoin("_", itemId, quality, level)
		if markedAsJunk[itemCode] ~= nil then
			HandleJunk(bagId, slotId, itemLink, sellPrice, false, "USER-AFTER", itemCode)
			return
		end
	end
	
	-- Stolen item to do not launder. If they need to be destroyed, the task is done at the beginning of the function. They can also be sold, done before aswell.
	if dontLaunder then
		return
	end
	
	-- item can be laundered
	return true
	
end

local function OnRecipeLearned(eventCode, recipeListIndex, recipeIndex)
	local numIngredients = select(3, GetRecipeInfo(recipeListIndex, recipeIndex))
	for ingredientIndex = 1, numIngredients do
		local link = GetRecipeIngredientItemLink(recipeListIndex, recipeIndex, ingredientIndex, LINK_STYLE_DEFAULT)
		local itemId = select(4, ZO_LinkHandler_ParseLink(link))
		usableIngredients[itemId] = true
	end
end

local function OnOpenStore()
	
	if savedVars.notifications.sell then
		if HasAnyJunk(BAG_BACKPACK, true) then
			if savedVars.notifications.sellDialog then
				ZO_Dialogs_ShowPlatformDialog("DUSTMAN_CONFIRM_SELL_JUNK")
			else
				SellJunkItems(false)
			end
		end
	end
end

local function InteractWithLaunder()

	local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
	
	local hasAnyToLaunder = false
	for slotId, data in pairs(bagCache) do
		if data.stolen then
			local toLaunder = OnInventorySingleSlotUpdate(nil, BAG_BACKPACK, data.slotIndex, false)
			if toLaunder then
				hasAnyToLaunder = true
				data.toLaunder = true
			end
		end
	end

	if hasAnyToLaunder then
		LaunderingItem(bagCache)
	end

end

local function OnOpenFence()
	if AreAnyItemsStolen(BAG_BACKPACK) then
		
		if savedVars.notifications.sell then
			if HasAnyJunk(BAG_BACKPACK) then
				if savedVars.notifications.sellDialog then
					ZO_Dialogs_ShowPlatformDialog("DUSTMAN_CONFIRM_SELL_JUNK", {isFence = true})
				else
					SellJunkItems(true)
				end
			end
		end
		
		if savedVars.launder then
			InteractWithLaunder()
		end
		
	end
end

local function NamesToIDSavedVars()

	if not savedVars.namesToIDSavedVars then
		
		local displayName = GetDisplayName()
		local name = GetUnitName("player")
		
		if Dustman_SavedVariables.Default[displayName][name] then
			savedVars = Dustman_SavedVariables.Default[displayName][name]
			markedAsJunk = Dustman_Junk_SavedVariables.Default[displayName][name]
			savedVars.namesToIDSavedVars = true -- should not be necessary because data don't exist anymore in Dustman_SavedVariables.Default[displayName][name]
		end
		
	end

end

function Dustman.Sweep()
	local bagSize = GetBagSize(BAG_BACKPACK)
	for slotIndex = 0, bagSize - 1 do
		OnInventorySingleSlotUpdate(nil, BAG_BACKPACK, slotIndex, false)
	end
end

function Dustman.ClearMarkedAsJunk()
	markedAsJunk = {}
end

local function RegisterInventorySingleSlotUpdate()
	EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnInventorySingleSlotUpdate)
	EVENT_MANAGER:AddFilterForEvent(ADDON_NAME, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
	EVENT_MANAGER:AddFilterForEvent(ADDON_NAME, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT)
	inventorySingleSlotUpdate = true
end

local function UnregisterRegisterInventorySingleSlotUpdate()
	EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
	inventorySingleSlotUpdate = false
end

local function IsTutorialDone()
	local _, _, _, _, completed = GetAchievementInfo(TUTORIAL_ACHIEVEMENT)
	return completed
end

local function IsInTutorial()
	if SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED then
		CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
	end
	return GetZoneId(GetCurrentMapZoneIndex()) == WAILING_PRISON_ZONE
end

local function OnPlayerActivated()
	if inventorySingleSlotUpdate then
		if IsInTutorial() then
			UnregisterRegisterInventorySingleSlotUpdate()
		end
	else
		if IsTutorialDone() then
			RegisterInventorySingleSlotUpdate()
			EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_PLAYER_ACTIVATED)
		elseif not IsInTutorial() then
			RegisterInventorySingleSlotUpdate()
		end
	end
end

local function OnLoad(eventCode, name)

	if name == ADDON_NAME then
	
		--initialize saved variables
		savedVars = ZO_SavedVars:NewCharacterIdSettings("Dustman_SavedVariables", 2, nil, defaults)
		markedAsJunk = ZO_SavedVars:NewCharacterIdSettings("Dustman_Junk_SavedVariables", 2)
		
		NamesToIDSavedVars() -- NamesToIDSavedVars
		
		--hook SetItemIsJunk to watch item marked as junk
		local original_SetItemIsJunk = SetItemIsJunk
		SetItemIsJunk = function(bagId, slotId, junk, ...)
			if junk and IsItemProtected(bagId, slotId) then
				junk = false
			end
			if savedVars.memory then
				local itemLink = GetItemLink(bagId, slotId)
				local itemId = select(4, ZO_LinkHandler_ParseLink(itemLink))
				local quality = GetItemLinkQuality(itemLink)
				local level = GetItemLevel(bagId, slotId)
				markedAsJunk[zo_strjoin("_", itemId, quality, level)] = junk
			end
			original_SetItemIsJunk(bagId, slotId, junk, ...)
		end

		--add confirmation dialog
		local confirmSellDialog = {
			gamepadInfo = { dialogType = GAMEPAD_DIALOGS.BASIC, allowShowOnNextScene = true },
			title = { text = SI_PROMPT_TITLE_SELL_ITEMS },
			mainText = { text = SI_SELL_ALL_JUNK },
			buttons = {
				{
					text = SI_SELL_ALL_JUNK_CONFIRM,
					callback = function(dialog)
						local isFence = false
						if dialog.data then isFence = dialog.data.isFence end
						SellJunkItems(isFence)
					end
				},
				{ text = SI_DIALOG_CANCEL }
			}
		}
		
		-- Dustman handle sells when user disable auto sell and use Keybind to sell its items.
		-- Prehook is not enought because function is hardcoded in dialog, so we need to redo dialog after this action
		-- false must be sent in order to handle non stolen items, there is no SellJunkItems calls when at fence, only at "regular" merchant.
		ZO_PreHook("SellAllJunk", function() SellJunkItems(false) end)
		
		ESO_Dialogs["SELL_ALL_JUNK"] =
		{
			title =
			{
				text = SI_PROMPT_TITLE_SELL_ITEMS,
			},
			mainText = 
			{
				text = SI_SELL_ALL_JUNK,
			},
			buttons =
			{
				[1] =
				{
					text = SI_SELL_ALL_JUNK_CONFIRM,
					callback = SellAllJunk,
				},
				[2] =
				{
					text = SI_DIALOG_DECLINE,
				},
			},
		}
		
		ZO_Dialogs_RegisterCustomDialog("DUSTMAN_CONFIRM_SELL_JUNK", confirmSellDialog)
		
		BuildUsableIngredientsList()
		Dustman.CreateSettingsMenu(savedVars, markedAsJunk, defaults)
		
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_OPEN_STORE, OnOpenStore)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_OPEN_FENCE, OnOpenFence)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_RECIPE_LEARNED, OnRecipeLearned)
		
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
		
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
		
	end
	
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnLoad)