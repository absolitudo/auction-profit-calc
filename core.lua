local ns = (select(2, ...))

ns.frames:initFrames()  

SLASH_AUCPROFITCALC1 = '/apc'
SlashCmdList['AUCPROFITCALC'] = function(...)
    if not ns.frames.mainFrame:IsShown() then
        ns.frames.mainFrame:Show()
    else
        ns.frames.mainFrame:Hide()
    end
end