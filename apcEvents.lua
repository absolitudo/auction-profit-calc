local ns = (select(2, ...))
local APC = ns
local processors = AucAdvanced.Modules.Util.Appraiser.Processors
local clearMarketCache = AucAdvanced.API.ClearMarketCache

hooksecurefunc(processors, 'scanfinish', function() 
    clearMarketCache()
    APC.RefreshSelectedRecipePrice()

    if APC.frames.mainFrame:IsShown() then
        APC.frames.mainFrame:UpdateSelectedRecipeView()
        APC.frames.mainFrame.scrollFrame:Update()
    else
        APC.updateOnShow = true
    end
end)

local function TradeSkillRecipeSelectionHook(recipeIndex)
    local name, skillType = GetTradeSkillInfo(recipeIndex)
    if skillType ~= 'header' and skillType ~= nil and skillType ~= 'subheader' then
        if APC.SetSelectedRecipe(name, recipeIndex) then
            APC.frames.mainFrame:UpdateSelectedRecipeView()
            if APC.updateOnShow then
                APC.updateOnShow = false
            end
        elseif APC.updateOnShow then
            APC.frames.mainFrame:UpdateSelectedRecipeView()
            APC.frames.mainFrame.scrollFrame:Update()
            APC.updateOnShow = false
        end
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

APC.RegisterEvents = function(self)
    local APCtradeSkillEvents = CreateFrame("FRAME", "APCTradeSkillEvent")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_SHOW")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_CLOSE")
    APCtradeSkillEvents:RegisterEvent("ADDON_LOADED")
    APCtradeSkillEvents:SetScript("OnEvent", APCtradeSkillEventsHandler)
end