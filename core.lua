local ns = (select(2, ...))
ns.scanData = {}
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
       logTable(ns.scanData)
        
    end
    if params == 'load' then
        print('loading scan data')
        _G.AucAdvanced.Scan.LoadScanData()
        ns.scanData = _G.AucAdvanced.Modules.Util.ScanData.GetScanData(_G.AucAdvanced.GetFaction())
    end

    --if not ns.frames.mainFrame:IsShown() then
    --    ns.frames.mainFrame:Show()
    --else
    --    ns.frames.mainFrame:Hide()
    --end
end

