local ns = (select(2, ...))
local APC = ns

local function APCTradeSkillUpdate()

end

local function APCtradeSkillEventsHandler(self, event, ...)
    print(...)
    if(event == 'TRADE_SKILL_SHOW') then
        if(not APC.frames.mainFrame:IsVisible()) then
            APC.frames.mainFrame:ShowFrame()
        end
    elseif event == 'TRADE_SKILL_CLOSE' then
        if(APC.frames.mainFrame:IsVisible()) then
            APC.frames.mainFrame:Hide()
        end
    else
        APCTradeSkillUpdate()
    end
end

function APC:registerEvents()
    local APCtradeSkillEvents = CreateFrame("FRAME", "APCTradeSkillEvent")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_SHOW")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_UPDATE")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_CLOSE")
    APCtradeSkillEvents:SetScript("OnEvent", APCtradeSkillEventsHandler)
end
