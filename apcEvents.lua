local ns = (select(2, ...))
local APC = ns
APC.selectedRecipe = {}

local function logTable(table)
   for key, value in pairs(table) do
        print(key, value)
        if type(value) == 'table' then
            logTable(value)
            print('---')
       end
    end
end

local function TradeSkillRecipeSelectionHook(recipeIndex)
    local name, skillType = GetTradeSkillInfo(recipeIndex)
    if skillType ~= 'header' and skillType ~= nil and ~= 'subheader' then
        local newSelectedRecipe = {}
        local minMade, maxMade = GetTradeSkillNumMade(recipeIndex)
        
        newSelectedRecipe.name = name
        newSelectedRecipe.index = recipeIndex
        newSelectedRecipe.icon = GetTradeSkillIcon(recipeIndex)
        newSelectedRecipe.count = (minMade + maxMade) / 2
        newSelectedRecipe.reagents = {}
        
        for reagentIndex = 1, GetTradeSkillNumReagents(recipeIndex) do
            local reagentName, reagentTexture, reagentCount = GetTradeSkillReagentInfo(recipeIndex, reagentIndex)
            newSelectedRecipe.reagents[reagentIndex] = {
                name = reagentName,
                icon = reagentTexture,
                count = reagentCount
            }
        end
        
        APC.selectedRecipe = newSelectedRecipe
        APC.frames.mainFrame:UpdateSelectedRecipeView()
    end
end

local function APCtradeSkillEventsHandler(self, event, ...)
    if event == 'TRADE_SKILL_SHOW' then
        if not APC.frames.mainFrame:IsVisible() then
            APC.frames.mainFrame:ShowFrame()
        end
    elseif event == 'TRADE_SKILL_CLOSE' then
        if APC.frames.mainFrame:IsVisible() then
            APC.frames.mainFrame:Hide()
        end
    elseif event == 'ADDON_LOADED' and ... == 'Blizzard_TradeSkillUI' then
        self:UnregisterEvent('ADDON_LOADED')
        hooksecurefunc("TradeSkillFrame_SetSelection", TradeSkillRecipeSelectionHook)
    end
end

function APC:RegisterEvents()
    local APCtradeSkillEvents = CreateFrame("FRAME", "APCTradeSkillEvent")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_SHOW")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_CLOSE")
    APCtradeSkillEvents:RegisterEvent("ADDON_LOADED")
    APCtradeSkillEvents:SetScript("OnEvent", APCtradeSkillEventsHandler)
end
