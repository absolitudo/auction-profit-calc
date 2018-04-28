local ns = (select(2, ...))
local APC = ns

APC.frames:initFrames()
APC:registerEvents()

APC.scanData = {}
APC.professions = {}

prof1, prof2, _, _, cooking = GetProfessions()
APC.professions[1] = function() return GetProfessionInfo(prof1) end
APC.professions[2] = function() return GetProfessionInfo(prof2) end

--ns.professions['cooking'] = GetProfessionInfo(cooking)




local function logTable(table)
    for key, value in pairs(table) do
        print(key, value)
        if type(value) == 'table' then
            logTable(value)
            print('---')
        end
    end
end
--ns.frames.initFrames()
-- _G.AucAdvanced.GetFaction this is the server key
-- _G.AucAdvanced.Modules.Util.ScanData.GetScanData this is the scan data requires serverkey
SLASH_AUCPROFITCALC1 = '/apc'
SlashCmdList['AUCPROFITCALC'] = function(...)
    local params = ...
    if params == '' then
        print(TradeSkillFrame:GetWidth())
        print(TradeSkillFrame:GetHeight())
        
    end
    if params == 'load' then
        --print('loading scan data')
        --_G.AucAdvanced.Scan.LoadScanData()
        --ns.scanData = _G.AucAdvanced.Modules.Util.ScanData.GetScanData(_G.AucAdvanced.GetFaction())
        
        print(APC.professions[1]())
        print(APC.professions[2]())
        
    end

    --if not ns.frames.mainFrame:IsShown() then
    --    ns.frames.mainFrame:Show()
    --else
    --    ns.frames.mainFrame:Hide()
    --end
end

