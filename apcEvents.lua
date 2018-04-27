local ns = (select(2, ...))
local APC = ns

local function APCtradeSkillEventsHandler(self, event, ...)
    print(event)
end

function APC:registerEvents()
    local APCtradeSkillEvents = CreateFrame("FRAME", "APCTradeSkillEvent")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_SHOW")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_UPDATE")
    APCtradeSkillEvents:RegisterEvent("TRADE_SKILL_CLOSE")
    APCtradeSkillEvents:SetScript("OnEvent", APCtradeSkillEventsHandler)
end
