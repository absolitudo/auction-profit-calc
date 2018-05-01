local ns = (select(2, ...))
local APC = ns

local function logTable(table)
   for key, value in pairs(table) do
        print(key, value)
        if type(value) == 'table' then
            logTable(value)
            print('---')
       end
    end
end

local function getSelectedRecipeInfo(recipeIndex)
    local recipeInfo = {}
    recipeInfo.name = GetTradeSkillInfo(recipeIndex)
    recipeInfo.icon = GetTradeSkillIcon(recipeIndex)
    recipeInfo.reagents = {}
    for reagentIndex = 1, GetTradeSkillNumReagents(recipeIndex) do
        local reagentName, reagentTexture, reagentCount = GetTradeSkillReagentInfo(recipeIndex, reagentIndex)

        recipeInfo.reagents[reagentIndex] = {
            name = reagentName,
            icon = reagentTexture,
            count = reagentCount
        }
    end
    return recipeInfo
end

local function tradeSkillRecipeSelectionHook(recipeIndex)
    if APC.selectedRecipeIndex ~= recipeIndex then
        APC.selectedRecipeIndex = recipeIndex
        selectedRecipeInfo = getSelectedRecipeInfo(recipeIndex)
        logTable(selectedRecipeInfo)
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
        hooksecurefunc("TradeSkillFrame_SetSelection", tradeSkillRecipeSelectionHook)
    end
end

function APC:registerEvents()
    local APCtradeSkillEvents = CreateFrame("FRAME", "APCTradeSkillEvent")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_SHOW")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_CLOSE")
    APCtradeSkillEvents:RegisterEvent("ADDON_LOADED")
    APCtradeSkillEvents:SetScript("OnEvent", APCtradeSkillEventsHandler)
end
