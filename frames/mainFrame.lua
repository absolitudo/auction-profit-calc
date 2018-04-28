local ns = (select(2, ...))
local APC = ns
APC.frames = {
    mainFrame = {}
}

function APC.frames.initFrames()
    APC.frames.mainFrame:initFrame()
end

function APC.frames.mainFrame:initFrame()
    APC.frames.mainFrame = CreateFrame("Frame", "AucProfitCalc", UIParent, 'BasicFrameTemplate')
    APC.frames.mainFrame:SetMovable(true)
    APC.frames.mainFrame:SetWidth(338)
    APC.frames.mainFrame:SetHeight(424)
    APC.frames.mainFrame:Hide()

    function APC.frames.mainFrame:ShowFrame()
        APC.frames.mainFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT")
        APC.frames.mainFrame:Show()
    end
end
