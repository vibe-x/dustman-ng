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

local ignoreList = {
   ["33235"] = true, --Wabbajack
   ["29956"] = true, --Hunting Bow
   ["54982"] = true, --Sentinel's Lash
   ["54983"] = true, --Cadwell's Lost Robe
   ["54984"] = true, --Er-Jaseen's Worn Jack
   ["54985"] = true, --Unfinished Torment Cuirass
   ["43757"] = true, --Wet Gunny Sack
}

local isBadFood = {
   ["30456"] = true, --cold roast goat
   ["30457"] = true, --cold kwama omelet
   ["30458"] = true, --stale goatherd's pie
   ["30459"] = true, --stale kwama quiche
   ["30460"] = true, --congealed goat bone soup
   ["30461"] = true, --congealed poached kwama egg
   ["30585"] = true, --stale bread
   ["30586"] = true, --congealed cheese
   ["30588"] = true, --stale radish
   ["30589"] = true, --cold fish
   ["30590"] = true, --stale carrots
   ["32070"] = true, --cold scuttle scramble
   ["32071"] = true, --stale scuttle baguette
   ["32072"] = true, --congealed scuttle fondue
   ["32076"] = true, --cold grilled worms
   ["32077"] = true, --stale worm tart
   ["32078"] = true, --congealed wriggles-in-gullet
   ["32094"] = true, --cold maggot bites
   ["32095"] = true, --stale rodent muffins
   ["32096"] = true, --congealed squeak soup
   ["32100"] = true, --cold slow-roasted chaurus
   ["32101"] = true, --stale maggot haggis
   ["32102"] = true, --congealed slumgullion
   ["32118"] = true, --cold grilled frog legs
   ["32119"] = true, --stale chaurus dumplings
   ["32120"] = true, --congealed chaurus-in-carapace
   ["32124"] = true, --cold beef sirloin
   ["32125"] = true, --stale frog muffin
   ["32126"] = true, --congealed swamp soup
   ["32142"] = true, --cold grilled shank
   ["32143"] = true, --stale beef pasty
   ["32144"] = true, --congealed imperial city stew
   ["32148"] = true, --cold fishy sticks
   ["32149"] = true, --stale shank-and-potato pie
   ["32150"] = true, --congealed crab meat stew
   ["37773"] = true, --cold grilled capon
   ["37774"] = true, --stale capon tinish
   ["37775"] = true, --congealed capon noodle soup
   ["37779"] = true, --cold Battaglir Weeds
   ["37780"] = true, --stale battaglir loaf
   ["37781"] = true, --congealed stewed battaglir
   ["37785"] = true, --cold bear hash
   ["37786"] = true, --stale bear flank pie
   ["37787"] = true, --congealed bear soup
   ["37791"] = true, --cold mutton ribs
   ["37792"] = true, --stale mutton pie
   ["37793"] = true, --congealed baandari mutton stew
   ["37797"] = true, --cold grilled combwort
   ["37798"] = true, --stale combwort flatbread
   ["37799"] = true, --congealed combwort confit
   ["37803"] = true, --cold grilled venison
   ["37804"] = true, --stale venison pasty
   ["37805"] = true, --congealed jugged venison
   ["37809"] = true, --cold gilled horker
   ["37810"] = true, --stale horker loaf
   ["37811"] = true, --congealed horker stew
   ["37815"] = true, --cold mountain jerky
   ["37816"] = true, --stale flank pie
   ["37817"] = true, --congealed breton stew
   ["37869"] = true, --cold roast pig
   ["37870"] = true, --stale trotter pie
   ["37871"] = true, --congealed pork soup
   ["37875"] = true, --cold fried guar eggs
   ["37876"] = true, --stale guar quiche
   ["37877"] = true, --congealed century soup
   ["37881"] = true, --cold braised sweetmeats
   ["37882"] = true, --stale sweetbread
   ["37883"] = true, --congealed sweetmeat surprise
   ["37887"] = true, --cold liver and lights
   ["37888"] = true, --stale liverwurst tart
   ["37889"] = true, --congealed liver goulash
   ["37893"] = true, --cold Caramelized Goat Nibbles
   ["37894"] = true, --stale goat dumplings
   ["37895"] = true, --congealed goat stew
   ["37899"] = true, --cold moon sugar brittle
   ["37900"] = true, --stale moon sugar biscuits
   ["37901"] = true, --congealed elsweyr fondue
   ["37905"] = true, --cold crawdad stir-fry
   ["37907"] = true, --congealed crawdad etoufee
   ["37911"] = true, --cold fried saltrice
   ["37912"] = true, --stale saltrice biscuits
   ["37913"] = true, --congealed saltrice slurry
   ["40298"] = true, --stale crawdad quiche
}

local isBadDrink = {
   ["30450"] = true, --flat snake sweat
   ["30451"] = true, --flat saloop
   ["30452"] = true, --murky snake sherry
   ["30453"] = true, --murky numb-all-over
   ["30454"] = true, --cloudy slither liquor
   ["30455"] = true, --cloudy blinder
   ["30587"] = true, --cloudy grape brandy
   ["32067"] = true, --flat voljar's honey cider
   ["32068"] = true, --murky voljar's mead
   ["32069"] = true, --cloudy voljar's liqueur
   ["32073"] = true, --flat dragon's-tongue ale
   ["32074"] = true, --murky dragon's-tongue shirza
   ["32075"] = true, --cloudy slash of the dragon
   ["32091"] = true, --flat sujamma stout
   ["32092"] = true, --murky sujamma red
   ["32093"] = true, --cloudy sujamma
   ["32097"] = true, --flat comberry cider
   ["32098"] = true, --murky shien
   ["32099"] = true, --cloudy greef
   ["32115"] = true, --flat river's ale
   ["32116"] = true, --murky river madeira
   ["32117"] = true, --cloudy night-grog
   ["32121"] = true, --flat ash-slake ale
   ["32122"] = true, --murky ash zinfandel
   ["32123"] = true, --cloudy gray lightning
   ["32139"] = true, --flat bloodforth
   ["32140"] = true, --murky plum brandy-wine
   ["32141"] = true, --cloudy ambrosia
   ["32145"] = true, --flat sun's dusk ale
   ["32146"] = true, --murky shein wine
   ["32147"] = true, --cloudy old epiphany
   ["37770"] = true, --flat shornhelm ale
   ["37771"] = true, --murky spiced wine
   ["37772"] = true, --cloudy aqua vitae
   ["37776"] = true, --flat bog-iron ale
   ["37777"] = true, --murky ungorth
   ["37778"] = true, --cloudy truth-glimpse
   ["37782"] = true, --flat citrus malt
   ["37783"] = true, --murky sunset rose
   ["37784"] = true, --cloudy tangerine liqueur
   ["37788"] = true, --flat bottled buzz
   ["37789"] = true, --murky wet wasp white
   ["37790"] = true, --cloudy hive mind
   ["37794"] = true, --flat four-eye grog
   ["37795"] = true, --murky clamberskull
   ["37796"] = true, --cloudy old kindlepitch
   ["37800"] = true, --flat brew-wife ale
   ["37801"] = true, --murky vintage spew
   ["37802"] = true, --cloudy hopscotch
   ["37806"] = true, --flat heather-tea
   ["37807"] = true, --murky heather mead
   ["37808"] = true, --cloudy heather bender
   ["37812"] = true, --flat bitter tea
   ["37813"] = true, --murky black wine
   ["37814"] = true, --cloudy black night cordial
   ["37866"] = true, --flat dark meat beer
   ["37867"] = true, --murky meat muscat
   ["37868"] = true, --cloudy rotmeth
   ["37872"] = true, --flat sun's dusk ale
   ["37873"] = true, --murky dusky claret
   ["37874"] = true, --cloudy beetle shots
   ["37878"] = true, --flat golden apple ale
   ["37879"] = true, --murky apple wine
   ["37880"] = true, --cloudy golden liqueur
   ["37884"] = true, --flat sylph-sandy
   ["37885"] = true, --murky dream madeira
   ["37886"] = true, --cloudy sylphy gin
   ["37890"] = true, --flat jagga
   ["37891"] = true, --murky porky port
   ["37892"] = true, --cloudy jagga ouzo
   ["37896"] = true, --flat sweetmilk
   ["37897"] = true, --murky gold coast muscat
   ["37898"] = true, --cloudy white eye
   ["37902"] = true, --flat fermented treacle tea
   ["37903"] = true, --murky cane mead
   ["37904"] = true, --cloudy treacle run
   ["37908"] = true, --flat sprin infusion
   ["37909"] = true, --murky sparkling spring
   ["37910"] = true, --cloudy blessed spring water
}

local ingredients = {
   --meat (health)
   ["28609"] = { 1, 1 }, --Game
   ["33752"] = { 1, 1 }, --Red Meat
   ["33753"] = { 1, 1 }, --Fish
   ["33754"] = { 1, 1 }, --White Meat
   ["33756"] = { 1, 1 }, --Small Game
   ["34321"] = { 1, 1 }, --Poultry
   --fruits (magicka)
   ["28603"] = { 1, 2 }, --Tomato
   ["28610"] = { 1, 2 }, --Jazbay Grapes
   ["33755"] = { 1, 2 }, --Bananas
   ["34308"] = { 1, 2 }, --Melon
   ["34311"] = { 1, 2 }, --Apples
   ["34305"] = { 1, 2 }, --Pumpkin
   --vegetables (stamina)
   ["28604"] = { 1, 3 }, --Greens
   ["33758"] = { 1, 3 }, --Potato
   ["34307"] = { 1, 3 }, --Radish
   ["34309"] = { 1, 3 }, --Beets
   ["34323"] = { 1, 3 }, --Corn
   ["34324"] = { 1, 3 }, --Carrots
   --dish additives
   ["26954"] = { 1, 4 }, --Garlic
   ["27057"] = { 1, 4 }, --Cheese
   ["27058"] = { 1, 4 }, --Seasoning
   ["27063"] = { 1, 4 }, --Saltrice
   ["27064"] = { 1, 4 }, --Millet
   ["27100"] = { 1, 4 }, --Flour
   --rare dish additive
   ["26802"] = { 1, 5 }, --Frost Mirriam
   --alcoholic (health)
   ["28639"] = { 2, 1 }, --Rye
   ["29030"] = { 2, 1 }, --Rice
   ["33774"] = { 2, 1 }, --Yeast
   ["34329"] = { 2, 1 }, --Barley
   ["34345"] = { 2, 1 }, --Surilie Grapes
   ["34348"] = { 2, 1 }, --Wheat
   --tea (magicka)
   ["28636"] = { 2, 2 }, --Rose
   ["33768"] = { 2, 2 }, --Comberry
   ["33771"] = { 2, 2 }, --Jasmine
   ["33773"] = { 2, 2 }, --Mint
   ["34330"] = { 2, 2 }, --Lotus
   ["34334"] = { 2, 2 }, --Bittergreen
   --tonic (stamina)
   ["33772"] = { 2, 3 }, --Coffee
   ["34333"] = { 2, 3 }, --Guarana
   ["34335"] = { 2, 3 }, --Yerba Mate
   ["34346"] = { 2, 3 }, --Gingko
   ["34347"] = { 2, 3 }, --Ginseng
   ["34349"] = { 2, 3 }, --Acai Berry
   --drink additives
   ["27035"] = { 2, 4 }, --Isinglass
   ["27043"] = { 2, 4 }, --Honey
   ["27048"] = { 2, 4 }, --Metheglin
   ["27049"] = { 2, 4 }, --Lemon
   ["27052"] = { 2, 4 }, --Ginger
   ["28666"] = { 2, 4 }, --Seaweed
   --rare drink additive
   ["27059"] = { 2, 5 }, --Bervez Juice
   --Caviar
   ["64222"] = { 3, 5 }, --Caviar
}

local oldIngredients = {
    ["26962"] = true, --Old Pepper
    ["26966"] = true, --Old Drippings
    ["26974"] = true, --Old Cooking Fat
    ["26975"] = true, --Old Suet
    ["26976"] = true, --Old Lard
    ["26977"] = true, --Old Fatback
    ["26978"] = true, --Old Pinguis
    ["26986"] = true, --Old Thin Broth
    ["26987"] = true, --Old Broth
    ["26988"] = true, --Old Stock
    ["26989"] = true, --Old Jus
    ["26990"] = true, --Old Glace Viande
    ["26998"] = true, --Old Imperial Stock
    ["26999"] = true, --Old Meal
    ["27000"] = true, --Old Milled Flour
    ["27001"] = true, --Old Sifted Flour
    ["27002"] = true, --Old Cake Flour
    ["27003"] = true, --Old Baker's Flour
    ["27004"] = true, --Old Imperial Flour
    ["27044"] = true, --Old Saaz Hops
    ["27051"] = true, --Old Jazbay Grapes
    ["27053"] = true, --Old Canis Root
    ["28605"] = true, --Old Scuttle Meat
    ["28606"] = true, --Old Plump Worms^p
    ["28607"] = true, --Old Plump Rodent Toes^p
    ["28608"] = true, --Old Plump Maggots^p
    ["28632"] = true, --Old Snake Slime
    ["28634"] = true, --Old Snake Venom
    ["28635"] = true, --Old Wild Honey
    ["28637"] = true, --Old Sujamma Berries^P
    ["28638"] = true, --Old River Grapes^p
    ["33757"] = true, --Old Venison
    ["33767"] = true, --Old Shornhelm Grains^p
    ["33769"] = true, --Old Tangerine
    ["33770"] = true, --Old Wasp Squeezings
    ["34304"] = true, --Old Pork
    ["34306"] = true, --Old Sweetmeats^p
    ["34312"] = true, --Old Saltrice
    ["34322"] = true, --Old Shank
    ["34331"] = true, --Old Ripe Apple
    ["34332"] = true, --Old Wisp Floss
    ["34336"] = true, --Old Spring Essence
    ["40260"] = true, --Old Brown Malt
    ["40261"] = true, --Old Amber Malt
    ["40262"] = true, --Old Caramalt
    ["40263"] = true, --Old Wheat Malt
    ["40264"] = true, --Old White Malt
    ["40265"] = true, --Old Wine Grapes^p
    ["40266"] = true, --Old Grasa Grapes^p
    ["40267"] = true, --Old Lado Grapes^p
    ["40268"] = true, --Old Camaralet Grapes^p
    ["40269"] = true, --Old Ribier Grapes^p
    ["40270"] = true, --Old Corn Mash
    ["40271"] = true, --Old Wheat Mash
    ["40272"] = true, --Old Oat Mash
    ["40273"] = true, --Old Barley Mash
    ["40274"] = true, --Old Rice Mash
    ["40276"] = true, --Old Mutton Flank
    ["45522"] = true, --Old Golden Malt
    ["45523"] = true, --Old Emperor Grapes^p
    ["45524"] = true, --Old Imperial Mash
}

local itemStyles = {
	[ITEMSTYLE_RACIAL_HIGH_ELF]		= false, -- The High Elves
	[ITEMSTYLE_RACIAL_DARK_ELF]		= false, -- The Dark Elves
	[ITEMSTYLE_RACIAL_WOOD_ELF]		= false, -- The Wood Elves
	[ITEMSTYLE_RACIAL_NORD]				= false, -- The Nords
	[ITEMSTYLE_RACIAL_BRETON]			= false, -- The Bretons
	[ITEMSTYLE_RACIAL_REDGUARD]		= false, -- The Redguards
	[ITEMSTYLE_RACIAL_KHAJIIT]			= false, -- The Khajiit
	[ITEMSTYLE_RACIAL_ORC]				= false, -- The Orcs
	[ITEMSTYLE_RACIAL_ARGONIAN]		= false, -- The Argonians
	[ITEMSTYLE_RACIAL_IMPERIAL]		= false, -- Imperial Cyrods
	[ITEMSTYLE_AREA_ANCIENT_ELF]		= true,  -- Ancient Elves
	[ITEMSTYLE_AREA_REACH]				= true,  -- Barbaric
	[ITEMSTYLE_ENEMY_PRIMITIVE]		= true,  -- Primal
	[ITEMSTYLE_ENEMY_DAEDRIC]			= true,  -- Daedric
	[ITEMSTYLE_AREA_DWEMER]				= true,  -- Dwemer
}

local whitelistedPotion = {
    ["71073"] = true, -- AvA Stam
    ["71071"] = true, -- AvA Health
    ["71072"] = true, -- AvA Magicka
	 ["74728"] = true, -- TG Stam/Stealth
	 ["74728"] = true, -- TG Stam/Speed
}

function Dustman.IsWhitelistedPotion(itemId)
   return whitelistedPotion[itemId] or false
end

function Dustman.IsOnIgnoreList(itemId)
   if type(itemId) == "number" then itemId = tostring(itemId) end
   return ignoreList[itemId] or false
end

function Dustman.IsBadFood(itemId)
   if type(itemId) == "number" then itemId = tostring(itemId) end
   return isBadFood[itemId]
end

function Dustman.IsBadDrink(itemId)
   if type(itemId) == "number" then itemId = tostring(itemId) end
   return isBadDrink[itemId] or false
end

function Dustman.IsRareStyle(itemStyle)
	return itemStyles[itemStyle]
end

function Dustman.IsFish(itemId)
   if type(itemId) == "number" then itemId = tostring(itemId) end
   return isFish[itemId] or false
end

function Dustman.IsOldIngredient(itemId)
   if type(itemId) == "number" then itemId = tostring(itemId) end
   return oldIngredients[itemId] or false
end

--Returns:
--recipeType, ingredientType 
-- recipeType:
--    1 = dish (stat increase)
--    2 = drink (stat regen)
-- ingredientType:
--    1 = health (meat / alcohol)
--    2 = magicka (fruit / tea)
--    3 = stamina (vegetable / tonic)
--    4 = additive
--    5 = rare additive
function Dustman.GetIngredientInfo(itemId)
   if type(itemId) == "number" then itemId = tostring(itemId) end

   local data = ingredients[itemId]
   if data then
      return unpack(data)
   end 
end
