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

    APC.frames.mainFrame.recipePriceContainer.selectRecipePriceButton.value = APC.defaultPrice
    APC.frames.mainFrame.recipePriceContainer.selectRecipePriceButton:UpdateValue()
    
    APC.frames.mainFrame.recipePriceContainer.priceChangedByUser = false
    APC.SetMoneyFrameCopper(APC.frames.mainFrame.recipePriceContainer.APCPriceBox, APC.selectedRecipe.price)
    
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

    row.recipePriceContainer.selectRecipePriceButton.value = APC.defaultPrice
    row.recipePriceContainer.selectRecipePriceButton:UpdateValue()
    
    row.recipePriceContainer.priceChangedByUser = false
    APC.SetMoneyFrameCopper(row.recipePriceContainer.APCPriceBox, reagentInfo.price)

    if reagentInfo.count > 1 then
        row.reagentCount:SetText(reagentInfo.count)
        row.reagentCount:Show()
    else
        row.reagentCount:Hide()
    end
end

APC.SetSelectedRecipe = function(name, recipeIndex)
    local newSelectedRecipe = {}
    local minMade, maxMade = GetTradeSkillNumMade(recipeIndex)
    local shouldItUpdate = true
    
    newSelectedRecipe.itemLink = GetTradeSkillItemLink(recipeIndex)
    if APC.selectedRecipe and newSelectedRecipe.itemLink == APC.selectedRecipe.itemLink then
        return false
    end

    newSelectedRecipe.name = name
    newSelectedRecipe.index = recipeIndex
    newSelectedRecipe.icon = GetTradeSkillIcon(recipeIndex)
    newSelectedRecipe.count = (minMade + maxMade) / 2
    newSelectedRecipe.reagents = {}
    newSelectedRecipe.reagents.offset = 0
    newSelectedRecipe.price = APC.GetPrice(newSelectedRecipe, APC.defaultPrice)

    for reagentIndex = 1, GetTradeSkillNumReagents(recipeIndex) do
        local currentReagent = {}
        local reagentName, reagentTexture, reagentCount = GetTradeSkillReagentInfo(recipeIndex, reagentIndex)
        local reagentItemLink = GetTradeSkillReagentItemLink(recipeIndex, reagentIndex)
        
        if reagentName == nil or reagentTexture == nil then
            shouldItUpdate = false
            break
        end

        currentReagent.name = reagentName
        currentReagent.icon = reagentTexture
        currentReagent.count = reagentCount
        currentReagent.itemLink = reagentItemLink
        currentReagent.price = APC.GetPrice(currentReagent, APC.defaultPrice)

        newSelectedRecipe.reagents[reagentIndex] = currentReagent
    end

    if shouldItUpdate then
        APC.selectedRecipe = newSelectedRecipe
        return true
    else
        return false
    end
end

APC.SetMoneyFrameCopper = function(moneyframe, price)
    if price then
        MoneyInputFrame_SetCopper(moneyframe, price)
    else
        MoneyInputFrame_SetCopper(moneyframe, 0)
    end
end

APC.GetPrice = function(item, priceType)
    if priceType == 'default' then
        if APC.defaultPrice == 'market' then
            return APC.GetMarketPrice(item.itemLink) or 0
        else
            return APC.GetAlgorithmPrice(APC.defaultPrice, item.itemLink) or 0
        end
    elseif priceType == 'market' then
        return APC.GetMarketPrice(item.itemLink) or 0
    elseif priceType == 'fixed' then
        return item.price
    else
        return APC.GetAlgorithmPrice(priceType, item.itemLink) or 0
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