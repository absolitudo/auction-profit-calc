local ns = (select(2, ...))
local APC = ns

APC.defaultPrice = 'market'

APC.frames = {
    mainFrame = {}
}

APC.priceList = {
    [1] = {
        [1] = 'market',
        [2] = 'Market'
    },
    [2] = {
        [1] = 'VendMarkup',
        [2] = 'Stats: VendMarkup'
    },
    [3] = {
        [1] = 'Histogram',
        [2] = 'Stats: Histogram'
    },
    [4] = {
        [1] = 'iLevel',
        [2] = 'Stats: iLevel'
    },
    [5] = {
        [1] = 'Purchased',
        [2] = 'Stats: Purchased'
    },
    [6] = {
        [1] = 'Sales',
        [2] = 'Stats: Sales'
    },
    [7] = {
        [1] = 'Simple',
        [2] = 'Stats: Simple'
    },
    [8] = {
        [1] = 'StdDev',
        [2] = 'Stats: StdDev'
    },
    [9] = {
        [1] = 'fixed',
        [2] = 'Fixed price'
    },
    [10] = {
        [1] = 'default',
        [2] = 'Default'
    }
}

APC.GetMarketPrice = AucAdvanced.API.GetMarketValue
APC.GetAlgorithmPrice = AucAdvanced.API.GetAlgorithmValue

APC.UpdateSelectedRecipeInMainFrame = function()
    APC.frames.mainFrame.selectedRecipeIcon.texture:SetTexture(APC.selectedRecipe.icon)
    APC.frames.mainFrame.selectedRecipeName:SetText(APC.selectedRecipe.name)
    if APC.selectedRecipe.count > 1 then
        APC.frames.mainFrame.selectedRecipeCount:SetText(APC.selectedRecipe.count)
        APC.frames.mainFrame.selectedRecipeCount:Show()
    else
        APC.frames.mainFrame.selectedRecipeCount:Hide()
    end
end

APC.UpdateScrollFrameRow = function(row, reagentInfo)
    row.reagentName:SetText(reagentInfo.name)
    row.reagentIcon.texture:SetTexture(reagentInfo.icon)
    if reagentInfo.count > 1 then
        row.reagentCount:SetText(reagentInfo.count)
        row.reagentCount:Show()
    else
        row.reagentCount:Hide()
    end
end

APC.SetSelectedRecipe = function(recipeIndex)
    local newSelectedRecipe = {}
    local minMade, maxMade = GetTradeSkillNumMade(recipeIndex)
    local shouldItUpdate = true
    
    newSelectedRecipe.name = name
    newSelectedRecipe.index = recipeIndex
    newSelectedRecipe.icon = GetTradeSkillIcon(recipeIndex)
    newSelectedRecipe.count = (minMade + maxMade) / 2
    newSelectedRecipe.reagents = {}
    newSelectedRecipe.itemLink = GetTradeSkillItemLink(recipeIndex)

    for reagentIndex = 1, GetTradeSkillNumReagents(recipeIndex) do
        local reagentName, reagentTexture, reagentCount = GetTradeSkillReagentInfo(recipeIndex, reagentIndex)
        if reagentName == nil or reagentTexture == nil then
            shouldItUpdate = false
            break
        end
        local reagentItemLink = GetTradeSkillReagentItemLink(recipeIndex, reagentIndex)
        newSelectedRecipe.reagents[reagentIndex] = {
            name = reagentName,
            icon = reagentTexture,
            count = reagentCount,
            itemLink = reagentItemLink
        }
    end
    if shouldItUpdate then
        APC.selectedRecipe = newSelectedRecipe
        return true
    else
        return false
    end
end

function logTable(table)
    for key, value in pairs(table) do
         print(key, value)
         if type(value) == 'table' then
             logTable(value)
             print('---')
        end
    end
end