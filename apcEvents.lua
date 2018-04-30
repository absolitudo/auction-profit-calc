local ns = (select(2, ...))
local APC = ns

local function APCtradeSkillEventsHandler(self, event, ...)
    if event == 'TRADE_SKILL_SHOW' then
        if(not APC.frames.mainFrame:IsVisible()) then
            APC.frames.mainFrame:ShowFrame()
        end
    elseif event == 'TRADE_SKILL_CLOSE' then
        if(APC.frames.mainFrame:IsVisible()) then
            APC.frames.mainFrame:Hide()
        end
    elseif event == 'ADDON_LOADED' and ... == 'Blizzard_TradeSkillUI' then
        APCtradeSkillEvents:UnregisterEvent('ADDON_LOADED')
        hooksecurefunc("TradeSkillFrame_SetSelection",
            function(id) 
                print(id)
            end
        )
    end
end

function APC:registerEvents()
    local APCtradeSkillEvents = CreateFrame("FRAME", "APCTradeSkillEvent")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_SHOW")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_CLOSE")
    APCtradeSkillEvents:RegisterEvent("ADDON_LOADED")
    APCtradeSkillEvents:SetScript("OnEvent", APCtradeSkillEventsHandler)
end
